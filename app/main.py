from fastapi import FastAPI
from app.core.database import Base, engine
from app.api.routes import products

Base.metadata.create_all(bind=engine)

app = FastAPI(title="Ecommerce Backend API")

app.include_router(products.router)
