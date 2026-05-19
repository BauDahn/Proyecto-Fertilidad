import json
import math

with open("src/app/coeficientes.json", "r") as f:
    MODELO = json.load(f)

def predict(datos):
    x_medication = 1 if datos.treatment_type == "Medication" else 0
    x_ivf = 1 if datos.treatment_type == "IVF" else 0
    x_pcos = 1 if datos.pcos else 0
    x_stress_med = 1 if datos.stress_level == "Medium" else 0
    x_stress_high = 1 if datos.stress_level == "High" else 0
    x_smoking = 1 if datos.smoking else 0
    
    x_age = datos.female_age
    x_motility = datos.motility_percentage
    x_sperm = datos.sperm_count_million_per_ml

    z = MODELO["intercepto"]
    z += MODELO["betas"]["treatment_typeMedication"] * x_medication
    z += MODELO["betas"]["treatment_typeIVF"] * x_ivf
    z += MODELO["betas"]["pcosYes"] * x_pcos
    z += MODELO["betas"]["motility_percentage"] * x_motility
    z += MODELO["betas"]["sperm_count_million_per_ml"] * x_sperm
    z += MODELO["betas"]["stress_levelMedium"] * x_stress_med
    z += MODELO["betas"]["stress_levelHigh"] * x_stress_high
    z += MODELO["betas"]["female_age"] * x_age
    z += MODELO["betas"]["smokingYes"] * x_smoking

    # 4. Sumamos las INTERACCIONES (Multiplicaciones)
    # Motilidad x Conteo espermático
    z += MODELO["betas"]["motility_percentage:sperm_count_million_per_ml"] * (x_motility * x_sperm)
    
    # Estrés Medio x Edad
    z += MODELO["betas"]["stress_levelMedium:female_age"] * (x_stress_med * x_age)
    
    # Estrés Alto x Edad
    z += MODELO["betas"]["stress_levelHigh:female_age"] * (x_stress_high * x_age)
    
    # Motilidad x Fumador
    z += MODELO["betas"]["motility_percentage:smokingYes"] * (x_motility * x_smoking)
    
    probabilidad = 1 / (1 + math.exp(-z))
    riesgo = "Alto" if probabilidad > 0.5 else "Bajo"
    
    return {"riesgo": riesgo, "probabilidad": round(probabilidad, 4)}