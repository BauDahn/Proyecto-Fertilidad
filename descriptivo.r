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

# Summary del dataset corregido
View(fertility_df)
str(fertility_df)

library(repmod)

