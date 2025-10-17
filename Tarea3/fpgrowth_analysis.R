# Análisis FP Growth - Tarea 3
# Cargar librerías necesarias
library(fim4r)
library(dplyr)
library(arules)

# Leer datos desde CSV
data <- read.csv("ruta\\73875737-52c9-41b3-accf-37b44e534bec.csv")

# Ver estructura de los datos
str(data)
cat("\nDimensiones del dataset:", dim(data), "\n")
cat("Total de registros:", nrow(data), "\n")

# ===================================================================
# ANÁLISIS 1: PATRONES TEMPORALES Y DE DENUNCIA
# ===================================================================
cat("\n=== ANÁLISIS 1: PATRONES TEMPORALES Y COMPORTAMIENTO DE DENUNCIA ===\n")

data_temporal <- data[, c(
    "HEC_MES", "HEC_AREA", "HEC_RECUR_DENUN",
    "MEDIDAS_SEGURIDAD", "VIC_SEXO", "VIC_EST_CIV"
)]

# Eliminar filas con valores faltantes
data_temporal <- na.omit(data_temporal)

cat("\nRegistros para análisis temporal:", nrow(data_temporal), "\n")

# Aplicar FP Growth para encontrar patrones temporales y de denuncia
reglas_temporal <- fim4r(data_temporal,
    method = "fpgrowth", target = "rules",
    supp = 0.08, conf = 0.45
)

# Convertir a data frame para análisis
rf_temporal <- as(reglas_temporal, "data.frame")

# Mostrar las reglas más interesantes (ordenadas por lift)
if (nrow(rf_temporal) > 0) {
    cat("\nReglas encontradas:", nrow(rf_temporal), "\n")
    rf_temporal_ordenadas <- rf_temporal[order(-rf_temporal$lift), ]
    cat("\nTop 15 reglas por lift:\n")
    print(head(rf_temporal_ordenadas, 15))
} else {
    cat("\nNo se encontraron reglas con estos parámetros.\n")
}

# ===================================================================
# ANÁLISIS 2: PATRONES DE VULNERABILIDAD MÚLTIPLE
# ===================================================================
cat("\n\n=== ANÁLISIS 2: VULNERABILIDAD MÚLTIPLE (VÍCTIMAS CON HIJOS Y DISCAPACIDAD) ===\n")

data_vulnerabilidad <- data[, c(
    "VIC_DISC", "TOTAL_HIJOS", "VIC_TRABAJA",
    "VIC_ALFAB", "VIC_ESCOLARIDAD", "VIC_EST_CIV",
    "HEC_AREA"
)]

# Eliminar filas con valores faltantes
data_vulnerabilidad <- na.omit(data_vulnerabilidad)

cat("\nRegistros para análisis de vulnerabilidad:", nrow(data_vulnerabilidad), "\n")

# Aplicar FP Growth con parámetros más permisivos para capturar vulnerabilidades
reglas_vulnerabilidad <- fim4r(data_vulnerabilidad,
    method = "fpgrowth", target = "rules",
    supp = 0.05, conf = 0.5
)

rf_vulnerabilidad <- as(reglas_vulnerabilidad, "data.frame")

if (nrow(rf_vulnerabilidad) > 0) {
    cat("\nReglas encontradas:", nrow(rf_vulnerabilidad), "\n")
    rf_vulnerabilidad_ordenadas <- rf_vulnerabilidad[order(-rf_vulnerabilidad$lift), ]
    cat("\nTop 15 reglas por lift:\n")
    print(head(rf_vulnerabilidad_ordenadas, 15))
} else {
    cat("\nNo se encontraron reglas con estos parámetros.\n")
}

# ===================================================================
# ANÁLISIS 3: PATRONES DE VIOLENCIA MÚLTIPLE (AGRESORES Y OTRAS VÍCTIMAS)
# ===================================================================
cat("\n\n=== ANÁLISIS 3: VIOLENCIA MÚLTIPLE Y REINCIDENCIA ===\n")

data_multiple <- data[, c(
    "OTRAS_VICTIMAS", "AGRESORES_OTROS_TOTAL", "VIC_REL_AGR",
    "AGR_EST_CIV", "HEC_TIPAGRE", "HEC_AREA",
    "VIC_EST_CIV"
)]

# Eliminar filas con valores faltantes
data_multiple <- na.omit(data_multiple)

cat("\nRegistros para análisis de violencia múltiple:", nrow(data_multiple), "\n")

# Aplicar FP Growth
reglas_multiple <- fim4r(data_multiple,
    method = "fpgrowth", target = "rules",
    supp = 0.05, conf = 0.45
)

rf_multiple <- as(reglas_multiple, "data.frame")

if (nrow(rf_multiple) > 0) {
    cat("\nReglas encontradas:", nrow(rf_multiple), "\n")
    rf_multiple_ordenadas <- rf_multiple[order(-rf_multiple$lift), ]
    cat("\nTop 15 reglas por lift:\n")
    print(head(rf_multiple_ordenadas, 15))
} else {
    cat("\nNo se encontraron reglas con estos parámetros.\n")
}

# ===================================================================
# ANÁLISIS 4: PATRONES DE CONTEXTO FAMILIAR Y SOCIAL
# ===================================================================
cat("\n\n=== ANÁLISIS 4: PATRONES DE CONTEXTO FAMILIAR Y SOCIAL ===\n")

data_familiar <- data[, c(
    "VIC_REL_AGR", "HEC_TIPAGRE", "HEC_AREA",
    "VIC_EST_CIV", "AGR_EST_CIV", "VIC_TRABAJA",
    "AGR_TRABAJA"
)]

# Eliminar filas con valores faltantes
data_familiar <- na.omit(data_familiar)

cat("\nRegistros para análisis de contexto familiar:", nrow(data_familiar), "\n")

if (nrow(data_familiar) > 100) {
    reglas_familiar <- fim4r(data_familiar,
        method = "fpgrowth", target = "rules",
        supp = 0.08, conf = 0.45
    )
    rf_familiar <- as(reglas_familiar, "data.frame")

    if (nrow(rf_familiar) > 0) {
        cat("\nReglas encontradas:", nrow(rf_familiar), "\n")
        rf_familiar_ordenadas <- rf_familiar[order(-rf_familiar$lift), ]
        cat("\nTop 15 reglas:\n")
        print(head(rf_familiar_ordenadas, 15))
    } else {
        cat("\nNo se encontraron reglas con estos parámetros.\n")
    }
} else {
    cat("\nInsuficientes datos para este análisis.\n")
}
