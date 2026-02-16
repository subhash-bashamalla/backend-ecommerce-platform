from pydantic import BaseModel, EmailStr

class OrderCreate(BaseModel):
    email: EmailStr
    password: str

class OrderResponse(BaseModel):
    id: int
    email: EmailStr

    class Config:
        from_attributes = True
