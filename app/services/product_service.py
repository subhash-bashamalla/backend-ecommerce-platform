import json
from sqlalchemy.orm import Session
from app.db.models import Product
from app.cache.redis_client import redis_client


class ProductService:

    CACHE_KEY = "products:all"

    @staticmethod
    def create_product(db: Session, name: str, price: float):
        product = Product(name=name, price=price)

        db.add(product)
        db.commit()
        db.refresh(product)

        # Invalidate cache
        redis_client.delete(ProductService.CACHE_KEY)

        return product

    @staticmethod
    def get_products(db: Session):
        cached = redis_client.get(ProductService.CACHE_KEY)

        if cached:
            return json.loads(cached)

        products = db.query(Product).all()

        result = [
            {"id": p.id, "name": p.name, "price": p.price}
            for p in products
        ]

        redis_client.set(ProductService.CACHE_KEY, json.dumps(result), ex=60)

        return result
