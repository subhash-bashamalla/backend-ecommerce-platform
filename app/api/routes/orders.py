from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.db.session import get_db
from app.services.order_service import OrderService
from app.core.security import get_current_user

router = APIRouter()


@router.post("/")
def create_order(
    product_id: int,
    quantity: int,
    db: Session = Depends(get_db),
    user=Depends(get_current_user),
):
    return OrderService.create_order(db, user.id, product_id, quantity)


@router.get("/")
def list_my_orders(
    db: Session = Depends(get_db),
    user=Depends(get_current_user),
):
    return OrderService.get_orders_for_user(db, user.id)

