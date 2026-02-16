from pydantic import BaseModel, EmailStr

class ProductCreate(BaseModel):
    email: EmailStr
    password: str

class ProductResponse(BaseModel):
    id: int
    email: EmailStr

    class Config:
        from_attributes = True
