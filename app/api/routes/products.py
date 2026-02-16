from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.db.session import get_db
from app.services.product_service import ProductService
from app.core.security import get_current_user

router = APIRouter()


@router.post("/")
def create_product(
    name: str,
    price: float,
    db: Session = Depends(get_db),
    user=Depends(get_current_user),
):
    return ProductService.create_product(db, name, price)


@router.get("/")
def list_products(db: Session = Depends(get_db)):
    return ProductService.get_products(db)

