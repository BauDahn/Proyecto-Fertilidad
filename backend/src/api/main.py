from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import Literal
from src.app.main import predict

app = FastAPI()

origins = [
    "https://dkg5bcnx-5173.uks1.devtunnels.ms/", 
    "http://localhost:5173",
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

class Muestra(BaseModel):
    treatment_type: Literal["Natural", "Medication", "IVF"]
    pcos: bool
    motility_percentage: float
    sperm_count_millon_per_ml: float
    stress_level: Literal["Low", "Medium", "High"]
    female_age: int
    smoking: bool

@app.post('/predictor')
async def api_predictor(datos: Muestra):
    resultado = predict(datos)
    return resultado
