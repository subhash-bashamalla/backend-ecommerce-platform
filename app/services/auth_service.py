from sqlalchemy.orm import Session
from fastapi import HTTPException
from app.db.models import User
from app.core.security import (
    hash_password,
    verify_password,
    create_access_token,
)


class AuthService:

    @staticmethod
    def register_user(db: Session, username: str, password: str):
        existing = db.query(User).filter(User.username == username).first()
        if existing:
            raise HTTPException(status_code=400, detail="Username exists")

        user = User(
            username=username,
            hashed_password=hash_password(password)
        )

        db.add(user)
        db.commit()
        db.refresh(user)

        return {"message": "User registered"}

    @staticmethod
    def authenticate_user(db: Session, username: str, password: str):
        user = db.query(User).filter(User.username == username).first()
        if not user:
            return None

        if not verify_password(password, user.hashed_password):
            return None

        return create_access_token({"sub": user.username})
