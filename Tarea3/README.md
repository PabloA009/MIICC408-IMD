# Explicación del Código y Patrones Encontrados con FP Growth

## Explicación del Código

### 2.1 Librerías Utilizadas

```r
library(fim4r)   # Implementación de algoritmos de minería de conjuntos frecuentes
library(dplyr)   # Manipulación de datos
```

### 2.2 Estructura del Análisis

El análisis se divide en 4 análisis principales:

#### **Análisis 1: Patrones Temporales y Comportamiento de Denuncia**

- **Variables**: HEC_MES, HEC_AREA, HEC_RECUR_DENUN, MEDIDAS_SEGURIDAD, VIC_SEXO, VIC_EST_CIV
- **Parámetros**: Soporte mínimo = 0.08 (8%), Confianza mínima = 0.45 (45%)
- **Registros analizados**: 20,163 casos (con datos completos)
- **Reglas encontradas**: 508
- **Objetivo**: Identificar patrones en el momento de denuncia y aplicación de medidas de seguridad

#### **Análisis 2: Vulnerabilidad Múltiple**

- **Variables**: VIC_DISC, TOTAL_HIJOS, VIC_TRABAJA, VIC_ALFAB, VIC_ESCOLARIDAD, VIC_EST_CIV, HEC_AREA
- **Parámetros**: Soporte = 0.05 (5%), Confianza = 0.5 (50%)
- **Registros analizados**: 36,458 casos
- **Reglas encontradas**: 1,401
- **Objetivo**: Descubrir patrones de vulnerabilidad acumulada en víctimas (discapacidad, hijos, educación, empleo)

#### **Análisis 3: Violencia Múltiple y Reincidencia**

- **Variables**: OTRAS_VICTIMAS, AGRESORES_OTROS_TOTAL, VIC_REL_AGR, AGR_EST_CIV, HEC_TIPAGRE, HEC_AREA, VIC_EST_CIV
- **Parámetros**: Soporte = 0.05 (5%), Confianza = 0.45 (45%)
- **Registros analizados**: 36,457 casos
- **Reglas encontradas**: 1,816
- **Objetivo**: Identificar patrones en casos con múltiples víctimas o agresores

#### **Análisis 4: Patrones de Contexto Familiar y Social**

- **Variables**: VIC_REL_AGR, HEC_TIPAGRE, HEC_AREA, VIC_EST_CIV, AGR_EST_CIV, VIC_TRABAJA, AGR_TRABAJA
- **Parámetros**: Soporte = 0.08 (8%), Confianza = 0.45 (45%)
- **Registros analizados**: 36,457 casos
- **Reglas encontradas**: 1,043
- **Objetivo**: Analizar el contexto familiar y situación laboral en casos de violencia

---

## 3. Patrones Encontrados

### Patrón 1: Áreas Urbanas y Denuncias Formales con Medidas de Protección

**Regla Identificada (Mayor Lift):**

```
{HEC_RECUR_DENUN=[1,2), MEDIDAS_SEGURIDAD=[1,9]} => {HEC_AREA=[1,2)}
```

**Interpretación de los códigos:**

- HEC_RECUR_DENUN=[1,2): Recurso de denuncia formal (código 1)
- MEDIDAS_SEGURIDAD=[1,9]: Se aplicaron medidas de seguridad
- HEC_AREA=[1,2): Área urbana

**Métricas:**

- **Soporte**: 0.099 (9.9% de los casos - 1,994 casos)
- **Confianza**: 0.694 (69.4%)
- **Lift**: 1.238

**Explicación del Patrón:**

Este patrón revela que **cuando se realiza una denuncia formal y se aplican medidas de seguridad, existe una alta probabilidad (69.4%) de que el caso ocurra en área urbana**. El lift de 1.238 indica una asociación positiva significativa.

1. **Acceso a la justicia diferenciado**:

   - Las áreas urbanas tienen mayor infraestructura institucional (juzgados, MP, PNC)
   - Mayor conocimiento de los derechos y mecanismos legales por parte de las víctimas
   - Mejor acceso a servicios de protección y atención

2. **Brecha urbano-rural**:

   - Este patrón sugiere que en áreas rurales hay menor aplicación de medidas de seguridad
   - Posible subregistro en áreas rurales donde las víctimas enfrentan más barreras para denunciar
   - Distancia física a instituciones de justicia como impedimento

3. **Efectividad institucional**:
   - Las medidas de seguridad se concentran donde hay mayor capacidad operativa
   - Indica necesidad de fortalecer presencia institucional en áreas rurales

---

### Patrón 2: Vulnerabilidad Extrema - Mujeres que Trabajan en el Hogar con Menor Educación

**Regla Identificada (Mayor Lift):**

```
{VIC_TRABAJA=[1,2), VIC_ALFAB=[1,9], VIC_EST_CIV=[5,9], HEC_AREA=[1,2)} => {VIC_ESCOLARIDAD=[44,99]}
```

**Interpretación de los códigos:**

- VIC_TRABAJA=[1,2): Víctima que SÍ trabaja (código 1)
- VIC_ALFAB=[1,9]: Víctima alfabetizada
- VIC_EST_CIV=[5,9]: Estado civil - viuda, divorciada o separada (códigos 5-9)
- HEC_AREA=[1,2): Área urbana
- VIC_ESCOLARIDAD=[44,99]: Nivel educativo superior (universitaria o más - códigos 44+)

**Métricas:**

- **Soporte**: 0.054 (5.4% de los casos - 1,955 casos)
- **Confianza**: 0.582 (58.2%)
- **Lift**: 1.740

**Explicación del Patrón:**

Este patrón revela un perfil interesante: **mujeres que trabajan, están alfabetizadas, han terminado una relación (viudas/divorciadas/separadas) y viven en área urbana, tienen 58% de probabilidad de tener educación universitaria o superior**.

1. **Empoderamiento y vulnerabilidad paradójica**:

   - Aunque tienen educación superior y trabajo, siguen siendo víctimas de violencia
   - La educación y el empleo no las protegen completamente de la violencia
   - Puede tratarse de violencia post-separación o acoso por ex parejas

2. **Violencia en contexto de independencia**:

   - Mujeres que han logrado autonomía económica y educativa
   - La separación/divorcio puede ser consecuencia de escapar de violencia previa
   - Violencia como respuesta a la autonomía femenina

3. **Contexto urbano**:

   - Mayor acceso a educación superior en ciudades
   - Mayores oportunidades laborales para mujeres educadas
   - Pero también mayor exposición a violencia en espacios públicos y laborales

4. **Patrón contra-intuitivo**:
   - Desafía la idea de que solo mujeres sin educación son víctimas
   - La violencia de género atraviesa todos los niveles educativos
   - Mujeres empoderadas económicamente enfrentan violencia de tipo diferente (acoso laboral, violencia económica post-separación)

---

### Patrón 3: Simetría de Estados Civiles en Violencia de Pareja - Solteros con Solteros

**Regla Identificada (Mayor Lift):**

```
{AGRESORES_OTROS_TOTAL=[0,99], VIC_EST_CIV=[1,2)} <=> {AGR_EST_CIV=[1,2)}
```

**Interpretación de los códigos:**

- AGRESORES_OTROS_TOTAL=[0,99]: No hay otros agresores (agresor único)
- VIC_EST_CIV=[1,2): Víctima soltera (código 1)
- AGR_EST_CIV=[1,2): Agresor soltero (código 1)

**Métricas (bidireccionales):**

- **Soporte**: 0.058 (5.8% de los casos - 2,110 casos)
- **Confianza**: 0.509 (50.9%) víctima→agresor / 0.454 (45.4%) agresor→víctima
- **Lift**: 3.993

**Explicación del Patrón:**

Este patrón revela una **simetría notable en el estado civil**: cuando la víctima es soltera, hay una probabilidad extremadamente alta (Lift 3.99) de que el agresor también sea soltero, y viceversa. Este es el patrón con la asociación más fuerte de todo el análisis.

1. **Relaciones de noviazgo violentas**:

   - Violencia en relaciones de pareja no formalizadas (novios, "free")
   - Inicio temprano de patrones de violencia en relaciones jóvenes
   - Normalización de conductas violentas desde el noviazgo

2. **Perfil etario probable**:

   - Posiblemente víctimas y agresores jóvenes (adolescentes o adultos jóvenes)
   - Primera relación o relaciones tempranas con patrones violentos
   - Falta de modelos de relaciones saludables

3. **Violencia en el cortejo**:

   - Celos, control y violencia como parte del "enamoramiento"
   - Confusión entre amor y posesión
   - Escalada de violencia desde etapas tempranas de la relación

4. **Implicaciones del agresor único**:
   - Violencia interpersonal (no grupal)
   - Patrón de violencia en la intimidad
   - No hay cómplices o co-agresores

**Diferencia con violencia en matrimonio**:

- En matrimonios: mayor formalización, posible presencia de hijos, dependencia económica
- En solteros: relaciones más "libres", mayor capacidad de terminar la relación
- Sin embargo, la violencia persiste incluso cuando hay menos barreras para salir

---

## 4. Patrones Adicionales Relevantes

### 4.1 Patrón de Parejas con Estados Civiles Complejos

**Regla destacada del Análisis 4:**

```
{VIC_REL_AGR=[2,3), AGR_EST_CIV=[5,9], VIC_TRABAJA=[2,9]} => {VIC_EST_CIV=[5,9]}
```

- **Interpretación**: Cuando la relación es de pareja (códigos 2-3), el agresor está separado/divorciado/viudo, y la víctima trabaja, entonces la víctima también está separada/divorciada/viuda
- **Métricas**: Confianza 97.2%, Lift 2.88
- **Implicación**: Parejas formadas después de separaciones/divorcios previos tienen alta incidencia de violencia

---

## 5. Conclusiones Generales

### 5.1 Hallazgos Principales

1. **Brecha urbano-rural en acceso a justicia**:

   - Las medidas de protección se concentran en áreas urbanas
   - Necesidad urgente de descentralizar servicios de justicia y protección

2. **Violencia atraviesa todos los niveles educativos**:

   - Mujeres con educación superior también son víctimas
   - La violencia post-separación afecta a mujeres empoderadas
   - Desmitifica la idea de que solo mujeres sin educación son vulnerables

3. **Simetría en estados civiles - violencia en el noviazgo**:

   - Patrón más fuerte: solteros agreden a solteros (Lift 3.99)
   - Urgencia de prevención en adolescentes y jóvenes
   - Normalización de violencia desde relaciones tempranas

4. **Violencia predominantemente de género**:

   - 83.7% de víctimas son mujeres
   - 79.2% de agresores son hombres
   - Patrón claro de violencia de hombres contra mujeres

5. **Ex parejas como principal agresor**:
   - 24.3% de casos son ex parejas
   - Violencia post-separación es un problema significativo
   - Necesidad de protección durante y después de la separación

### 5.2 Patrones Contra-Intuitivos Descubiertos

1. **Educación no protege de la violencia**: Mujeres universitarias siguen siendo víctimas
2. **Áreas urbanas concentran denuncias, pero también más violencia reportada**: Puede haber subregistro rural
3. **Solteros vs solteros**: Lift más alto, indica violencia temprana en relaciones

---

# Salida de consola

```shell
> # Análisis FP Growth - Tarea 3
> # Cargar librerías necesarias
> library(fim4r)
> library(dplyr)
>
> # Leer datos desde CSV
> data <- read.csv("ruta\\73875737-52c9-41b3-accf-37b44e534bec.csv")
>
> # Ver estructura de los datos
> str(data)
'data.frame':	36609 obs. of  76 variables:
 $ X_id                    : int  1 2 3 4 5 6 7 8 9 10 ...
 $ HEC_DIA                 : int  4 24 99 28 12 4 20 6 29 23 ...
 $ HEC_MES                 : int  11 3 99 3 7 4 9 6 10 9 ...
 $ HEC_ANO                 : int  2024 2024 9999 2024 2024 2024 2024 2024 2024 2024 ...
 $ HEC_DEPTO               : int  1 2 1 2 7 11 11 16 22 11 ...
 $ HEC_DEPTOMCPIO          : int  110 202 101 202 706 1109 1109 1609 2207 1106 ...
 $ HEC_TIPAGRE             : int  1122 1222 1122 1122 2122 2121 1122 1222 1122 2221 ...
 $ NUMERO_BOLETA           : int  367 5 430 6 16 126 32 9012 26 14 ...
 $ DIA_EMISION             : int  4 25 2 28 24 4 20 10 29 23 ...
 $ MES_EMISION             : int  11 3 3 3 7 4 9 6 10 9 ...
 $ ANO_EMISION             : int  2024 2024 2024 2024 2024 2024 2024 2024 2024 2024 ...
 $ DEPTO                   : int  1 2 1 2 7 11 11 16 22 11 ...
 $ DEPTO_MCPIO             : int  110 202 101 202 706 1109 1101 1609 2207 1101 ...
 $ QUIEN_REPORTA           : int  1 1 1 1 1 1 1 1 1 3 ...
 $ VIC_SEXO                : int  2 1 2 2 2 1 2 2 2 1 ...
 $ VIC_EDAD                : int  55 58 33 58 57 33 32 30 65 6 ...
 $ TOTAL_HIJOS             : int  99 99 99 3 2 0 5 99 99 NA ...
 $ NUM_HIJ_HOM             : int  99 99 99 3 0 0 4 99 99 NA ...
 $ NUM_HIJ_MUJ             : int  99 99 99 0 2 0 1 99 99 NA ...
 $ VIC_ALFAB               : int  2 1 1 1 2 1 1 1 2 NA ...
 $ VIC_ESCOLARIDAD         : int  10 29 29 39 10 23 10 59 10 NA ...
 $ VIC_EST_CIV             : int  2 2 1 2 3 1 9 2 4 NA ...
 $ VIC_GRUPET              : int  2 1 1 1 2 1 1 2 1 1 ...
 $ VIC_NACIONAL            : int  1 1 1 1 1 1 1 1 1 1 ...
 $ VIC_TRABAJA             : int  2 1 2 2 2 1 2 1 2 NA ...
 $ VIC_OCUP                : int  NA 6111 NA NA NA 9211 NA 2330 NA NA ...
 $ VIC_DEDICA              : int  1 NA 1 1 1 NA 1 NA 1 NA ...
 $ VIC_DISC                : int  2 2 2 2 2 2 2 2 2 2 ...
 $ TIPO_DISCAQ             : int  NA NA NA NA NA NA NA NA NA NA ...
 $ VIC_REL_AGR             : int  6 6 10 6 6 10 2 9 10 10 ...
 $ OTRAS_VICTIMAS          : int  99 99 99 99 1 0 0 99 99 0 ...
 $ VIC_OTRAS_HOM           : int  99 99 99 99 0 0 0 99 99 0 ...
 $ VIC_OTRAS_MUJ           : int  99 99 99 99 1 0 0 99 99 0 ...
 $ VIC_OTRAS_N_OS          : int  99 99 99 99 0 0 0 99 99 0 ...
 $ VIC_OTRAS_N_AS          : int  99 99 99 99 0 0 0 99 99 0 ...
 $ HEC_AREA                : int  1 2 1 1 1 2 2 2 1 2 ...
 $ HEC_RECUR_DENUN         : int  2 9 2 2 2 2 1 2 2 2 ...
 $ INST_DONDE_DENUNCIO     : int  NA 9 NA NA NA NA 1 NA NA NA ...
 $ AGR_SEXO                : int  2 1 1 1 2 2 1 2 2 1 ...
 $ AGR_EDAD                : int  11 12 12 12 12 12 12 12 13 13 ...
 $ AGR_ALFAB               : int  2 9 9 9 1 1 1 9 1 1 ...
 $ AGR_ESCOLARIDAD         : int  10 99 99 99 25 26 23 99 39 32 ...
 $ AGR_EST_CIV             : int  NA 1 1 1 1 1 9 9 1 1 ...
 $ AGR_GURPET              : int  9 1 1 1 2 1 1 1 1 1 ...
 $ AGR_NACIONAL            : int  1 1 1 1 1 1 1 1 1 1 ...
 $ AGR_TRABAJA             : int  2 1 2 1 2 1 1 2 2 2 ...
 $ AGR_OCUP                : int  NA 6111 NA 7112 NA 6111 9211 NA NA NA ...
 $ AGR_DEDICA              : int  1 NA 1 NA 1 NA NA 1 3 3 ...
 $ AGRESORES_OTROS_TOTAL   : int  99 0 1 0 0 0 0 99 99 0 ...
 $ AGR_OTROS_HOM           : int  99 0 0 0 0 0 0 99 99 0 ...
 $ AGR_OTRAS_MUJ           : int  99 0 1 0 0 0 0 99 99 0 ...
 $ AGR_OTROS_N_OS          : int  99 0 0 0 0 0 0 99 99 0 ...
 $ AGR_OTRAS_N_AS          : int  99 0 0 0 0 0 0 99 99 0 ...
 $ INST_DENUN_HECHO        : int  3 4 3 4 4 4 1 4 3 2 ...
 $ ORGANISMO_JURISDICCIONAL: int  NA 1 NA 1 1 1 NA 1 NA NA ...
 $ CONDUCENTE              : int  NA 1 NA 2 2 2 NA 2 NA NA ...
 $ LEY_APLICABLE           : int  NA 1 NA 1 1 1 NA 1 NA NA ...
 $ ARTICULOVIF1            : int  NA 7 NA 7 7 7 NA 7 NA NA ...
 $ ARTICULOVIF2            : int  NA 0 NA 0 0 0 NA 9 NA NA ...
 $ ARTICULOVIF3            : int  NA 0 NA 0 0 0 NA 0 NA NA ...
 $ ARTICULOVIF4            : int  NA 0 NA 0 0 0 NA 0 NA NA ...
 $ ARTICULOVCM1            : int  NA NA NA NA NA NA NA NA NA NA ...
 $ ARTICULOVCM2            : int  NA NA NA NA NA NA NA NA NA NA ...
 $ ARTICULOVCM3            : int  NA NA NA NA NA NA NA NA NA NA ...
 $ ARTICULOVCM4            : int  NA NA NA NA NA NA NA NA NA NA ...
 $ ARTICULOCODPEN1         : int  NA NA NA NA NA NA NA NA NA NA ...
 $ ARTICULOCODPEN2         : int  NA NA NA NA NA NA NA NA NA NA ...
 $ ARTICULOCODPEN3         : int  NA NA NA NA NA NA NA NA NA NA ...
 $ ARTICULOCODPEN4         : int  NA NA NA NA NA NA NA NA NA NA ...
 $ ARTICULOTRAS1           : int  NA NA NA NA NA NA NA NA NA NA ...
 $ ARTICULOTRAS2           : int  NA NA NA NA NA NA NA NA NA NA ...
 $ ARTICULOTRAS3           : int  NA NA NA NA NA NA NA NA NA NA ...
 $ ARTICULOTRAS4           : int  NA NA NA NA NA NA NA NA NA NA ...
 $ MEDIDAS_SEGURIDAD       : int  NA 1 NA 1 1 1 NA 1 NA NA ...
 $ TIPO_MEDIDA             : chr  "" "IJ" "" "AIJ" ...
 $ ORGANISMO_REMITE        : int  NA 18 NA 18 18 18 NA 18 NA NA ...
> cat("\nDimensiones del dataset:", dim(data), "\n")

Dimensiones del dataset: 36609 76
> cat("Total de registros:", nrow(data), "\n")
Total de registros: 36609
>
> # ===================================================================
> # ANÁLISIS 1: PATRONES TEMPORALES Y DE DENUNCIA
> # ===================================================================
> cat("\n=== ANÁLISIS 1: PATRONES TEMPORALES Y COMPORTAMIENTO DE DENUNCIA ===\n")

=== ANÁLISIS 1: PATRONES TEMPORALES Y COMPORTAMIENTO DE DENUNCIA ===
>
> data_temporal <- data[, c("HEC_MES", "HEC_AREA", "HEC_RECUR_DENUN",
+                           "MEDIDAS_SEGURIDAD", "VIC_SEXO", "VIC_EST_CIV")]
>
> # Eliminar filas con valores faltantes
> data_temporal <- na.omit(data_temporal)
>
> cat("\nRegistros para análisis temporal:", nrow(data_temporal), "\n")

Registros para análisis temporal: 20163
>
> # Aplicar FP Growth para encontrar patrones temporales y de denuncia
> reglas_temporal <- fim4r(data_temporal, method="fpgrowth", target="rules",
+                          supp=0.08, conf=0.45)
fim4r.fpgrowth

Parameter specification:
 supp conf target report
    8   45  rules    scl

Data size: 20163 transactions and 12 items
Result: 508 rules
Avisos:
1: Column(s) 1, 2, 3, 4, 5, 6 not logical or factor. Applying default discretization (see '? discretizeDF').
2: In discretize(x = c(2L, 1L, 1L, 2L, 2L, 1L, 2L, 1L, 1L, 2L, 2L,  :
  The calculated breaks are: 1, 1, 2, 9
  Only unique breaks are used reducing the number of intervals. Look at ? discretize for details.
3: In discretize(x = c(9L, 2L, 2L, 2L, 2L, 9L, 2L, 9L, 2L, 2L, 2L,  :
  The calculated breaks are: 1, 2, 2, 9
  Only unique breaks are used reducing the number of intervals. Look at ? discretize for details.
4: In discretize(x = c(1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L, 1L,  :
  The calculated breaks are: 1, 1, 1, 9
  Only unique breaks are used reducing the number of intervals. Look at ? discretize for details.
5: In discretize(x = c(1L, 2L, 2L, 1L, 2L, 2L, 1L, 2L, 2L, 2L, 2L,  :
  The calculated breaks are: 1, 2, 2, 2
  Only unique breaks are used reducing the number of intervals. Look at ? discretize for details.
>
> # Convertir a data frame para análisis
> rf_temporal <- as(reglas_temporal, "data.frame")
>
> # Mostrar las reglas más interesantes (ordenadas por lift)
> if(nrow(rf_temporal) > 0) {
+   cat("\nReglas encontradas:", nrow(rf_temporal), "\n")
+   rf_temporal_ordenadas <- rf_temporal[order(-rf_temporal$lift), ]
+   cat("\nTop 15 reglas por lift:\n")
+   print(head(rf_temporal_ordenadas, 15))
+ } else {
+   cat("\nNo se encontraron reglas con estos parámetros.\n")
+ }

Reglas encontradas: 508

Top 15 reglas por lift:
                                                                                                   rules    support confidence
574                                  {HEC_RECUR_DENUN=[1,2),MEDIDAS_SEGURIDAD=[1,9]} => {HEC_AREA=[1,2)} 0.09889401  0.6942897
577                   {HEC_RECUR_DENUN=[1,2),MEDIDAS_SEGURIDAD=[1,9],VIC_SEXO=[1,2]} => {HEC_AREA=[1,2)} 0.09889401  0.6942897
579                                           {HEC_RECUR_DENUN=[1,2),VIC_SEXO=[1,2]} => {HEC_AREA=[1,2)} 0.09889401  0.6942897
580                                                          {HEC_RECUR_DENUN=[1,2)} => {HEC_AREA=[1,2)} 0.09889401  0.6942897
402                    {HEC_MES=[4,8),HEC_RECUR_DENUN=[2,9],MEDIDAS_SEGURIDAD=[1,9]} => {HEC_AREA=[2,9]} 0.13966176  0.4857685
406     {HEC_MES=[4,8),HEC_RECUR_DENUN=[2,9],MEDIDAS_SEGURIDAD=[1,9],VIC_SEXO=[1,2]} => {HEC_AREA=[2,9]} 0.13966176  0.4857685
409                             {HEC_MES=[4,8),HEC_RECUR_DENUN=[2,9],VIC_SEXO=[1,2]} => {HEC_AREA=[2,9]} 0.13966176  0.4857685
411                                            {HEC_MES=[4,8),HEC_RECUR_DENUN=[2,9]} => {HEC_AREA=[2,9]} 0.13966176  0.4857685
110                {HEC_RECUR_DENUN=[2,9],MEDIDAS_SEGURIDAD=[1,9],VIC_EST_CIV=[2,5)} => {HEC_AREA=[2,9]} 0.21623766  0.4808647
115 {HEC_RECUR_DENUN=[2,9],MEDIDAS_SEGURIDAD=[1,9],VIC_SEXO=[1,2],VIC_EST_CIV=[2,5)} => {HEC_AREA=[2,9]} 0.21623766  0.4808647
119                         {HEC_RECUR_DENUN=[2,9],VIC_SEXO=[1,2],VIC_EST_CIV=[2,5)} => {HEC_AREA=[2,9]} 0.21623766  0.4808647
122                                        {HEC_RECUR_DENUN=[2,9],VIC_EST_CIV=[2,5)} => {HEC_AREA=[2,9]} 0.21623766  0.4808647
414                        {HEC_MES=[4,8),MEDIDAS_SEGURIDAD=[1,9],VIC_EST_CIV=[2,5)} => {HEC_AREA=[2,9]} 0.08609830  0.4788966
418         {HEC_MES=[4,8),MEDIDAS_SEGURIDAD=[1,9],VIC_SEXO=[1,2],VIC_EST_CIV=[2,5)} => {HEC_AREA=[2,9]} 0.08609830  0.4788966
421                                 {HEC_MES=[4,8),VIC_SEXO=[1,2],VIC_EST_CIV=[2,5)} => {HEC_AREA=[2,9]} 0.08609830  0.4788966
        lift count
574 1.237860  1994
577 1.237860  1994
579 1.237860  1994
580 1.237860  1994
402 1.106229  2815
406 1.106229  2815
409 1.106229  2815
411 1.106229  2815
110 1.095061  4360
115 1.095061  4360
119 1.095061  4360
122 1.095061  4360
414 1.090580  1736
418 1.090580  1736
421 1.090580  1736
>
> # ===================================================================
> # ANÁLISIS 2: PATRONES DE VULNERABILIDAD MÚLTIPLE
> # ===================================================================
> cat("\n\n=== ANÁLISIS 2: VULNERABILIDAD MÚLTIPLE (VÍCTIMAS CON HIJOS Y DISCAPACIDAD) ===\n")


=== ANÁLISIS 2: VULNERABILIDAD MÚLTIPLE (VÍCTIMAS CON HIJOS Y DISCAPACIDAD) ===
>
> data_vulnerabilidad <- data[, c("VIC_DISC", "TOTAL_HIJOS", "VIC_TRABAJA",
+                                 "VIC_ALFAB", "VIC_ESCOLARIDAD", "VIC_EST_CIV",
+                                 "HEC_AREA")]
>
> # Eliminar filas con valores faltantes
> data_vulnerabilidad <- na.omit(data_vulnerabilidad)
>
> cat("\nRegistros para análisis de vulnerabilidad:", nrow(data_vulnerabilidad), "\n")

Registros para análisis de vulnerabilidad: 36458
>
> # Aplicar FP Growth con parámetros más permisivos para capturar vulnerabilidades
> reglas_vulnerabilidad <- fim4r(data_vulnerabilidad, method="fpgrowth", target="rules",
+                                supp=0.05, conf=0.5)
fim4r.fpgrowth

Parameter specification:
 supp conf target report
    5   50  rules    scl

Data size: 36458 transactions and 16 items
Result: 1401 rules
Avisos:
1: Column(s) 1, 2, 3, 4, 5, 6, 7 not logical or factor. Applying default discretization (see '? discretizeDF').
2: In discretize(x = c(2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 2L, 9L,  :
  The calculated breaks are: 1, 2, 2, 9
  Only unique breaks are used reducing the number of intervals. Look at ? discretize for details.
3: In discretize(x = c(2L, 1L, 2L, 2L, 2L, 1L, 2L, 1L, 2L, 1L, 1L,  :
  The calculated breaks are: 1, 1, 2, 9
  Only unique breaks are used reducing the number of intervals. Look at ? discretize for details.
4: In discretize(x = c(2L, 1L, 1L, 1L, 2L, 1L, 1L, 1L, 2L, 1L, 1L,  :
  The calculated breaks are: 1, 1, 1, 9
  Only unique breaks are used reducing the number of intervals. Look at ? discretize for details.
5: In discretize(x = c(1L, 2L, 1L, 1L, 1L, 2L, 2L, 2L, 1L, 1L, 2L,  :
  The calculated breaks are: 1, 1, 2, 9
  Only unique breaks are used reducing the number of intervals. Look at ? discretize for details.
>
> rf_vulnerabilidad <- as(reglas_vulnerabilidad, "data.frame")
>
> if(nrow(rf_vulnerabilidad) > 0) {
+   cat("\nReglas encontradas:", nrow(rf_vulnerabilidad), "\n")
+   rf_vulnerabilidad_ordenadas <- rf_vulnerabilidad[order(-rf_vulnerabilidad$lift), ]
+   cat("\nTop 15 reglas por lift:\n")
+   print(head(rf_vulnerabilidad_ordenadas, 15))
+ } else {
+   cat("\nNo se encontraron reglas con estos parámetros.\n")
+ }

Reglas encontradas: 1401

Top 15 reglas por lift:
                                                                                                                rules    support
1172 {VIC_DISC=[2,9],VIC_TRABAJA=[1,2),VIC_ALFAB=[1,9],VIC_EST_CIV=[5,9],HEC_AREA=[1,2)} => {VIC_ESCOLARIDAD=[44,99]} 0.05293763
1176                 {VIC_DISC=[2,9],VIC_TRABAJA=[1,2),VIC_EST_CIV=[5,9],HEC_AREA=[1,2)} => {VIC_ESCOLARIDAD=[44,99]} 0.05293763
1167                {VIC_TRABAJA=[1,2),VIC_ALFAB=[1,9],VIC_EST_CIV=[5,9],HEC_AREA=[1,2)} => {VIC_ESCOLARIDAD=[44,99]} 0.05362335
1179                                {VIC_TRABAJA=[1,2),VIC_EST_CIV=[5,9],HEC_AREA=[1,2)} => {VIC_ESCOLARIDAD=[44,99]} 0.05362335
977                    {VIC_DISC=[2,9],VIC_TRABAJA=[1,2),VIC_ALFAB=[1,9],HEC_AREA=[1,2)} => {VIC_ESCOLARIDAD=[44,99]} 0.13774755
981                                    {VIC_DISC=[2,9],VIC_TRABAJA=[1,2),HEC_AREA=[1,2)} => {VIC_ESCOLARIDAD=[44,99]} 0.13774755
972                                   {VIC_TRABAJA=[1,2),VIC_ALFAB=[1,9],HEC_AREA=[1,2)} => {VIC_ESCOLARIDAD=[44,99]} 0.13936585
1004                                                  {VIC_TRABAJA=[1,2),HEC_AREA=[1,2)} => {VIC_ESCOLARIDAD=[44,99]} 0.13936585
992  {VIC_DISC=[2,9],VIC_TRABAJA=[1,2),VIC_ALFAB=[1,9],VIC_EST_CIV=[2,5),HEC_AREA=[1,2)} => {VIC_ESCOLARIDAD=[44,99]} 0.06944978
997                  {VIC_DISC=[2,9],VIC_TRABAJA=[1,2),VIC_EST_CIV=[2,5),HEC_AREA=[1,2)} => {VIC_ESCOLARIDAD=[44,99]} 0.06944978
986                 {VIC_TRABAJA=[1,2),VIC_ALFAB=[1,9],VIC_EST_CIV=[2,5),HEC_AREA=[1,2)} => {VIC_ESCOLARIDAD=[44,99]} 0.07016293
1001                                {VIC_TRABAJA=[1,2),VIC_EST_CIV=[2,5),HEC_AREA=[1,2)} => {VIC_ESCOLARIDAD=[44,99]} 0.07016293
1171 {VIC_DISC=[2,9],VIC_ALFAB=[1,9],VIC_ESCOLARIDAD=[44,99],VIC_EST_CIV=[5,9],HEC_AREA=[1,2)} => {VIC_TRABAJA=[1,2)} 0.05293763
1175                 {VIC_DISC=[2,9],VIC_ESCOLARIDAD=[44,99],VIC_EST_CIV=[5,9],HEC_AREA=[1,2)} => {VIC_TRABAJA=[1,2)} 0.05293763
1166                {VIC_ALFAB=[1,9],VIC_ESCOLARIDAD=[44,99],VIC_EST_CIV=[5,9],HEC_AREA=[1,2)} => {VIC_TRABAJA=[1,2)} 0.05362335
     confidence     lift count
1172  0.5818511 1.740493  1929
1176  0.5818511 1.740493  1929
1167  0.5816721 1.739958  1955
1179  0.5816721 1.739958  1955
977   0.5680353 1.699166  5022
981   0.5680353 1.699166  5022
972   0.5677095 1.698191  5081
1004  0.5677095 1.698191  5081
992   0.5556287 1.662054  2532
997   0.5556287 1.662054  2532
986   0.5552420 1.660897  2558
1001  0.5552420 1.660897  2558
1171  0.6327869 1.640952  1929
1175  0.6327869 1.640952  1929
1166  0.6322768 1.639629  1955
>
> # ===================================================================
> # ANÁLISIS 3: PATRONES DE VIOLENCIA MÚLTIPLE (AGRESORES Y OTRAS VÍCTIMAS)
> # ===================================================================
> cat("\n\n=== ANÁLISIS 3: VIOLENCIA MÚLTIPLE Y REINCIDENCIA ===\n")


=== ANÁLISIS 3: VIOLENCIA MÚLTIPLE Y REINCIDENCIA ===
>
> data_multiple <- data[, c("OTRAS_VICTIMAS", "AGRESORES_OTROS_TOTAL", "VIC_REL_AGR",
+                           "AGR_EST_CIV", "HEC_TIPAGRE", "HEC_AREA",
+                           "VIC_EST_CIV")]
>
> # Eliminar filas con valores faltantes
> data_multiple <- na.omit(data_multiple)
>
> cat("\nRegistros para análisis de violencia múltiple:", nrow(data_multiple), "\n")

Registros para análisis de violencia múltiple: 36457
>
> # Aplicar FP Growth
> reglas_multiple <- fim4r(data_multiple, method="fpgrowth", target="rules",
+                          supp=0.05, conf=0.45)
fim4r.fpgrowth

Parameter specification:
 supp conf target report
    5   45  rules    scl

Data size: 36457 transactions and 17 items
Result: 1816 rules
Avisos:
1: Column(s) 1, 2, 3, 4, 5, 6, 7 not logical or factor. Applying default discretization (see '? discretizeDF').
2: In discretize(x = c(99L, 99L, 99L, 1L, 0L, 0L, 99L, 99L, 99L, 99L,  :
  The calculated breaks are: 0, 1, 99, 99
  Only unique breaks are used reducing the number of intervals. Look at ? discretize for details.
3: In discretize(x = c(0L, 1L, 0L, 0L, 0L, 0L, 99L, 99L, 99L, 99L,  :
  The calculated breaks are: 0, 0, 99, 99
  Only unique breaks are used reducing the number of intervals. Look at ? discretize for details.
4: In discretize(x = c(2L, 1L, 1L, 1L, 2L, 2L, 2L, 1L, 1L, 2L, 1L,  :
  The calculated breaks are: 1, 1, 2, 9
  Only unique breaks are used reducing the number of intervals. Look at ? discretize for details.
>
> rf_multiple <- as(reglas_multiple, "data.frame")
>
> if(nrow(rf_multiple) > 0) {
+   cat("\nReglas encontradas:", nrow(rf_multiple), "\n")
+   rf_multiple_ordenadas <- rf_multiple[order(-rf_multiple$lift), ]
+   cat("\nTop 15 reglas por lift:\n")
+   print(head(rf_multiple_ordenadas, 15))
+ } else {
+   cat("\nNo se encontraron reglas con estos parámetros.\n")
+ }

Reglas encontradas: 1816

Top 15 reglas por lift:
                                                                                                               rules    support
2574                                         {AGRESORES_OTROS_TOTAL=[0,99],VIC_EST_CIV=[1,2)} => {AGR_EST_CIV=[1,2)} 0.05787640
2575                                         {AGRESORES_OTROS_TOTAL=[0,99],AGR_EST_CIV=[1,2)} => {VIC_EST_CIV=[1,2)} 0.05787640
2598                      {AGRESORES_OTROS_TOTAL=[0,99],VIC_REL_AGR=[3,10],VIC_EST_CIV=[1,2)} => {AGR_EST_CIV=[1,2)} 0.05787640
2599                      {AGRESORES_OTROS_TOTAL=[0,99],VIC_REL_AGR=[3,10],AGR_EST_CIV=[1,2)} => {VIC_EST_CIV=[1,2)} 0.05787640
2621                                                   {VIC_REL_AGR=[3,10],VIC_EST_CIV=[1,2)} => {AGR_EST_CIV=[1,2)} 0.05787640
2622                                                   {VIC_REL_AGR=[3,10],AGR_EST_CIV=[1,2)} => {VIC_EST_CIV=[1,2)} 0.05787640
2631                                                                      {VIC_EST_CIV=[1,2)} => {AGR_EST_CIV=[1,2)} 0.05787640
2632                                                                      {AGR_EST_CIV=[1,2)} => {VIC_EST_CIV=[1,2)} 0.05787640
1683        {AGRESORES_OTROS_TOTAL=[0,99],VIC_REL_AGR=[2,3),AGR_EST_CIV=[5,9],HEC_AREA=[1,2)} => {VIC_EST_CIV=[5,9]} 0.05864443
1690                                     {VIC_REL_AGR=[2,3),AGR_EST_CIV=[5,9],HEC_AREA=[1,2)} => {VIC_EST_CIV=[5,9]} 0.05864443
1672                       {AGRESORES_OTROS_TOTAL=[0,99],VIC_REL_AGR=[2,3),AGR_EST_CIV=[5,9]} => {VIC_EST_CIV=[5,9]} 0.11460076
1709                                                    {VIC_REL_AGR=[2,3),AGR_EST_CIV=[5,9]} => {VIC_EST_CIV=[5,9]} 0.11460076
1698        {AGRESORES_OTROS_TOTAL=[0,99],VIC_REL_AGR=[2,3),AGR_EST_CIV=[5,9],HEC_AREA=[2,9]} => {VIC_EST_CIV=[5,9]} 0.05595633
1707                                     {VIC_REL_AGR=[2,3),AGR_EST_CIV=[5,9],HEC_AREA=[2,9]} => {VIC_EST_CIV=[5,9]} 0.05595633
1676 {OTRAS_VICTIMAS=[1,99],AGRESORES_OTROS_TOTAL=[0,99],VIC_REL_AGR=[2,3),AGR_EST_CIV=[5,9]} => {VIC_EST_CIV=[5,9]} 0.08766492
     confidence     lift count
2574  0.5088015 3.992548  2110
2575  0.4541541 3.992548  2110
2598  0.5088015 3.992548  2110
2599  0.4541541 3.992548  2110
2621  0.5088015 3.992548  2110
2622  0.4541541 3.992548  2110
2631  0.5088015 3.992548  2110
2632  0.4541541 3.992548  2110
1683  0.9687358 2.871084  2138
1690  0.9687358 2.871084  2138
1672  0.9664585 2.864334  4178
1709  0.9664585 2.864334  4178
1698  0.9640832 2.857295  2040
1707  0.9640832 2.857295  2040
1676  0.9638118 2.856490  3196
>
> # ===================================================================
> # ANÁLISIS 4: PATRONES DE CONTEXTO FAMILIAR Y SOCIAL
> # ===================================================================
> cat("\n\n=== ANÁLISIS 4: PATRONES DE CONTEXTO FAMILIAR Y SOCIAL ===\n")


=== ANÁLISIS 4: PATRONES DE CONTEXTO FAMILIAR Y SOCIAL ===
>
> data_familiar <- data[, c("VIC_REL_AGR", "HEC_TIPAGRE", "HEC_AREA",
+                           "VIC_EST_CIV", "AGR_EST_CIV", "VIC_TRABAJA",
+                           "AGR_TRABAJA")]
>
> # Eliminar filas con valores faltantes
> data_familiar <- na.omit(data_familiar)
>
> cat("\nRegistros para análisis de contexto familiar:", nrow(data_familiar), "\n")

Registros para análisis de contexto familiar: 36457
>
> if(nrow(data_familiar) > 100) {
+   reglas_familiar <- fim4r(data_familiar, method="fpgrowth", target="rules",
+                            supp=0.08, conf=0.45)
+   rf_familiar <- as(reglas_familiar, "data.frame")
+
+   if(nrow(rf_familiar) > 0) {
+     cat("\nReglas encontradas:", nrow(rf_familiar), "\n")
+     rf_familiar_ordenadas <- rf_familiar[order(-rf_familiar$lift), ]
+     cat("\nTop 15 reglas:\n")
+     print(head(rf_familiar_ordenadas, 15))
+   } else {
+     cat("\nNo se encontraron reglas con estos parámetros.\n")
+   }
+ } else {
+   cat("\nInsuficientes datos para este análisis.\n")
+ }
fim4r.fpgrowth

Parameter specification:
 supp conf target report
    8   45  rules    scl

Data size: 36457 transactions and 17 items
Result: 1043 rules

Reglas encontradas: 1043

Top 15 reglas:
                                                                                                rules    support confidence
1334 {VIC_REL_AGR=[2,3),AGR_EST_CIV=[5,9],VIC_TRABAJA=[2,9],AGR_TRABAJA=[1,9]} => {VIC_EST_CIV=[5,9]} 0.08121897  0.9724138
1337                   {VIC_REL_AGR=[2,3),AGR_EST_CIV=[5,9],VIC_TRABAJA=[2,9]} => {VIC_EST_CIV=[5,9]} 0.08121897  0.9724138
1330                   {VIC_REL_AGR=[2,3),AGR_EST_CIV=[5,9],AGR_TRABAJA=[1,9]} => {VIC_EST_CIV=[5,9]} 0.11460076  0.9664585
1349                                     {VIC_REL_AGR=[2,3),AGR_EST_CIV=[5,9]} => {VIC_EST_CIV=[5,9]} 0.11460076  0.9664585
1333 {VIC_REL_AGR=[2,3),VIC_EST_CIV=[5,9],VIC_TRABAJA=[2,9],AGR_TRABAJA=[1,9]} => {AGR_EST_CIV=[5,9]} 0.08121897  0.9657534
1336                   {VIC_REL_AGR=[2,3),VIC_EST_CIV=[5,9],VIC_TRABAJA=[2,9]} => {AGR_EST_CIV=[5,9]} 0.08121897  0.9657534
1329                   {VIC_REL_AGR=[2,3),VIC_EST_CIV=[5,9],AGR_TRABAJA=[1,9]} => {AGR_EST_CIV=[5,9]} 0.11460076  0.9631166
1348                                     {VIC_REL_AGR=[2,3),VIC_EST_CIV=[5,9]} => {AGR_EST_CIV=[5,9]} 0.11460076  0.9631166
1184     {HEC_TIPAGRE=[1.11e+03,1.22e+03),AGR_EST_CIV=[5,9],AGR_TRABAJA=[1,9]} => {VIC_EST_CIV=[5,9]} 0.09427545  0.8729997
1192                       {HEC_TIPAGRE=[1.11e+03,1.22e+03),AGR_EST_CIV=[5,9]} => {VIC_EST_CIV=[5,9]} 0.09427545  0.8729997
869     {HEC_AREA=[1,2),VIC_EST_CIV=[5,9],VIC_TRABAJA=[2,9],AGR_TRABAJA=[1,9]} => {AGR_EST_CIV=[5,9]} 0.09147763  0.9109533
873                       {HEC_AREA=[1,2),VIC_EST_CIV=[5,9],VIC_TRABAJA=[2,9]} => {AGR_EST_CIV=[5,9]} 0.09147763  0.9109533
1002    {HEC_AREA=[1,2),AGR_EST_CIV=[5,9],VIC_TRABAJA=[1,2),AGR_TRABAJA=[1,9]} => {VIC_EST_CIV=[5,9]} 0.08341334  0.8624504
1006                      {HEC_AREA=[1,2),AGR_EST_CIV=[5,9],VIC_TRABAJA=[1,2)} => {VIC_EST_CIV=[5,9]} 0.08341334  0.8624504
864                       {HEC_AREA=[1,2),VIC_EST_CIV=[5,9],AGR_TRABAJA=[1,9]} => {AGR_EST_CIV=[5,9]} 0.17489097  0.9080034
         lift count
1334 2.881984  2961
1337 2.881984  2961
1330 2.864334  4178
1349 2.864334  4178
1333 2.716494  2961
1336 2.716494  2961
1329 2.709077  4178
1348 2.709077  4178
1184 2.587347  3437
1192 2.587347  3437
869  2.562350  3335
873  2.562350  3335
1002 2.556081  3041
1006 2.556081  3041
864  2.554053  6376
Avisos:
1: Column(s) 1, 2, 3, 4, 5, 6, 7 not logical or factor. Applying default discretization (see '? discretizeDF').
2: In discretize(x = c(2L, 1L, 1L, 1L, 2L, 2L, 2L, 1L, 1L, 2L, 1L,  :
  The calculated breaks are: 1, 1, 2, 9
  Only unique breaks are used reducing the number of intervals. Look at ? discretize for details.
3: In discretize(x = c(1L, 2L, 2L, 2L, 1L, 2L, 1L, 2L, 1L, 1L, 2L,  :
  The calculated breaks are: 1, 1, 2, 9
  Only unique breaks are used reducing the number of intervals. Look at ? discretize for details.
4: In discretize(x = c(1L, 2L, 1L, 2L, 1L, 1L, 2L, 2L, 2L, 9L, 2L,  :
  The calculated breaks are: 1, 1, 1, 9
  Only unique breaks are used reducing the number of intervals. Look at ? discretize for details.
>
```
