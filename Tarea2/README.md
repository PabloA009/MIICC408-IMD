# Explicación del Código y Patrones Encontrados con Apriori

## Explicación del Código

1. **Carga de Librerías y Datos**

   - Se instalan y cargan las librerías `arules`, `readxl` y `dplyr`.
   - Se lee el archivo Excel con los datos de graduados.

2. **Preparación de los Datos**

   - Se eliminó la columna `Nivel_Educativo` para el análisis.
   - Todas las columnas restantes se convierten a factores, ya que el algoritmo Apriori requiere datos categóricos.
   - Los datos se transforman al formato de transacciones, adecuado para minería de reglas de asociación.

3. **Ejecución del Algoritmo Apriori**

   - Se aplica el algoritmo Apriori con un soporte mínimo de 0.05, confianza mínima de 0.5 y longitud mínima de 2 en las reglas.
   - Se ordenan las reglas encontradas por el valor de `lift` y se muestran las 10 más interesantes.

   ```shell
   > inspect(head(sort(rules, by = "lift"), 10))
      lhs                                                                                      rhs                            support    confidence
   [1]  {Grupos_Quinquenales=70 y más, Sector=Privado, Pueblo_Pertenencia=Ignorado}           => {Edad=99}                      0.06084905 0.9972376
   [2]  {AÑO=2023, Grupos_Quinquenales=70 y más, Sector=Privado, Pueblo_Pertenencia=Ignorado} => {Edad=99}                      0.06084905 0.9972376
   [3]  {Grupos_Quinquenales=70 y más, Sector=Privado}                                        => {Edad=99}                      0.06087312 0.9952756
   [4]  {AÑO=2023, Grupos_Quinquenales=70 y más, Sector=Privado}                              => {Edad=99}                      0.06087312 0.9952756
   [5]  {Grupos_Quinquenales=70 y más, Pueblo_Pertenencia=Ignorado}                           => {Edad=99}                      0.06084905 0.9952737
   [6]  {AÑO=2023, Grupos_Quinquenales=70 y más, Pueblo_Pertenencia=Ignorado}                 => {Edad=99}                      0.06084905 0.9952737
   [7]  {Grupos_Quinquenales=70 y más}                                                        => {Edad=99}                      0.06092128 0.9886674
   [8]  {AÑO=2023, Grupos_Quinquenales=70 y más}                                              => {Edad=99}                      0.06092128 0.9886674
   [9]  {Edad=99}                                                                             => {Grupos_Quinquenales=70 y más} 0.06092128 1.0000000
   [10] {Edad=99, Pueblo_Pertenencia=Ignorado}                                                => {Grupos_Quinquenales=70 y más} 0.06084905 1.0000000
      coverage   lift     count
   [1]  0.06101760 16.36928 2527
   [2]  0.06101760 16.36928 2527
   [3]  0.06116208 16.33708 2528
   [4]  0.06116208 16.33708 2528
   [5]  0.06113800 16.33704 2527
   [6]  0.06113800 16.33704 2527
   [7]  0.06161959 16.22860 2530
   [8]  0.06161959 16.22860 2530
   [9]  0.06092128 16.22860 2530
   [10] 0.06084905 16.22860 2527
   ```

4. **Selección y Descripción de Patrones**

   - Se seleccionan manualmente los 3 patrones más interesantes (con mayor `lift`).
   - Se imprime una descripción de cada patrón, incluyendo soporte, confianza y lift.
   - Se proporciona una explicación general sobre la relevancia de estos patrones.

   ```shell
   > # Seleccionar 3 patrones interesantes manualmente
   > top3 <- head(sort(rules, by = "lift"), 3)
   > inspect(top3)
      lhs                                                                                      rhs       support    confidence coverage   lift
   [1] {Grupos_Quinquenales=70 y más, Sector=Privado, Pueblo_Pertenencia=Ignorado}           => {Edad=99} 0.06084905 0.9972376  0.06101760 16.36928
   [2] {AÑO=2023, Grupos_Quinquenales=70 y más, Sector=Privado, Pueblo_Pertenencia=Ignorado} => {Edad=99} 0.06084905 0.9972376  0.06101760 16.36928
   [3] {Grupos_Quinquenales=70 y más, Sector=Privado}                                        => {Edad=99} 0.06087312 0.9952756  0.06116208 16.33708
      count
   [1] 2527
   [2] 2527
   [3] 2528
   ```

## Patrones Encontrados

1. **Primer patrón**

   - **Regla:** `{Grupos_Quinquenales=70 y más, Sector=Privado, Pueblo_Pertenencia=Ignorado} => {Edad=99}`
   - **Soporte:** 0.061
   - **Confianza:** 0.997
   - **Lift:** 16.369
   - **Interpretación:**
     - Esta regla indica que, cuando una persona pertenece al grupo etario de 70 años o más, trabaja en el sector privado y su pueblo de pertenencia es "Ignorado", existe una probabilidad extremadamente alta (99.7%) de que su edad esté registrada como 99. El valor de lift (16.37) muestra que esta combinación ocurre mucho más frecuentemente de lo esperado si los atributos fueran independientes. Esto puede reflejar un patrón de codificación o agrupación de datos para personas mayores en el sector privado con información étnica faltante.

2. **Segundo patrón**

   - **Regla:** `{AÑO=2023, Grupos_Quinquenales=70 y más, Sector=Privado, Pueblo_Pertenencia=Ignorado} => {Edad=99}`
   - **Soporte:** 0.061
   - **Confianza:** 0.997
   - **Lift:** 16.369
   - **Interpretación:**
     - Al agregar el año 2023 a la combinación anterior, se observa el mismo comportamiento: casi todos los registros con estas características tienen la edad 99. Esto refuerza la idea de que, en el año 2023, los graduados de 70 años o más en el sector privado y con pueblo de pertenencia ignorado, son sistemáticamente codificados con edad 99, probablemente por razones administrativas o de anonimización.

3. **Tercer patrón**

   - **Regla:** `{Grupos_Quinquenales=70 y más, Sector=Privado} => {Edad=99}`
   - **Soporte:** 0.061
   - **Confianza:** 0.995
   - **Lift:** 16.337
   - **Interpretación:**
     - Incluso sin considerar el pueblo de pertenencia, la gran mayoría de los graduados de 70 años o más en el sector privado tienen la edad registrada como 99. Esto sugiere que la edad 99 se utiliza como un valor agrupador para personas mayores en este sector, independientemente de otros atributos, lo que puede ser relevante para el análisis de datos demográficos o para identificar posibles sesgos en la codificación de la edad.

## Conclusión

Los tres patrones identificados muestran una fuerte asociación entre la edad registrada como 99 y el grupo de graduados de 70 años o más en el sector privado, especialmente cuando el pueblo de pertenencia es "Ignorado" y el año es 2023. El valor elevado de lift y confianza en todas las reglas sugiere que la edad 99 se utiliza sistemáticamente como un valor agrupador o de codificación especial para este segmento de la población. Estos hallazgos son relevantes para interpretar correctamente los análisis posteriores y para advertir sobre posibles sesgos o limitaciones en la calidad de los datos relacionados con la edad avanzada en los registros de graduados.
