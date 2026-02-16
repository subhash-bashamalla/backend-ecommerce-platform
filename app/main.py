from fastapi import FastAPI
from app.api.routes import auth, products, orders
from app.db.session import engine
from app.db.models import Base

app = FastAPI(
    title="E-Commerce Backend",
    version="1.0.0",
    description="Stateless container-ready backend with PostgreSQL and Redis."
)

Base.metadata.create_all(bind=engine)

app.include_router(auth.router, prefix="/auth", tags=["Authentication"])
app.include_router(products.router, prefix="/products", tags=["Products"])
app.include_router(orders.router, prefix="/orders", tags=["Orders"])


@app.get("/health")
def health():
    return {"status": "healthy"}
