# Análisis de Fertilidad

Proyecto de regresión logística para predecir el resultado de un embarazo (éxito o fracaso) a partir de factores clínicos, reproductivos y de estilo de vida de parejas en tratamiento de fertilidad.

## Dataset

**Fertility_Health_Dataset_2026.csv** — 1 fila por pareja, con las siguientes variables:

| Variable | Tipo | Descripción |
|------------------------|------------------------|------------------------|
| `female_age` | Entero | Edad de la mujer |
| `male_age` | Entero | Edad del hombre |
| `bmi` | Numérico | Índice de masa corporal (mujer) |
| `pcos` | Factor | Síndrome de ovario poliquístico (Sí/No) |
| `menstrual_regularity` | Factor | Regularidad del ciclo menstrual |
| `stress_level` | Factor ordenado | Nivel de estrés (Low / Medium / High) |
| `smoking` | Factor | Tabaquismo (Sí/No) |
| `alcohol_intake` | Factor | Consumo de alcohol (None / Moderate / High) |
| `treatment_type` | Factor | Tipo de tratamiento (None / Medication / IVF) |
| `sperm_count_million_per_ml` | Numérico | Concentración espermática |
| `motility_percentage` | Numérico | Porcentaje de espermatozoides móviles |
| `trying_duration_months` | Numérico | Meses intentando concebir |
| `pregnancy_outcome` | Factor | Variable respuesta: Success / Failure |

## Metodología

### Preprocesamiento (`descriptivo.r`)

-   Conversión de tipos: `Female_Age` y `Male_Age` a entero, variables categóricas a factor con niveles definidos
-   Eliminación de `Couple_ID` (identificador sin valor predictivo)
-   Estandarización de nombres con `nice_names()` (paquete `clickR`)
-   Análisis de correlación entre variables numéricas (`corrplot`)

### Modelo

Se ajustó un modelo de regresión logística (`glm`, familia binomial) explorando cinco hipótesis de interacción. El modelo final incluye:

``` r
glm(pregnancy_outcome ~ treatment_type + pcos +
      motility_percentage * sperm_count_million_per_ml +
      stress_level * female_age +
      smoking * motility_percentage,
    data = fertility_df, family = "binomial")
```

**Justificación de las interacciones:**

-   **Motilidad × Concentración espermática:** la concentración solo mejora el pronóstico si hay suficiente motilidad; el efecto de ambas variables es no lineal y conjunto.
-   **Nivel de estrés × Edad femenina:** el estrés suprime el eje hormonal reproductivo; este efecto se amplifica con la edad porque la reserva ovárica ya está disminuida.
-   **Tabaquismo × Motilidad espermática:** el tabaco reduce la motilidad por estrés oxidativo; en fumadores con motilidad ya deteriorada, el impacto combinado es mayor que la suma de ambos factores.

### Validación del modelo

-   Verificación de asunciones: gráfico de residuos de Pearson y distancia de Cook
-   VIF por predictor (paquete `car`)
-   AUC sobre muestra completa (`pROC`)
-   Validación cruzada 10-fold con media de AUCs (`repmod::cv_model`)
-   Brier Skill Score (BSS) frente a modelo de referencia (prevalencia)

## Resultados

Los gráficos generados se guardan en la carpeta `plots/`:

| Archivo | Contenido |
|----|----|
| `distribucion_clases.png` | Distribución de éxito/fracaso |
| `correlacion.png` | Matriz de correlación entre variables numéricas |
| `residuos_pearson.png` | Diagnóstico de residuos del modelo final |
| `outliers_influyentes.png` | Distancia de Cook por observación |
| `curva_ROC.png` | Curva ROC con AUC de validación cruzada |

## Estructura del proyecto

```         
Proyecto-Fertilidad/
├── descriptivo.r                  # Script principal: preprocesamiento, modelo y validación
├── Fertility_Health_Dataset_2026.csv
├── plots/                         # Gráficos generados
├── herramientas_ia/
│   ├── notebooklm_mcp.py          # Servidor MCP para integración con NotebookLM
│   └── run_analysis.r             # Script auxiliar de análisis
├── .mcp.json                      # Configuración MCP (Claude Code)
└── .claude/                       # Configuración de Claude Code
```

## Dependencias de R

``` r
install.packages(c("readr", "corrplot", "clickR", "repmod", "performance",
                   "visreg", "car", "boot", "pROC"))
```
