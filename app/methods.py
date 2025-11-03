import json
import re
from typing import List, Any
from datetime import datetime, timedelta
from fastapi import HTTPException
import httpx
from sqlalchemy import select
from sqlalchemy.ext.asyncio import AsyncSession
from app.db import AsyncSessionLocal
from app.models import Token

def calculate_sea_level_mean(slevel, mean):
    return float(slevel) - abs(float(mean))

def apply_intervals(data: List[dict], interval: int) -> List[dict]:
    if not data or interval <= 0:
        return data
    return [data[i] for i in range(0, len(data), interval + 1)]

def filter_bad_data(data: List[dict], bad_data_str: str) -> List[dict]:
    """
    Filter out bad data values and replace them with -999
    """
    if not bad_data_str or not data:
        return data
    
    # Parse comma-separated bad data values
    bad_data_values = [val.strip() for val in bad_data_str.split(',') if val.strip()]
    if not bad_data_values:
        return data
    
    # Time-related fields to skip
    time_fields = {'time', 'timestamp', 'obs_time_utc', 'stime', 'date', 'datetime'}
    
    filtered_data = []
    for entry in data:
        filtered_entry = {}
        for key, value in entry.items():
            # Skip time-related fields
            if key.lower() in time_fields:
                filtered_entry[key] = value
            else:
                # Check if value matches any bad data value
                if str(value) in bad_data_values:
                    filtered_entry[key] = "-999"
                else:
                    filtered_entry[key] = value
        filtered_data.append(filtered_entry)
    
    return filtered_data

async def spot_method(station, limit=100, start: str = None, end: str = None) -> List[dict]:
    """
    Fetch data from station's source_url, sort by timestamp, and transform column names
    """
    try:
        source_url = station.source_url
        variable_id = station.variable_id or ''
        variable_label = station.variable_label or ''
        
        # Replace token placeholder if station has a token_id
        if station.token_id and "REPALCE_TOKEN_STRING" in source_url:
            async with AsyncSessionLocal() as db:
                result = await db.execute(select(Token).where(Token.id == station.token_id))
                token_obj = result.scalar_one_or_none()
                if token_obj:
                    source_url = source_url.replace("REPALCE_TOKEN_STRING", token_obj.token)
        
        id_columns = [col.strip() for col in variable_id.split(',') if col.strip()]
        label_columns = [col.strip() for col in variable_label.split(',') if col.strip()]
        if len(id_columns) != len(label_columns):
            return []
        column_mapping = dict(zip(id_columns, label_columns))
        async with httpx.AsyncClient(verify=False) as client:
            response = await client.get(source_url)
            response.raise_for_status()
            data = response.json()
        waves_data = data.get('data', {}).get('waves', [])
        if not waves_data:
            return []
        def parse_timestamp(timestamp_str):
            try:
                return datetime.fromisoformat(timestamp_str.replace('Z', '+00:00'))
            except:
                return datetime.min
        sorted_waves = sorted(
            waves_data,
            key=lambda x: parse_timestamp(x.get('timestamp', '')),
            reverse=True
        )
        transformed_waves = []
        for wave in sorted_waves:
            transformed_wave = {}
            for old_key, new_key in column_mapping.items():
                if old_key in wave:
                    transformed_wave[new_key] = wave[old_key]
            transformed_waves.append(transformed_wave)
        interval = int(getattr(station, 'intervals', 0) or 0)
        filtered_data = filter_bad_data(transformed_waves[:limit], getattr(station, 'bad_data', None))
        # Datetime filter
        if start or end:
            def in_range(entry):
                t = entry.get('time') or entry.get('timestamp') or entry.get('obs_time_utc') or entry.get('stime') or entry.get('date') or entry.get('datetime')
                if not t:
                    return False
                try:
                    dt = datetime.fromisoformat(t.replace('Z', '+00:00'))
                except:
                    return False
                if start:
                    try:
                        start_dt = datetime.fromisoformat(start.replace('Z', '+00:00'))
                        if dt < start_dt:
                            return False
                    except:
                        pass
                if end:
                    try:
                        end_dt = datetime.fromisoformat(end.replace('Z', '+00:00'))
                        if dt > end_dt:
                            return False
                    except:
                        pass
                return True
            filtered_data = [d for d in filtered_data if in_range(d)]
        return apply_intervals(filtered_data, interval)
    except Exception as e:
        return []

async def pacioos_method(station, limit=100, start: str = None, end: str = None) -> List[dict]:
    """
    Parse GeoJSON wave data, map field names, and return sorted wave entries.
    """
    try:
        source_url = station.source_url
        variable_id = station.variable_id or ''
        variable_label = station.variable_label or ''
        now = datetime.now()
        end_time = now.isoformat(timespec='seconds') + "Z"
        start_time = (now - timedelta(days=7)).isoformat(timespec='seconds') + "Z"
        source_url = station.source_url.replace("START_TIME", start_time)
        source_url = source_url.replace("END_TIME", end_time)
        source_url = source_url.replace("STATION_ID", station.station_id)
        print (source_url)
        # return f"start:{start_time} \n end:{end_time} \n url:{source_url}"
        id_columns = [col.strip() for col in variable_id.split(',') if col.strip()]
        label_columns = [col.strip() for col in variable_label.split(',') if col.strip()]
        if len(id_columns) != len(label_columns):
            return []
        column_mapping = dict(zip(id_columns, label_columns))
        async with httpx.AsyncClient(verify=False) as client:
            response = await client.get(source_url)
            response.raise_for_status()
            data = response.json()
        features = data.get("features", [])
        if not features:
            return []
        def parse_timestamp(ts: str):
            try:
                return datetime.fromisoformat(ts.replace("Z", "+00:00"))
            except:
                return datetime.min
        transformed_waves = []
        for feature in features:
            props = feature.get("properties", {})
            coords = feature.get("geometry", {}).get("coordinates", [])
            if not props or len(coords) != 2:
                continue
            transformed_wave = {}
            for old_key, new_key in column_mapping.items():
                if old_key in props:
                    transformed_wave[new_key] = props[old_key]
            transformed_wave["lon_deg"] = coords[0]
            transformed_wave["lat_deg"] = coords[1]
            transformed_waves.append(transformed_wave)
        sorted_waves = sorted(
            transformed_waves,
            key=lambda x: parse_timestamp(x.get("obs_time_utc", "")),
            reverse=True
        )
        interval = int(getattr(station, 'intervals', 0) or 0)
        filtered_data = filter_bad_data(sorted_waves[:limit], getattr(station, 'bad_data', None))
        # Datetime filter
        if start or end:
            def in_range(entry):
                t = entry.get('time') or entry.get('timestamp') or entry.get('obs_time_utc') or entry.get('stime') or entry.get('date') or entry.get('datetime')
                if not t:
                    return False
                try:
                    dt = datetime.fromisoformat(t.replace('Z', '+00:00'))
                except:
                    return False
                if start:
                    try:
                        start_dt = datetime.fromisoformat(start.replace('Z', '+00:00'))
                        if dt < start_dt:
                            return False
                    except:
                        pass
                if end:
                    try:
                        end_dt = datetime.fromisoformat(end.replace('Z', '+00:00'))
                        if dt > end_dt:
                            return False
                    except:
                        pass
                return True
            filtered_data = [d for d in filtered_data if in_range(d)]
        return apply_intervals(filtered_data, interval)
    except Exception as e:
        return []



async def dart_method(station, limit=100, start: str = None, end: str = None) -> List[dict]:
    """
    Parse NDBC DART data from text format, map field names, and return sorted entries.
    """
    try:
        source_url = station.source_url
        variable_id = station.variable_id or ''
        variable_label = station.variable_label or ''
        
        # Calculate date range (7 days ago to today)
        now = datetime.now()
        end_date = now
        start_date = now - timedelta(days=7)
        
        # Replace placeholders in the URL
        source_url = source_url.replace("STATION_ID", station.station_id)
        source_url = source_url.replace("START_MONTH", str(start_date.month))
        source_url = source_url.replace("START_DAY", str(start_date.day))
        source_url = source_url.replace("START_YEAR", str(start_date.year))
        source_url = source_url.replace("END_MONTH", str(end_date.month))
        source_url = source_url.replace("END_DAY", str(end_date.day))
        source_url = source_url.replace("END_YEAR", str(end_date.year))
        
        # Parse column mappings
        id_columns = [col.strip() for col in variable_id.split(',') if col.strip()]
        label_columns = [col.strip() for col in variable_label.split(',') if col.strip()]
        if len(id_columns) != len(label_columns):
            return []
        column_mapping = dict(zip(id_columns, label_columns))
        
        # Fetch data
        async with httpx.AsyncClient(verify=False) as client:
            response = await client.get(source_url)
            response.raise_for_status()
            data_text = response.text
        
        # Parse the text response
        lines = data_text.strip().split('\n')
        transformed_data = []
        
        for line in lines:
            # Skip header lines and empty lines
            if line.startswith('#') or not line.strip():
                continue
            
            # Parse data line: YY MM DD hh mm ss T HEIGHT
            parts = line.strip().split()
            if len(parts) >= 8:
                try:
                    year = int(parts[0])
                    month = int(parts[1])
                    day = int(parts[2])
                    hour = int(parts[3])
                    minute = int(parts[4])
                    second = int(parts[5])
                    height = float(parts[7])
                    
                    # Create datetime object
                    dt = datetime(year, month, day, hour, minute, second)
                    
                    
                    station_mean = station.mean if hasattr(station, 'mean') else 0
                    if station_mean != 0:
                        height = calculate_sea_level_mean(height, station_mean)
                        # print(f"mean: {height}")
                    data_entry = {
                        'time': dt.isoformat(timespec='seconds') + "Z",
                        'm': height,
                        'lon_deg': station.longitude,
                        'lat_deg': station.latitude
                    }
                    
                    # Transform to label names
                    transformed_entry = {}
                    for old_key, new_key in column_mapping.items():
                        if old_key in data_entry:
                            transformed_entry[new_key] = data_entry[old_key]
                    
                    transformed_data.append(transformed_entry)
                    
                except (ValueError, IndexError):
                    continue
        
        # Sort by date/time (newest first)
        def parse_timestamp(entry):
            try:
                timestamp_str = entry.get('time', '') or entry.get('obs_time_utc', '')
                if timestamp_str:
                    # Handle different timestamp formats
                    if 'Z' in timestamp_str:
                        return datetime.fromisoformat(timestamp_str.replace('Z', '+00:00'))
                    elif '+' in timestamp_str:
                        return datetime.fromisoformat(timestamp_str)
                    else:
                        # Try parsing as ISO format without timezone
                        return datetime.fromisoformat(timestamp_str)
                return datetime.min
            except:
                return datetime.min
        
        sorted_data = sorted(
            transformed_data,
            key=lambda x: parse_timestamp(x),
            reverse=True
        )
        
        interval = int(getattr(station, 'intervals', 0) or 0)
        filtered_data = filter_bad_data(sorted_data[:limit], getattr(station, 'bad_data', None))
        # Datetime filter
        if start or end:
            def in_range(entry):
                t = entry.get('time') or entry.get('timestamp') or entry.get('obs_time_utc') or entry.get('stime') or entry.get('date') or entry.get('datetime')
                if not t:
                    return False
                try:
                    dt = datetime.fromisoformat(t.replace('Z', '+00:00'))
                except:
                    return False
                if start:
                    try:
                        start_dt = datetime.fromisoformat(start.replace('Z', '+00:00'))
                        if dt < start_dt:
                            return False
                    except:
                        pass
                if end:
                    try:
                        end_dt = datetime.fromisoformat(end.replace('Z', '+00:00'))
                        if dt > end_dt:
                            return False
                    except:
                        pass
                return True
            filtered_data = [d for d in filtered_data if in_range(d)]
        return apply_intervals(filtered_data, interval)
    
    except Exception as e:
        return []

async def ioc_method(station, limit=100, start: str = None, end: str = None) -> List[dict]:
    """
    Parse IOC sea level monitoring data, map field names, and return sorted entries.
    """
    try:
        # # print("=== IOC METHOD START ===")
        source_url = station.source_url
        variable_id = station.variable_id or ''
        variable_label = station.variable_label or ''
        # # print(f"Source URL: {source_url}")
        # # print(f"Variable ID: {variable_id}")
        # # print(f"Variable Label: {variable_label}")
        
        # Calculate date range (7 days ago to today)
        now = datetime.now()
        end_time = now.isoformat(timespec='seconds') + "Z"
        start_time = (now - timedelta(days=7)).isoformat(timespec='seconds') + "Z"
        
        # Replace placeholders in the URL
        source_url = source_url.replace("STATION_ID", station.station_id)
        source_url = source_url.replace("TIME_START", start_time)
        source_url = source_url.replace("TIME_END", end_time)
        
        # # print(f"Station ID: {station.station_id}")
        # # print(f"Start time: {start_time}")
        # # print(f"End time: {end_time}")
        # print(f"Final URL: {source_url}")
        
        # Get API key from token if station has a token_id
        api_key = None
       
        if station.token_id:
            async with AsyncSessionLocal() as db:
                result = await db.execute(select(Token).where(Token.id == station.token_id))

                token_obj = result.scalar_one_or_none()
                if token_obj:
                    api_key = token_obj.token
                    # # print(f"API Key found: {api_key}")
        
        # Parse column mappings
        # # print("=== COLUMN MAPPING DEBUG ===")
        # # print(f"Variable ID (raw): '{variable_id}'")
        # # print(f"Variable Label (raw): '{variable_label}'")
        
        id_columns = [col.strip() for col in variable_id.split(',') if col.strip()]
        label_columns = [col.strip() for col in variable_label.split(',') if col.strip()]
        
        # print(f"ID columns: {id_columns}")
        # print(f"Label columns: {label_columns}")
        # print(f"ID columns length: {len(id_columns)}")
        # print(f"Label columns length: {len(label_columns)}")
        
        if len(id_columns) != len(label_columns):
            # print("Column lengths don't match, returning empty")
            return []
        
        column_mapping = dict(zip(id_columns, label_columns))
        # print(f"Column mapping: {column_mapping}")
        # print("=== END COLUMN MAPPING DEBUG ===")
        
        # Prepare headers for the request
        headers = {
            'Accept': 'application/json'
        }
        if api_key:
            headers['X-API-KEY'] = api_key
        # print(f"Headers: {headers}")
        # print("About to make HTTP request...")
        
        # Fetch data
        # # print("Starting HTTP request...")
        async with httpx.AsyncClient(verify=False) as client:
            # print("HTTP client created, making request...")
            response = await client.get(source_url, headers=headers)
            # print("HTTP request completed!")
            response.raise_for_status()
            data = response.json()
            
            # print(f"Response status: {response.status_code}")
            # print(f"Data type: {type(data)}")
            # print(f"Data content: {data}")
            # print(f"Data length: {len(data) if isinstance(data, list) else 'N/A'}")
            
            # The data is a list of dicts with keys: slevel, stime, sensor
            if not isinstance(data, list):
                # print("Data is not a list, returning empty")
                return []
        
        transformed_data = []
        for point in data:
            try:
                # convert stime to ISO 8601 UTC
                stime_raw = point.get('stime', '').strip()
                # Convert 'YYYY-MM-DD HH:MM:SS' to ISO 8601 with Z
                if stime_raw:
                    dt = datetime.strptime(stime_raw, "%Y-%m-%d %H:%M:%S")
                    iso_time = dt.isoformat(timespec='seconds') + "Z"
                else:
                    iso_time = ''
                # Build the mapping input dict
                station_mean = station.mean if hasattr(station, 'mean') else 0
                
                # calculate mean
                if station_mean != 0:
                    height = calculate_sea_level_mean(point.get('slevel'), station_mean)                    
                else:
                    height = point.get('slevel')

                mapping_input = {
                    'slevel': height,
                    'stime': iso_time,
                    'sensor': point.get('sensor'),
                    'lon_deg': station.longitude,
                    'lat_deg': station.latitude
                }
                # Map to output keys
                transformed_entry = {}
                for old_key, new_key in column_mapping.items():
                    if old_key in mapping_input:
                        transformed_entry[new_key] = mapping_input[old_key]
                transformed_data.append(transformed_entry)
            except Exception:
                continue
        # Sort by time (newest first)
        def parse_timestamp(entry):
            try:
                for key in entry:
                    if 'time' in key:
                        timestamp_str = entry[key]
                        if timestamp_str:
                            if 'Z' in timestamp_str:
                                return datetime.fromisoformat(timestamp_str.replace('Z', '+00:00'))
                            elif '+' in timestamp_str:
                                return datetime.fromisoformat(timestamp_str)
                            else:
                                return datetime.fromisoformat(timestamp_str)
                return datetime.min
            except:
                return datetime.min
        sorted_data = sorted(
            transformed_data,
            key=lambda x: parse_timestamp(x),
            reverse=True
        )
        interval = int(getattr(station, 'intervals', 0) or 0)
        filtered_data = filter_bad_data(sorted_data[:limit], getattr(station, 'bad_data', None))
        # Datetime filter
        if start or end:
            def in_range(entry):
                t = entry.get('time') or entry.get('timestamp') or entry.get('obs_time_utc') or entry.get('stime') or entry.get('date') or entry.get('datetime')
                if not t:
                    return False
                try:
                    dt = datetime.fromisoformat(t.replace('Z', '+00:00'))
                except:
                    return False
                if start:
                    try:
                        start_dt = datetime.fromisoformat(start.replace('Z', '+00:00'))
                        if dt < start_dt:
                            return False
                    except:
                        pass
                if end:
                    try:
                        end_dt = datetime.fromisoformat(end.replace('Z', '+00:00'))
                        if dt > end_dt:
                            return False
                    except:
                        pass
                return True
            filtered_data = [d for d in filtered_data if in_range(d)]
        return apply_intervals(filtered_data, interval)
    except Exception as e:
        # print(f"=== IOC METHOD ERROR: {str(e)} ===")
        return []

async def refresh_neon_token() -> dict:
    """
    Authenticate with NEON API and return a new token.
    Automatically updates the token in the database.
    
    Returns:
        dict with keys: { 'token': str, 'session_id': str }
    """
    login_url = "https://restservice-neon.niwa.co.nz/NeonRESTService.svc/PostSession"
    
    async with AsyncSessionLocal() as db:
        # Get NEON credentials
        result = await db.execute(
            select(Token).where(Token.comments == "neon_cred")
        )
        neon_cred_obj = result.scalar_one_or_none()
        
        if not neon_cred_obj:
            print("Error: neon_cred not found in database")
            return None
        
        # Parse credentials (format: username/password)
        cred_parts = neon_cred_obj.token.split('/')
        if len(cred_parts) != 2:
            print("Error: neon_cred format invalid. Expected 'username/password'")
            return None
        
        username, password = cred_parts[0].strip(), cred_parts[1].strip()
        
        payload = {
            "Username": username,
            "Password": password
        }
        
        headers = {
            'Content-Type': 'application/json'
        }
        
        try:
            async with httpx.AsyncClient(verify=False) as client:
                response = await client.post(login_url, json=payload, headers=headers)
                response.raise_for_status()
                data = response.json()
                new_token = data.get("Token")
                session_id = response.cookies.get("ASP.NET_SessionId")
                
                if not new_token:
                    print("Error: No token received from NEON API")
                    return None
                if not session_id:
                    print("Error: No ASP.NET_SessionId cookie received from NEON API")
                    return None
                
                # Update the neon_token in database
                result = await db.execute(
                    select(Token).where(Token.comments == "neon_token")
                )
                token_obj = result.scalar_one_or_none()
                
                if token_obj:
                    token_obj.token = new_token
                    await db.commit()
                    print(f"✓ NEON token refreshed successfully: {new_token[:20]}...")
                else:
                    print("Error: neon_token entry not found in database")
                    return None

                # Upsert the neon_cookie (ASP.NET_SessionId)
                result_cookie = await db.execute(
                    select(Token).where(Token.comments == "neon_cookie")
                )
                cookie_obj = result_cookie.scalar_one_or_none()
                if cookie_obj:
                    cookie_obj.token = session_id
                else:
                    cookie_obj = Token(token=session_id, comments="neon_cookie")
                    db.add(cookie_obj)
                await db.commit()
                
                return {"token": new_token, "session_id": session_id}
                
        except httpx.HTTPStatusError as e:
            print(f"NEON authentication failed: {e.response.status_code} - {str(e)}")
            return None
        except Exception as e:
            print(f"Error refreshing NEON token: {str(e)}")
            return None


async def actual_neon_method(station, token: str, session_id: str, limit=100, start: str = None, end: str = None) -> List[dict]:
    """
    Fetch and process data from NIWA NEON REST service.
    
    Args:
        station: Station object with configuration
        token: Valid NEON authentication token
        limit: Maximum number of records to return
        start: Start datetime filter (ISO format)
        end: End datetime filter (ISO format)
    
    Returns:
        List of processed data records
    """
    # Build URL and mapping; let HTTP errors bubble up so caller can refresh token
    source_url = station.source_url
    variable_id = station.variable_id or ''
    variable_label = station.variable_label or ''

    # Calculate date range per requirement
    now = datetime.now()
    # End time: date of request at the very beginning (00:00:00)
    end_time = now.replace(hour=0, minute=0, second=0, microsecond=0)
    # Start time: 5 days ago with the max time (23:59:59)
    start_time = (now - timedelta(days=5)).replace(hour=23, minute=59, second=59, microsecond=0)

    # Format times for URL (no colon encoding to match expected format)
    start_time_str = start_time.strftime("%Y-%m-%dT%H:%M:%S")
    end_time_str = end_time.strftime("%Y-%m-%dT%H:%M:%S")

    # Replace placeholders in URL
    source_url = source_url.replace("START_TIME", start_time_str)
    source_url = source_url.replace("END_TIME", end_time_str)

    # Ensure query params are correctly separated (defensive fix if template misses &)
    # Make sure Interval= and Method= are preceded by & or ?
    source_url = re.sub(r'(?<![&?])Interval=', r'&Interval=', source_url)
    source_url = re.sub(r'(?<![&?])Method=', r'&Method=', source_url)

    print(f"NEON API URL: {source_url}")

    # Parse column mappings
    id_columns = [col.strip() for col in variable_id.split(',') if col.strip()]
    label_columns = [col.strip() for col in variable_label.split(',') if col.strip()]

    if len(id_columns) != len(label_columns):
        print("Error: Column mapping mismatch")
        return []

    # Build a case-insensitive mapping from source keys -> output labels
    column_mapping = dict(zip(id_columns, label_columns))
    ci_mapping = {k.strip().lower(): v.strip() for k, v in column_mapping.items()}

    # Prepare headers and cookies per NEON requirements
    headers = {
        'X-Authentication-Token': str(token),
        'Content-Type': 'application/json',
        'Accept': 'application/json'
    }
    cookies = {}
    if session_id:
        cookies["ASP.NET_SessionId"] = str(session_id)

    # Make API call (let HTTPStatusError propagate)
    async with httpx.AsyncClient(verify=False) as client:
        response = await client.get(source_url, headers=headers, cookies=cookies)
        response.raise_for_status()
        data = response.json()

    # Extract and transform samples safely
    try:
        result_data = data.get("GetDataResampledResult", {}) if isinstance(data, dict) else {}
        samples = result_data.get("Samples", []) if isinstance(result_data, dict) else []
        print(f"NEON samples retrieved: {len(samples)}")
        if not samples:
            return []

        transformed_data = []
        for sample in samples:
            raw_val = sample.get('Value')
            try:
                val_num = float(raw_val) if raw_val is not None and raw_val != '' else None
            except:
                val_num = None
            sample_dict = {
                'Time': sample.get('Time'),
                'Value': val_num if val_num is not None else raw_val,
                'lon_deg': station.longitude,
                'lat_deg': station.latitude
            }

            # Case-insensitive mapping
            lower_sample = {str(k).lower(): v for k, v in sample_dict.items()}
            transformed_entry = {}
            for src_key_lower, out_label in ci_mapping.items():
                if src_key_lower in lower_sample:
                    transformed_entry[out_label] = lower_sample[src_key_lower]
            if transformed_entry:
                transformed_data.append(transformed_entry)

        # Sort by timestamp (newest first)
        def parse_timestamp(entry):
            try:
                for key, val in entry.items():
                    if 'time' in key.lower():
                        ts = val
                        if ts:
                            return datetime.fromisoformat(str(ts).replace('Z', '+00:00'))
                return datetime.min
            except:
                return datetime.min

        sorted_data = sorted(
            transformed_data,
            key=lambda x: parse_timestamp(x),
            reverse=True
        )

        interval = int(getattr(station, 'intervals', 0) or 0)
        filtered_data = filter_bad_data(sorted_data[:limit], getattr(station, 'bad_data', None))

        # Optional datetime filter using query params
        if start or end:
            def in_range(entry):
                t = entry.get('time') or entry.get('timestamp') or entry.get('obs_time_utc') or entry.get('stime') or entry.get('date') or entry.get('datetime') or entry.get('Time')
                if not t:
                    return False
                try:
                    dt = datetime.fromisoformat(str(t).replace('Z', '+00:00'))
                except:
                    return False
                if start:
                    try:
                        start_dt = datetime.fromisoformat(start.replace('Z', '+00:00'))
                        if dt < start_dt:
                            return False
                    except:
                        pass
                if end:
                    try:
                        end_dt = datetime.fromisoformat(end.replace('Z', '+00:00'))
                        if dt > end_dt:
                            return False
                    except:
                        pass
                return True
            filtered_data = [d for d in filtered_data if in_range(d)]

        return apply_intervals(filtered_data, interval)
    except Exception as e:
        print(f"Error in actual_neon_method (transform): {str(e)}")
        return []


async def neon_method(station, limit=100, start: str = None, end: str = None) -> List[dict]:
    """
    Main NEON method with automatic token refresh on authentication failure.
    
    Flow:
    1. Try with existing token
    2. If 401 (auth failed), refresh token and retry
    3. Process and return data
    """
    try:
        # Get current NEON token and session cookie from database
        async with AsyncSessionLocal() as db:
            result_tok = await db.execute(select(Token).where(Token.comments == "neon_token"))
            neon_token_obj = result_tok.scalar_one_or_none()
            result_cookie = await db.execute(select(Token).where(Token.comments == "neon_cookie"))
            neon_cookie_obj = result_cookie.scalar_one_or_none()

            if not neon_token_obj or not neon_token_obj.token:
                print("Info: neon_token missing, refreshing...")
                refreshed = await refresh_neon_token()
                if not refreshed:
                    return []
                current_token = refreshed.get("token")
                current_cookie = refreshed.get("session_id")
            else:
                current_token = neon_token_obj.token
                current_cookie = neon_cookie_obj.token if neon_cookie_obj else None

        # Attempt actual call with existing token and cookie
        print("Attempting NEON API call with existing token...")
        return await actual_neon_method(station, current_token, current_cookie, limit, start, end)

    except httpx.HTTPStatusError as e:
        # If auth failed, refresh token and retry once
        if e.response is not None and e.response.status_code == 401:
            print("⚠ Auth failed (401) - Refreshing token...")
            refreshed = await refresh_neon_token()
            if not refreshed:
                print("Error: Failed to refresh token")
                return []
            print("Retrying with new token...")
            try:
                return await actual_neon_method(station, refreshed.get("token"), refreshed.get("session_id"), limit, start, end)
            except httpx.HTTPStatusError as e2:
                print(f"Second attempt failed with status {e2.response.status_code if e2.response else 'unknown'}")
                return []
        else:
            print(f"HTTP error during NEON call: {e.response.status_code if e.response else 'unknown'}")
            return []
    except Exception as e:
        print(f"Error in neon_method: {str(e)}")
        return []

METHOD_MAPPING = {
    "spot_method": spot_method,
    "pacioos_method": pacioos_method,
    "dart_method": dart_method,  # applied mean
    "ioc_method": ioc_method,    # applied mean
    "neon_method": neon_method,
}