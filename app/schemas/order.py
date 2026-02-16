from pydantic import BaseModel
from typing import Optional
from app.schemas.product import ProductResponse


class OrderBase(BaseModel):
    product_id: int
    quantity: int


class OrderCreate(OrderBase):
    pass


class OrderResponse(BaseModel):
    id: int
    quantity: int
    product: ProductResponse

    class Config:
        orm_mode = True
