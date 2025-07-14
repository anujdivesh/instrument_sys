import json
from typing import List, Any
from datetime import datetime, timedelta
from fastapi import HTTPException
import httpx
from sqlalchemy import select
from app.db import AsyncSessionLocal
from app.models import Token

async def spot_method(station) -> List[dict]:
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
        return transformed_waves
    except Exception as e:
        return []

async def pacioos_method(station) -> List[dict]:
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
        # # print (source_url)
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
            if "time" in props:
                transformed_wave["obs_time_utc"] = props["time"]
            transformed_waves.append(transformed_wave)
        sorted_waves = sorted(
            transformed_waves,
            key=lambda x: parse_timestamp(x.get("obs_time_utc", "")),
            reverse=True
        )
        return sorted_waves
    except Exception as e:
        return []

async def dart_method(station) -> List[dict]:
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
                    
                    # Create data entry with original column names
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
        
        return sorted_data
    
    except Exception as e:
        return []

async def ioc_method(station) -> List[dict]:
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
                mapping_input = {
                    'slevel': point.get('slevel'),
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
        return sorted_data
    except Exception as e:
        # print(f"=== IOC METHOD ERROR: {str(e)} ===")
        return []

METHOD_MAPPING = {

    "spot_method": spot_method,
    "pacioos_method": pacioos_method,
    "dart_method": dart_method,
    "ioc_method": ioc_method,
}