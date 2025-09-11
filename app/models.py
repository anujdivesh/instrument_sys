from sqlalchemy import Column, Integer, String, ForeignKey, Float, Boolean
from sqlalchemy.orm import relationship
from app.db import Base

class Type(Base):
    __tablename__ = "type"
    __table_args__ = {'extend_existing': True}  # Add for consistency
    
    id = Column(Integer, primary_key=True, index=True)
    value = Column(String, unique=True, index=True)

class Status(Base):
    __tablename__ = "status"
    __table_args__ = {'extend_existing': True}  # Add for consistency
    
    id = Column(Integer, primary_key=True, index=True)
    value = Column(String, unique=True, index=True)

class AccessMethod(Base):
    __tablename__ = "access_method"
    __table_args__ = {'extend_existing': True}  # Add for consistency
    
    id = Column(Integer, primary_key=True, index=True)
    function = Column(String, unique=True, index=True)

class Token(Base):
    __tablename__ = "token"
    __table_args__ = {'extend_existing': True}  # Add for consistency
    
    id = Column(Integer, primary_key=True, index=True)
    token = Column(String, unique=True, index=True)
    comments = Column(String, nullable=True)

class Station(Base):
    __tablename__ = "station"
    __table_args__ = {'extend_existing': True}  # Add for consistency
    
    id = Column(Integer, primary_key=True, index=True)
    description = Column(String, index=True)
    station_id = Column(String, index=True)
    display_name = Column(String, nullable=True, index=True)
    latitude = Column(Float, index=True)
    longitude = Column(Float, index=True)
    owner = Column(String, index=True)
    maintainer = Column(String, index=True)
    country_id = Column(Integer)
    is_active = Column(Boolean, default=True) 
    variable_id = Column(String, index=True)
    variable_label = Column(String, index=True)
    project = Column(String, index=True)
    type_id = Column(Integer, ForeignKey("type.id"))
    access_method_id = Column(Integer, ForeignKey("access_method.id"))
    status_id = Column(Integer, ForeignKey("status.id"))
    token_id = Column(Integer, ForeignKey("token.id"), nullable=True)
    source_url = Column(String, nullable=True)
    intervals = Column(Float, default=0) 
    data_limit = Column(Integer, default=100)  # Default limit for data retrieval
    bad_data = Column(String, nullable=True)  # Comma-separated string for bad data values
    mean = Column(Float, default=0)  # Mean value column

    # Relationships
    types = relationship("app.models.Type", backref="documents")
    access_method = relationship("app.models.AccessMethod", backref="documents")
    status = relationship("app.models.Status", backref="documents")
    token = relationship("app.models.Token", backref="stations")

