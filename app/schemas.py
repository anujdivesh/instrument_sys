from pydantic import BaseModel,validator
from typing import Optional

# ---------- DOCUMENT TYPE ----------
class TypeCreate(BaseModel):
    value: str


class TypeOut(TypeCreate):
    id: int

    class Config:
        orm_mode = True

class StatusCreate(BaseModel):
    value: str


class StatusOut(StatusCreate):
    id: int

    class Config:
        orm_mode = True

class AccessMethodCreate(BaseModel):
    function: str


class AccessMethodOut(AccessMethodCreate):
    id: int

    class Config:
        orm_mode = True

# ---------- TOKEN ----------
class TokenCreate(BaseModel):
    token: str
    comments: Optional[str] = None


class TokenOut(TokenCreate):
    id: int

    class Config:
        orm_mode = True

class StationCreate(BaseModel):
    description: Optional[str] = None
    station_id: Optional[str] = None
    latitude: Optional[float] = None
    longitude: Optional[float] = None
    owner: Optional[str] = None
    maintainer: Optional[str] = None
    country_id: Optional[int] = None
    is_active: Optional[bool] = True
    variable_id: Optional[str] = None
    variable_label: Optional[str] = None
    project: Optional[str] = None
    type_id: Optional[int] = None
    access_method_id: Optional[int] = None
    status_id: Optional[int] = None
    token_id: Optional[int] = None
    source_url: Optional[str] = None
    intervals: Optional[float] = 0  

class StationOut(StationCreate):
    id: int

    class Config:
        orm_mode = True