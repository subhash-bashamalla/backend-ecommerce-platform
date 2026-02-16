from sqlalchemy.orm import Session
from app.models.order import Order
from app.models.product import Product


def create_order(db: Session, user_id: int, product_id: int):
    product = db.query(Product).filter(Product.id == product_id).first()
    if not product:
        raise ValueError("Product not found")

    order = Order(user_id=user_id, product_id=product_id)
    db.add(order)
    db.commit()
    db.refresh(order)
    return order


def get_orders_for_user(db: Session, user_id: int):
    return db.query(Order).filter(Order.user_id == user_id).all()
