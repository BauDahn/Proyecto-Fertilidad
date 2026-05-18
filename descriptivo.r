library(readr)
fertility_df <- read_csv("./Fertility_Health_Dataset_2026.csv")
View(fertility_df)

# Summary del dataset
str(fertility_df)

# Female_Age y Male_Age están puestas como double, las pasare a int
fertility_df$Female_Age <- as.integer(fertility_df$Female_Age)
fertility_df$Male_Age <- as.integer(fertility_df$Male_Age)

# BMI está bien

# Menstrual_Regularity, PCOS, Stress_Level, Smoking y Alcohol_Intake tienen mal los tipos

# Stress Level
niveles_estres <- c("Low", "Medium", "High")
fertility_df$Stress_Level <- factor(fertility_df$Stress_Level, levels=niveles_estres, ordered = FALSE)

# Smoking
fertility_df$Smoking <- factor(fertility_df$Smoking, ordered=FALSE)

# Alcohol
niveles_alcohol <- c("None", "Moderate", "High")
fertility_df$Alcohol_Intake <- factor(fertility_df$Alcohol_Intake, levels=niveles_alcohol, ordered = FALSE)

# Treatment Type
tipos_tratamiento <- c("None", "Medication", "IVF")
fertility_df$Treatment_Type <- factor(fertility_df$Treatment_Type, levels=tipos_tratamiento, ordered = FALSE)

# Sacar Couple_ID del dataset
fertility_df <- fertility_df[, -which(names(fertility_df) == "Couple_ID")]

fertility_df$Pregnancy_Outcome <- factor(fertility_df$Pregnancy_Outcome)

# Distribución de las clases
png("plots/distribucion_clases.png", width = 500, height = 400)
plot(fertility_df$Pregnancy_Outcome)
dev.off()

# Matriz de correlación para ver si hay que sacar variables
library(corrplot)

png("plots/correlacion.png", width = 500, height = 400)
M <- cor(as.matrix(fertility_df[,sapply(fertility_df, is.numeric)]))
corrplot(M, method='number')
# No vemos ninguna correlación clara en las variables numéricas
dev.off()

library(clickR)
fertility_df <- nice_names(fertility_df)

names(fertility_df)
colnames(fertility_df)[10] <- "motility_percentage"

colnames(fertility_df)

library(repmod)
library(performance)

library(visreg)

modelo_completo <- glm(pregnancy_outcome ~ ., data=fertility_df, family="binomial")
report(modelo_completo)
visreg(modelo_completo)

hipotesis1 <- glm(pregnancy_outcome ~ motility_percentage * sperm_count_million_per_ml, data=fertility_df, family="binomial")
hipotesis2 <- glm(pregnancy_outcome ~ stress_level * female_age, data=fertility_df, family="binomial")
hipotesis3 <- glm(pregnancy_outcome ~ smoking * motility_percentage, data=fertility_df, family = "binomial")
hipotesis4 <- glm(pregnancy_outcome ~ trying_duration_months * treatment_type, data=fertility_df, family="binomial")
hipotesis5 <- glm(pregnancy_outcome ~ alcohol_intake * sperm_count_million_per_ml, data=fertility_df, family="binomial")


visreg(hipotesis1, "sperm_count_million_per_ml", by="motility_percentage")
visreg(hipotesis2, "stress_level", by="female_age")
visreg(hipotesis3, "smoking", by="motility_percentage")
visreg(hipotesis4, "trying_duration_months", by="treatment_type")
visreg(hipotesis5, "alcohol_intake", by="sperm_count_million_per_ml")

modelo_prueba <- glm(pregnancy_outcome ~ treatment_type + pcos + motility_percentage * sperm_count_million_per_ml + stress_level * female_age + smoking * motility_percentage, data=fertility_df, family="binomial")

# Comprobación de las asunciones

png("plots/residuos_pearson.png", width = 500, height = 400)
plot(modelo_prueba, which=1) # A pesar de ciertas observaciones,los residuos se encuentran en el rango [-2,2], y la linea de tendencia nos muestra que también se cumple la linealidad
dev.off()

png("plots/outliers_influyentes.png", width = 500, height = 400)
plot(modelo_prueba, which=4, las=1) # La distancia de cook mas grande es de apenas 0.0325 aproximadamente, por lo que asumimos ausencia de outliers
dev.off()

# VIF del modelo final
library(car)
vif(modelo_prueba, type = "predictor")
report(modelo_prueba, digits=6)


# Validación del modelo
# AUC y curva ROC
library(boot)
library(pROC)

fertility_dfmod <- as.data.frame(fertility_df)  #readcsv nos esta devolviendo un tibble, y para que la función cv_model funcione necesita un data.frame tradicional.
auc_val <- AUC(predict(modelo_prueba), fertility_df$pregnancy_outcome)
AUCs_validacion <- cv_model(pregnancy_outcome ~ treatment_type + pcos + motility_percentage * sperm_count_million_per_ml + stress_level * female_age + smoking * motility_percentage, data = fertility_dfmod, fit_function = "glm", family = binomial(), k = 10)
media_AUCs <- mean(AUCs_validacion)
auc_val
media_AUCs

png("plots/curva_ROC.png", width = 500, height = 400)
roc_obj <- roc(fertility_df$pregnancy_outcome, fitted(modelo_prueba))
plot(roc_obj, main = paste0("ROC — AUC CV = ", round(media_AUCs, 3)))
dev.off()


# BSS
brier_score <- function(pred, real) mean((pred - real)^2)

brier_skill_score <- function(pred, real, baseline=NULL) {
  bs_model <- brier_score(pred, real)
  
  if (is.null(baseline)) {
    baseline <- mean(real)
  }
  bs_ref <- mean((baseline - real)^2)
  
  if (bs_ref == 0) return(NA)
  
  bss <- 1 - (bs_model / bs_ref)
  return(bss)
}

obs <- ifelse(fertility_df$pregnancy_outcome == "Success", 1, 0)
predicciones <- fitted(modelo_prueba)

brier_skill_score(pred = predicciones, real = obs)
