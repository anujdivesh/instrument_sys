import sys
from pathlib import Path

# Add /app to Python path (since Docker copies files to /app)
sys.path.append(str(Path(__file__).parent))
from typing import Union
from fastapi import FastAPI, Request, Response, APIRouter, Depends, HTTPException, Header, status, UploadFile, File, Form, Query
from fastapi.responses import JSONResponse, StreamingResponse,FileResponse
from fastapi.staticfiles import StaticFiles
from fastapi.middleware.cors import CORSMiddleware
import io, os
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.exc import IntegrityError
from app.db import AsyncSessionLocal
from sqlalchemy import select
from sqlalchemy.orm import selectinload
import os
import shutil
from uuid import uuid4
from typing import List, Optional
from sqlalchemy import asc, desc
from app.models import Type, Status, AccessMethod, Station
from app.schemas import TypeCreate, TypeOut, StatusCreate, StatusOut, AccessMethodCreate, AccessMethodOut, StationCreate, StationOut
from app.methods import *
import httpx

API_TOKEN = "99a920305541f1c38db611ebab95ba"


async def verify_token(x_token: str = Header(...)):
    if x_token != API_TOKEN:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Invalid or missing token"
        )


app = FastAPI(
    docs_url="/instrument/docs",
    redoc_url="/instrument/redoc",
    openapi_url="/instrument/openapi.json",
    favicon_url="/instrument/favicon.ico"
)
# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins (for development)
    allow_credentials=True,
    allow_methods=["*"],  # Allows all methods
    allow_headers=["*"],  # Allows all headers
)

# Dependency
async def get_db() -> AsyncSession:
    async with AsyncSessionLocal() as session:
        yield session

# HTTP Client dependency
async def get_http_client() -> httpx.AsyncClient:
    async with httpx.AsyncClient(verify=False) as client:
        yield client

ocean_router = APIRouter(prefix="/instrument")

get_data_router = APIRouter(prefix="/get_data")

@ocean_router.get("/")
def read_root():
    return {"Message": "Welcome to Instrument Management System, powered by OpenAPI"}

# Favicon route (must include the prefix)
@app.get("/favicon.ico", include_in_schema=False)
@ocean_router.get("/favicon.ico", include_in_schema=False)
async def get_favicon():
    # Get the absolute path to the favicon
    favicon_path = Path(__file__).parent / "icon.ico"
    if not favicon_path.exists():
        raise HTTPException(status_code=404, detail="Favicon not found")
    return FileResponse(favicon_path)

##DOCUMENT TYPES
## DOCUMENT TYPES
@ocean_router.get("/types/", response_model=List[TypeOut])
async def get_document_types(db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Type))
    return result.scalars().all()

# CREATE Type
@ocean_router.post("/types/", response_model=TypeOut, dependencies=[Depends(verify_token)])
async def create_type(type_data: TypeCreate, db: AsyncSession = Depends(get_db)):
    type_obj = Type(**type_data.dict())
    db.add(type_obj)
    try:
        await db.commit()
        await db.refresh(type_obj)
    except IntegrityError:
        await db.rollback()
        raise HTTPException(status_code=400, detail="Type with this value already exists.")
    return type_obj

# UPDATE Type
@ocean_router.put("/types/{type_id}", response_model=TypeOut, dependencies=[Depends(verify_token)])
async def update_type(type_id: int, type_data: TypeCreate, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Type).where(Type.id == type_id))
    type_obj = result.scalar_one_or_none()
    if not type_obj:
        raise HTTPException(status_code=404, detail="Type not found")
    for key, value in type_data.dict().items():
        setattr(type_obj, key, value)
    try:
        await db.commit()
        await db.refresh(type_obj)
    except IntegrityError:
        await db.rollback()
        raise HTTPException(status_code=400, detail="Type with this value already exists.")
    return type_obj

# DELETE Type
@ocean_router.delete("/types/{type_id}", status_code=204, dependencies=[Depends(verify_token)])
async def delete_type(type_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Type).where(Type.id == type_id))
    type_obj = result.scalar_one_or_none()
    if not type_obj:
        raise HTTPException(status_code=404, detail="Type not found")
    await db.delete(type_obj)
    await db.commit()
    return Response(status_code=204)

# LIST ALL Status
@ocean_router.get("/status/", response_model=List[StatusOut])
async def get_statuses(db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Status))
    return result.scalars().all()

# CREATE Status
@ocean_router.post("/status/", response_model=StatusOut, dependencies=[Depends(verify_token)])
async def create_status(status_data: StatusCreate, db: AsyncSession = Depends(get_db)):
    status_obj = Status(**status_data.dict())
    db.add(status_obj)
    try:
        await db.commit()
        await db.refresh(status_obj)
    except IntegrityError:
        await db.rollback()
        raise HTTPException(status_code=400, detail="Status with this value already exists.")
    return status_obj

# UPDATE Status
@ocean_router.put("/status/{status_id}", response_model=StatusOut, dependencies=[Depends(verify_token)])
async def update_status(status_id: int, status_data: StatusCreate, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Status).where(Status.id == status_id))
    status_obj = result.scalar_one_or_none()
    if not status_obj:
        raise HTTPException(status_code=404, detail="Status not found")
    for key, value in status_data.dict().items():
        setattr(status_obj, key, value)
    try:
        await db.commit()
        await db.refresh(status_obj)
    except IntegrityError:
        await db.rollback()
        raise HTTPException(status_code=400, detail="Status with this value already exists.")
    return status_obj

# DELETE Status
@ocean_router.delete("/status/{status_id}", status_code=204, dependencies=[Depends(verify_token)])
async def delete_status(status_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Status).where(Status.id == status_id))
    status_obj = result.scalar_one_or_none()
    if not status_obj:
        raise HTTPException(status_code=404, detail="Status not found")
    await db.delete(status_obj)
    await db.commit()
    return Response(status_code=204)


# LIST ALL AccessMethods
@ocean_router.get("/access_methods/", response_model=List[AccessMethodOut])
async def get_access_methods(db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(AccessMethod))
    return result.scalars().all()

# CREATE AccessMethod
@ocean_router.post(
    "/access_methods/",
    response_model=AccessMethodOut,
    dependencies=[Depends(verify_token)]
)
async def create_access_method(
    access_method_data: AccessMethodCreate, db: AsyncSession = Depends(get_db)
):
    access_method = AccessMethod(**access_method_data.dict())
    db.add(access_method)
    try:
        await db.commit()
        await db.refresh(access_method)
    except IntegrityError:
        await db.rollback()
        raise HTTPException(status_code=400, detail="AccessMethod with this function already exists.")
    return access_method

# UPDATE AccessMethod
@ocean_router.put(
    "/access_methods/{access_method_id}",
    response_model=AccessMethodOut,
    dependencies=[Depends(verify_token)]
)
async def update_access_method(
    access_method_id: int, access_method_data: AccessMethodCreate, db: AsyncSession = Depends(get_db)
):
    result = await db.execute(select(AccessMethod).where(AccessMethod.id == access_method_id))
    access_method = result.scalar_one_or_none()
    if not access_method:
        raise HTTPException(status_code=404, detail="AccessMethod not found")
    for key, value in access_method_data.dict().items():
        setattr(access_method, key, value)
    try:
        await db.commit()
        await db.refresh(access_method)
    except IntegrityError:
        await db.rollback()
        raise HTTPException(status_code=400, detail="AccessMethod with this function already exists.")
    return access_method

# DELETE AccessMethod
@ocean_router.delete(
    "/access_methods/{access_method_id}",
    status_code=204,
    dependencies=[Depends(verify_token)]
)
async def delete_access_method(
    access_method_id: int, db: AsyncSession = Depends(get_db)
):
    result = await db.execute(select(AccessMethod).where(AccessMethod.id == access_method_id))
    access_method = result.scalar_one_or_none()
    if not access_method:
        raise HTTPException(status_code=404, detail="AccessMethod not found")
    await db.delete(access_method)
    await db.commit()
    return Response(status_code=204)


# LIST ALL Stations
@ocean_router.get("/stations/", response_model=List[StationOut])
async def get_stations(db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Station))
    return result.scalars().all()

# GET Station by ID
@ocean_router.get("/stations/{station_id}", response_model=StationOut)
async def get_station_by_id(station_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Station).where(Station.id == station_id))
    station_obj = result.scalar_one_or_none()
    if not station_obj:
        raise HTTPException(status_code=404, detail="Station not found")
    return station_obj

# CREATE Station
@ocean_router.post("/stations/", response_model=StationOut, dependencies=[Depends(verify_token)])
async def create_station(station_data: StationCreate, db: AsyncSession = Depends(get_db)):
    station_obj = Station(**station_data.dict())
    db.add(station_obj)
    try:
        await db.commit()
        await db.refresh(station_obj)
    except IntegrityError:
        await db.rollback()
        raise HTTPException(status_code=400, detail="Station could not be created.")
    return station_obj

# UPDATE Station
@ocean_router.put("/stations/{station_id}", response_model=StationOut, dependencies=[Depends(verify_token)])
async def update_station(station_id: int, station_data: StationCreate, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Station).where(Station.id == station_id))
    station_obj = result.scalar_one_or_none()
    if not station_obj:
        raise HTTPException(status_code=404, detail="Station not found")
    for key, value in station_data.dict(exclude_unset=True).items():
        setattr(station_obj, key, value)
    try:
        await db.commit()
        await db.refresh(station_obj)
    except IntegrityError:
        await db.rollback()
        raise HTTPException(status_code=400, detail="Station could not be updated.")
    return station_obj

# DELETE Station
@ocean_router.delete("/stations/{station_id}", status_code=204, dependencies=[Depends(verify_token)])
async def delete_station(station_id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Station).where(Station.id == station_id))
    station_obj = result.scalar_one_or_none()
    if not station_obj:
        raise HTTPException(status_code=404, detail="Station not found")
    await db.delete(station_obj)
    await db.commit()
    return Response(status_code=204)


'''This section is for the get_data endpoints.  '''
# GET DATA for specific station
@get_data_router.get("/station/{station_id}")
async def get_station_data(
    station_id: int, 
    db: AsyncSession = Depends(get_db),
    http_client: httpx.AsyncClient = Depends(get_http_client)
):
    # First, get the station and its access method
    result = await db.execute(
        select(Station).where(Station.id == station_id)
    )
    station = result.scalar_one_or_none()
    
    if not station:
        raise HTTPException(status_code=404, detail="Station not found")
    
    if not station.access_method_id:
        raise HTTPException(status_code=400, detail="Station has no access method configured")
    
    # Get the access method function name
    access_result = await db.execute(
        select(AccessMethod).where(AccessMethod.id == station.access_method_id)
    )
    access_method = access_result.scalar_one_or_none()
    
    if not access_method:
        raise HTTPException(status_code=404, detail="Access method not found")
    
    function_name = access_method.function
    
    # Check if the function exists in our method mapping
    if function_name not in METHOD_MAPPING:
        raise HTTPException(
            status_code=400, 
            detail=f"Function '{function_name}' not implemented in methods.py"
        )
    
        # Execute the function dynamically
    try:
        function = METHOD_MAPPING[function_name]
        
        # Special handling for method_1 which needs station data
        if function_name == "method_1":
            # Convert station object to dict for the function
            station_dict = {
                "source_url": station.source_url,
                "variable_id": station.variable_id,
                "variable_label": station.variable_label
            }
            result_data = await method_1(station_dict, http_client)
        else:
            result_data = function()
        
        return {
            "station_id": station_id,
            "station_description": station.description,
            "data": result_data
        }
    except Exception as e:
        raise HTTPException(
            status_code=500, 
            detail=f"Error executing function '{function_name}': {str(e)}"
        )



app.include_router(ocean_router)
app.include_router(get_data_router)