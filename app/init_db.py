# init_db.py
import asyncio
from app.db import engine, Base
from app.models import Type
from app.models import Status
from app.models import AccessMethod

async def init_models():
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)

if __name__ == "__main__":
    asyncio.run(init_models())
