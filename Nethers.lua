from fastapi import FastAPI
from pydantic import BaseModel
from typing import Optional
import time

app = FastAPI(title="Mon API Brainrot")

# Liste qui garde les pets
logs = []

class Pet(BaseModel):
    id: int
    name: str
    base_name: str
    value: int
    mutation: Optional[str] = None
    tier: str = "Midlights"
    timestamp: int
    job_id: Optional[str] = None

@app.get("/recent")
async def get_recent():
    # Retourne les 60 derniers pets (du plus récent au plus ancien)
    sorted_logs = sorted(logs, key=lambda x: x["timestamp"], reverse=True)[:60]
    return {
        "ok": True,
        "findings": sorted_logs
    }

@app.post("/add")
async def add_pet(pet: Pet):
    # Évite les doublons
    if not any(x["id"] == pet.id for x in logs):
        logs.append(pet.dict())
        print(f"✅ Nouveau pet : {pet.name} | {pet.value:,} coins")
    return {"ok": True}

@app.get("/")
async def home():
    return {"status": "API OK", "total_pets": len(logs)}
