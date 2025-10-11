install.packages("arules")
library(arules)
install.packages("readxl")
library(readxl)
install.packages("dplyr")
library(dplyr)

data <- read_excel("ruta\\graduados-superior-2023.xlsx")

# Seleccionar columnas relevantes (excepto Nivel_Educativo)
data_apriori <- data %>% select(-Nivel_Educativo)

# Convertir a factores (Apriori requiere datos categóricos)
data_apriori[] <- lapply(data_apriori, as.factor)

# Convertir a transacciones
trans <- as(data_apriori, "transactions")

# Aplicar algoritmo Apriori
rules <- apriori(trans, parameter = list(supp = 0.05, conf = 0.5, minlen = 2))

# Ordenar reglas por lift y mostrar las 10 más interesantes
inspect(head(sort(rules, by = "lift"), 10))

# Seleccionar 3 patrones interesantes manualmente
top3 <- head(sort(rules, by = "lift"), 3)
inspect(top3)

# Describir los 3 patrones encontrados
cat("\\nDescripciones de los 3 patrones más interesantes encontrados (sin filtrar por nivel académico):\\n")
for (i in 1:length(top3)) {
  rule <- labels(top3[i])
  supp <- quality(top3[i])$support
  conf <- quality(top3[i])$confidence
  lift <- quality(top3[i])$lift
  cat(paste0(i, ". Regla: ", rule, "\\n"))
  cat(paste0("   - Soporte: ", round(supp, 3), ", Confianza: ", round(conf, 3), ", Lift: ", round(lift, 3), "\\n"))
}
