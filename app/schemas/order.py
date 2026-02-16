from pydantic import BaseModel

class OrderCreate(BaseModel):
    product_id: int
    quantity: int

class OrderResponse(BaseModel):
    id: int
    user_id: int
    product_id: int
    quantity: int
    price_at_purchase: float

    class Config:
        from_attributes = True
