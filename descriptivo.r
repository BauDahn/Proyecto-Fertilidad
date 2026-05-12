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
fertility_df$Smoking <- fertility_df$Smoking == "Yes"

# Alcohol
niveles_alcohol <- c("None", "Moderate", "High")
fertility_df$Alcohol_Intake <- factor(fertility_df$Alcohol_Intake, levels=niveles_alcohol, ordered = FALSE)

# Treatment Type
tipos_tratamiento <- c("None", "Medication", "IVF")
fertility_df$Treatment_Type <- factor(fertility_df$Treatment_Type, levels=tipos_tratamiento, ordered = FALSE)

# Sacar Couple_ID del dataset
fertility_df$Couple_ID <- NULL

# Summary del dataset corregido
View(fertility_df)
str(fertility_df)

fertility_df$Pregnancy_Outcome <- fertility_df$Pregnancy_Outcome == "Success"

# Matriz de correlación para ver si hay que sacar variables
library(corrplot)

M <- cor(as.matrix(fertility_df[,sapply(fertility_df, is.numeric)]))
corrplot(M, method='number')
# No vemos ninguna correlación clara en las variables numéricas

fertility_df <- nice_names(fertility_df)

names(fertility_df)

library(repmod)
library(performance)
modelo_prueba <- glm(pregnancy_outcome ~ ., data=fertility_df, family="binomial")
report(modelo_prueba)

library(visreg)
visreg(modelo_prueba)



pred <- fitted(modelo_prueba)
AUC(pred, fertility_df$Pregnancy_Outcome)
