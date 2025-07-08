import json
from typing import Dict, List, Any
from datetime import datetime
from fastapi import HTTPException
import httpx



async def method_1(station_data: Dict[str, Any], http_client) -> List[Dict[str, Any]]:
    """
    Fetch data from station's source_url, sort by timestamp, and transform column names
    """
    try:
        # Get source_url from station data
        source_url = station_data.get('source_url')
        if not source_url:
            return []
        
        # Get variable mappings
        variable_id = station_data.get('variable_id', '')
        variable_label = station_data.get('variable_label', '')
        
        # Create mapping from variable_id to variable_label
        id_columns = [col.strip() for col in variable_id.split(',') if col.strip()]
        label_columns = [col.strip() for col in variable_label.split(',') if col.strip()]
        
        # Ensure both lists have the same length
        if len(id_columns) != len(label_columns):
            return []
        
        column_mapping = dict(zip(id_columns, label_columns))
        
        # Make API call to source_url using FastAPI's HTTP client
        async with httpx.AsyncClient(verify=False) as client:
            response = await client.get(source_url)
            response.raise_for_status()
            data = response.json()
        
        # Extract waves data
        waves_data = data.get('data', {}).get('waves', [])
        if not waves_data:
            return []
        
        # Sort by timestamp (latest first)
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
        
        # Transform column names
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

def method_2():
    return {"data": "This is data from method_2", "source": "method_2"}

# Dictionary mapping function names to actual functions

METHOD_MAPPING = {
    "method_1": method_1,  # Special async function that needs station data
    "method_2": method_2
}