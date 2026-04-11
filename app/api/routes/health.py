from fastapi import APIRouter
from sqlalchemy.orm import Session
from app.api.deps import get_db

router = APIRouter()

@router.get("/health")
def health():
    return {"status": "ok"}

@router.get("/readiness")
def readiness(db: Session = Depends(get_db)):
    db.execute("SELECT 1")
    return {"database": "ok"}
