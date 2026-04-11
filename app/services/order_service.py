from sqlalchemy.orm import Session
from fastapi import HTTPException
from app.db.models import Order, Product


class OrderService:

    @staticmethod
    def create_order(
        db: Session,
        user_id: int,
        product_id: int,
        quantity: int,
    ):
        product = db.query(Product).filter(Product.id == product_id).first()
        if not product:
            raise HTTPException(status_code=404, detail="Product not found")

        order = Order(
            user_id=user_id,
            product_id=product_id,
            quantity=quantity,
        )

        db.add(order)
        db.commit()
        db.refresh(order)

        return order

    @staticmethod
    def get_orders_for_user(db: Session, user_id: int):
        return db.query(Order).filter(Order.user_id == user_id).all()
