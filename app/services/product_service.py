from sqlalchemy.orm import Session
from app.models.product import Product
from app.core.redis_client import redis_client
import json


def create_product(db: Session, name: str, description: str, price: float):
    product = Product(name=name, description=description, price=price)
    db.add(product)
    db.commit()
    db.refresh(product)
    return product


def get_products(db: Session):
    if redis_client:
        cached = redis_client.get("products")
        if cached:
            return json.loads(cached)

    products = db.query(Product).all()

    serialized = [
        {"id": p.id, "name": p.name, "description": p.description, "price": p.price}
        for p in products
    ]

    if redis_client:
        redis_client.setex("products", 60, json.dumps(serialized))

    return serialized
