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

# Matriz de correlación para ver si hay que sacar variables
library(corrplot)

M <- cor(as.matrix(fertility_df[,sapply(fertility_df, is.numeric)]))
corrplot(M, method='number')
# No vemos ninguna correlación clara en las variables numéricas

fertility_df <- nice_names(fertility_df)

names(fertility_df)
colnames(fertility_df)[10] <- "Motility_percentage"

colnames(fertility_df)

library(repmod)
library(performance)
modelo_completo <- glm(Pregnancy_Outcome ~ ., data=fertility_df, family="binomial")
report(modelo_completo)
visreg(modelo_completo)

hipotesis1 <- glm(Pregnancy_Outcome ~ Motility_percentage * Sperm_Count_Million_per_ml, data=fertility_df, family="binomial")
hipotesis2 <- glm(Pregnancy_Outcome ~ Stress_Level * Female_Age, data=fertility_df, family="binomial")
hipotesis3 <- glm(Pregnancy_Outcome ~ Smoking * Motility_percentage, data=fertility_df, family = "binomial")
hipotesis4 <- glm(Pregnancy_Outcome ~ Trying_Duration_Months * Treatment_Type, data=fertility_df, family="binomial")
hipotesis5 <- glm(Pregnancy_Outcome ~ Alcohol_Intake * Sperm_Count_Million_per_ml, data=fertility_df, family="binomial")


library(visreg)
visreg(hipotesis1, "Sperm_Count_Million_per_ml", by="Motility_percentage")
visreg(hipotesis2, "Stress_Level", by="Female_Age")
visreg(hipotesis3, "Smoking", by="Motility_percentage")
visreg(hipotesis4, "Trying_Duration_Months", by="Treatment_Type")
visreg(hipotesis5, "Alcohol_Intake", by="Sperm_Count_Million_per_ml")

modelo_prueba <- glm(Pregnancy_Outcome ~ Treatment_Type + PCOS + Motility_percentage * Sperm_Count_Million_per_ml + Stress_Level * Female_Age + Smoking * Motility_percentage, data=fertility_df, family="binomial")

report(modelo_prueba, digits=6)

library(boot)
cv_resultado <- cv.glm(fertility_df, modelo_prueba, K = 10)
library(pROC)
pred <- fitted(modelo_prueba)
auc_val <- auc(fertility_df$Pregnancy_Outcome, pred)
print(auc_val)


modelo_gam <- gam(Pregnancy_Outcome ~ s())

cdplot(fertility_df$Pregnancy_Outcome ~ fertility_df$Motility_percentage)




