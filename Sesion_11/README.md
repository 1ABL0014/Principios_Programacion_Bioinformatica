# 🧬 Sesión 11: Elementos de la Sintaxis de Shell Scripting III
## Principios de Programación en Bioinformática - Unidad 2

**Docentes:** Frank Guzmán Escudero, Manuel Ramírez Sáenz  
**Universidad:** UPC - Facultad de Ciencias de la Salud - Programa de Biología  
**Horario:** 1:00 pm - 5:00 pm (Descanso: 2:45 pm - 3:00 pm)

---

## 🎯 Logro de la Sesión

Al finalizar esta sesión práctica, el estudiante:
- Ejecutará comandos repetidamente usando bucles `for` y `while`
- Tomará decisiones dentro de un script usando estructuras `if / elif / else`
- Usará operadores de comparación para números, texto y archivos
- Combinará bucles con condicionales para automatizar tareas bioinformáticas

**Palabras clave:** Bucles, for, while, if-then-else, operadores de comparación, control de flujo

---

## 📋 Pre-requisitos

- Haber completado las Sesiones 9 y 10
- Saber crear y ejecutar scripts Bash (`chmod +x`, `./script.sh`)
- Conocer variables, `read` y manipulación básica de cadenas

---

## 🧠 1. Repaso Rápido

Estos son los conceptos de las sesiones anteriores que vamos a usar hoy:

```bash
# Variable y su longitud
secuencia="ATCGATCG"
echo ${#secuencia}          # → 8

# Entrada del usuario
read -p "Organismo: " org

# Sustitución de texto
arn=${secuencia//T/U}       # → AUCGAUCG
```

---

## 🔁 2. Bucle `for`: Repetir con una lista

Un bucle `for` te permite ejecutar los mismos comandos para cada elemento de una lista, sin tener que escribirlos una y otra vez.

### Sintaxis:

```bash
for variable in lista_de_elementos
do
    comandos
done
```

### 🔬 Pruébalo en tu terminal — ejemplo básico:

```bash
for organismo in "E. coli" "S. aureus" "M. tuberculosis"
do
    echo "Procesando: $organismo"
done
```

**Salida esperada:**
```
Procesando: E. coli
Procesando: S. aureus
Procesando: M. tuberculosis
```

Cada vez que el bucle da una vuelta, la variable `organismo` toma el siguiente valor de la lista.

### `for` con una secuencia numérica:

```bash
for i in 1 2 3 4 5
do
    echo "Muestra número: $i"
done
```

**Salida esperada:**
```
Muestra número: 1
Muestra número: 2
Muestra número: 3
Muestra número: 4
Muestra número: 5
```

También puedes usar la forma compacta `{inicio..fin}`:

```bash
for i in {1..5}
do
    echo "Muestra número: $i"
done
```

El resultado es idéntico. La forma `{1..5}` es más corta cuando el rango es largo.

### `for` recorriendo archivos del directorio:

```bash
for archivo in *.sh
do
    echo "Script encontrado: $archivo"
done
```

Esto recorre todos los archivos `.sh` del directorio actual. El `*` es un comodín que significa "cualquier nombre".

### 🧪 Ejercicio 1 — Realízalo en tu terminal:

```bash
#!/bin/bash
# ejercicio1_for.sh
# Procesa una lista de bacterias patógenas

echo "=== INVENTARIO DE MUESTRAS ==="
echo ""

bacterias="Staphylococcus_aureus Escherichia_coli Pseudomonas_aeruginosa Klebsiella_pneumoniae"

contador=1
for bacteria in $bacterias
do
    echo "Muestra $contador: $bacteria"
    contador=$((contador + 1))
done

echo ""
echo "Total de muestras registradas: $((contador - 1))"
```

**Salida esperada:**
```
=== INVENTARIO DE MUESTRAS ===

Muestra 1: Staphylococcus_aureus
Muestra 2: Escherichia_coli
Muestra 3: Pseudomonas_aeruginosa
Muestra 4: Klebsiella_pneumoniae

Total de muestras registradas: 4
```

> 💡 `$((expresión))` es la forma de hacer aritmética en Bash. `$((contador + 1))` suma 1 al valor de `contador`.

---

## 🔄 3. Bucle `while`: Repetir mientras una condición sea verdadera

El bucle `while` sigue ejecutándose mientras una condición se cumpla. Es útil cuando no sabes de antemano cuántas vueltas va a dar el bucle.

### Sintaxis:

```bash
while [ condición ]
do
    comandos
done
```

> ⚠️ Los espacios dentro de `[ ]` son **obligatorios**. `[$var -gt 5]` da error; `[ $var -gt 5 ]` es correcto.

### 🔬 Pruébalo en tu terminal:

```bash
contador=1
while [ $contador -le 5 ]
do
    echo "Iteración: $contador"
    contador=$((contador + 1))
done
echo "Bucle terminado."
```

**Salida esperada:**
```
Iteración: 1
Iteración: 2
Iteración: 3
Iteración: 4
Iteración: 5
Bucle terminado.
```

El bucle sigue mientras `$contador` sea menor o igual a 5 (`-le`). Cuando llega a 6, la condición es falsa y el bucle termina.

### ⚠️ Error clásico: el bucle infinito

Si olvidamos incrementar el contador, el bucle nunca termina:

```bash
# ❌ INCORRECTO — bucle infinito, nunca para
contador=1
while [ $contador -le 5 ]
do
    echo "Iteración: $contador"
    # Falta: contador=$((contador + 1))
done

# ✅ CORRECTO — siempre incrementar dentro del bucle
contador=1
while [ $contador -le 5 ]
do
    echo "Iteración: $contador"
    contador=$((contador + 1))    # ← esto es esencial
done
```

> Si ejecutas un bucle infinito por error, presiónα **Ctrl + C** para detenerlo.

### 🧪 Ejercicio 2 — Contador de nucleótidos:

```bash
#!/bin/bash
# ejercicio2_while.sh
# Cuenta cuántas veces aparece la Adenina en una secuencia

secuencia="ATCGATCGAATTTAAA"
longitud=${#secuencia}
posicion=0
conteo_a=0

echo "Secuencia: $secuencia"
echo "Longitud : $longitud nucleótidos"
echo ""

while [ $posicion -lt $longitud ]
do
    base=${secuencia:$posicion:1}    # Extrae una base a la vez
    if [ "$base" = "A" ]; then
        conteo_a=$((conteo_a + 1))
    fi
    posicion=$((posicion + 1))
done

echo "Adeninas (A) encontradas: $conteo_a"
```

**Salida esperada:**
```
Secuencia: ATCGATCGAATTTAAA
Longitud : 17 nucleótidos

Adeninas (A) encontradas: 6
```

---

## 📊 4. Operadores de Comparación

Para que los bucles y condicionales tomen decisiones, necesitamos operadores que comparen valores.

### Para números (`-eq`, `-ne`, `-lt`, `-gt`, `-le`, `-ge`):

| Operador | Significado | Ejemplo | ¿Verdadero si...? |
|----------|-------------|---------|-------------------|
| `-eq` | igual a | `[ $a -eq 5 ]` | `a` vale 5 |
| `-ne` | no igual a | `[ $a -ne 5 ]` | `a` no vale 5 |
| `-lt` | menor que | `[ $a -lt 10 ]` | `a` es menor que 10 |
| `-gt` | mayor que | `[ $a -gt 10 ]` | `a` es mayor que 10 |
| `-le` | menor o igual | `[ $a -le 10 ]` | `a` es ≤ 10 |
| `-ge` | mayor o igual | `[ $a -ge 10 ]` | `a` es ≥ 10 |

> 💡 Las letras vienen del inglés: **l**ess **t**han, **g**reater **t**han, **e**qual, **n**ot **e**qual.

### Para texto (`=`, `!=`, `-z`, `-n`):

| Operador | Significado | Ejemplo | ¿Verdadero si...? |
|----------|-------------|---------|-------------------|
| `=` | igual (texto) | `[ "$a" = "ATG" ]` | `a` es exactamente "ATG" |
| `!=` | no igual (texto) | `[ "$a" != "ATG" ]` | `a` no es "ATG" |
| `-z` | cadena vacía | `[ -z "$a" ]` | `a` no tiene ningún carácter |
| `-n` | cadena no vacía | `[ -n "$a" ]` | `a` tiene al menos un carácter |

> ⚠️ Para comparar texto, siempre pon la variable entre comillas: `"$variable"`. Sin comillas, si la variable está vacía, el comando falla.

### Para archivos (`-e`, `-f`, `-d`, `-s`):

| Operador | Significado | Ejemplo | ¿Verdadero si...? |
|----------|-------------|---------|-------------------|
| `-e` | existe | `[ -e "datos.fasta" ]` | el archivo existe |
| `-f` | es un archivo | `[ -f "datos.fasta" ]` | existe y es un archivo (no carpeta) |
| `-d` | es un directorio | `[ -d "resultados/" ]` | existe y es una carpeta |
| `-s` | tiene contenido | `[ -s "datos.fasta" ]` | existe y no está vacío |
| `-r` | tiene permiso de lectura | `[ -r "datos.fasta" ]` | se puede leer |
| `-x` | es ejecutable | `[ -x "script.sh" ]` | se puede ejecutar |

### 🔬 Pruébalo en tu terminal:

```bash
# Comparaciones numéricas
longitud=150

[ $longitud -gt 100 ] && echo "Secuencia larga (>100 bp)"
[ $longitud -lt 100 ] && echo "Secuencia corta (<100 bp)"
[ $longitud -eq 150 ] && echo "Longitud exacta: 150 bp"
```

**Salida esperada:**
```
Secuencia larga (>100 bp)
Longitud exacta: 150 bp
```

El operador `&&` significa "si lo anterior fue verdadero, ejecuta esto". Es una forma compacta de escribir un `if` simple.

---

## 🧠 5. Estructuras Condicionales `if / elif / else`

Con `if` el script puede tomar decisiones: ejecutar un bloque de código si una condición se cumple, y otro bloque si no se cumple.

### Estructura básica:

```bash
# Solo if (hacer algo si la condición es verdadera)
if [ condición ]
then
    comandos
fi

# if-else (una cosa u otra)
if [ condición ]
then
    comandos_si_verdadero
else
    comandos_si_falso
fi

# if-elif-else (múltiples opciones)
if [ condición1 ]
then
    comandos_caso1
elif [ condición2 ]
then
    comandos_caso2
else
    comandos_ninguno
fi
```

> 💡 `fi` es simplemente `if` al revés — es la forma de cerrar el bloque condicional.

### 🔬 Pruébalo en tu terminal — clasificador de longitud:

```bash
secuencia="ATCGATCGATCGATCGATCG"
longitud=${#secuencia}

if [ $longitud -lt 50 ]
then
    echo "Secuencia corta: $longitud bp"
elif [ $longitud -lt 200 ]
then
    echo "Secuencia media: $longitud bp"
else
    echo "Secuencia larga: $longitud bp"
fi
```

**Salida esperada:**
```
Secuencia corta: 20 bp
```

### ⚠️ Error clásico con los corchetes:

```bash
# ❌ INCORRECTO — falta espacio después del [ y antes del ]
if [$longitud -lt 50]; then

# ✅ CORRECTO — espacio obligatorio después de [ y antes de ]
if [ $longitud -lt 50 ]; then
```

### 🧪 Ejercicio 3 — Clasificador de calidad de secuencia:

```bash
#!/bin/bash
# ejercicio3_if.sh
# Clasifica una secuencia según su longitud (criterio simplificado de calidad)

read -p "Ingresa una secuencia de ADN: " secuencia
longitud=${#secuencia}

echo ""
echo "Secuencia : $secuencia"
echo "Longitud  : $longitud bp"
echo ""

if [ $longitud -eq 0 ]
then
    echo "ERROR: No ingresaste ninguna secuencia."
elif [ $longitud -lt 20 ]
then
    echo "ADVERTENCIA: Secuencia muy corta. Podría ser un fragmento."
elif [ $longitud -le 500 ]
then
    echo "OK: Longitud adecuada para análisis básico."
else
    echo "OK: Secuencia larga. Apta para ensamblaje."
fi
```

**Ejemplo de ejecución:**
```
Ingresa una secuencia de ADN: ATCGATCGATCG

Secuencia : ATCGATCGATCG
Longitud  : 12 bp

ADVERTENCIA: Secuencia muy corta. Podría ser un fragmento.
```

---

## 🔀 6. Combinando `for` + `if`

La combinación más poderosa en scripting es un bucle que procesa cada elemento y toma una decisión sobre él. Esto es exactamente lo que hacen los pipelines bioinformáticos.

### 🔬 Pruébalo en tu terminal — clasificar archivos:

Primero crea algunos archivos de prueba:

```bash
mkdir prueba_archivos
touch prueba_archivos/genoma.fasta
touch prueba_archivos/resultados.txt
mkdir prueba_archivos/datos_raw
```

Luego ejecuta:

```bash
for elemento in prueba_archivos/*
do
    if [ -d "$elemento" ]
    then
        echo "📁 DIRECTORIO : $elemento"
    elif [ -f "$elemento" ]
    then
        echo "📄 ARCHIVO    : $elemento"
    fi
done
```

**Salida esperada:**
```
📁 DIRECTORIO : prueba_archivos/datos_raw
📄 ARCHIVO    : prueba_archivos/genoma.fasta
📄 ARCHIVO    : prueba_archivos/resultados.txt
```

### 🧪 Ejercicio 4 — Análisis de codones de inicio y parada:

Los ribosomas buscan el codón AUG para iniciar la traducción, y UAA/UAG/UGA para terminarla. Vamos a detectarlos:

```bash
#!/bin/bash
# ejercicio4_codones_clave.sh
# Identifica codones de inicio y parada en una lista

codones="AUG UCG AAA UGA GCU UAG CCC AUG UAA"

echo "Secuencia de codones: $codones"
echo ""
echo "=== ANÁLISIS DE CODONES CLAVE ==="
echo ""

inicio=0
parada=0

for codon in $codones
do
    if [ "$codon" = "AUG" ]
    then
        echo "▶ INICIO encontrado : $codon (Metionina)"
        inicio=$((inicio + 1))
    elif [ "$codon" = "UAA" ] || [ "$codon" = "UAG" ] || [ "$codon" = "UGA" ]
    then
        echo "⏹ PARADA encontrado : $codon"
        parada=$((parada + 1))
    else
        echo "  Codón normal      : $codon"
    fi
done

echo ""
echo "--- RESUMEN ---"
echo "Codones de inicio (AUG) : $inicio"
echo "Codones de parada       : $parada"
```

**Salida esperada:**
```
Secuencia de codones: AUG UCG AAA UGA GCU UAG CCC AUG UAA

=== ANÁLISIS DE CODONES CLAVE ===

▶ INICIO encontrado : AUG (Metionina)
  Codón normal      : UCG
  Codón normal      : AAA
⏹ PARADA encontrado : UGA
  Codón normal      : GCU
⏹ PARADA encontrado : UAG
  Codón normal      : CCC
▶ INICIO encontrado : AUG (Metionina)
⏹ PARADA encontrado : UAA

--- RESUMEN ---
Codones de inicio (AUG) : 2
Codones de parada       : 3
```

> 💡 El operador `||` significa "o". `[ "$codon" = "UAA" ] || [ "$codon" = "UAG" ]` es verdadero si el codón es UAA **o** UAG.

---

## 🧬 7. Integrando Todo: Script de Verificación de Archivos

En bioinformática, antes de correr un análisis siempre verificamos que los archivos de entrada existan y tengan contenido. Este script lo hace automáticamente:

```bash
#!/bin/bash
# verificador_pipeline.sh
# Verifica que los archivos necesarios para un pipeline existan

echo "============================================"
echo "  VERIFICACIÓN DE ARCHIVOS DEL PIPELINE"
echo "============================================"
echo ""

# Lista de archivos que el pipeline necesita
archivos_requeridos="muestra1.fastq muestra2.fastq referencia.fasta adaptadores.txt"

archivos_ok=0
archivos_faltantes=0

for archivo in $archivos_requeridos
do
    if [ -f "$archivo" ] && [ -s "$archivo" ]
    then
        echo "✅ OK       : $archivo"
        archivos_ok=$((archivos_ok + 1))
    elif [ -f "$archivo" ]
    then
        echo "⚠️  VACÍO   : $archivo (existe pero está vacío)"
        archivos_faltantes=$((archivos_faltantes + 1))
    else
        echo "❌ FALTANTE : $archivo"
        archivos_faltantes=$((archivos_faltantes + 1))
    fi
done

echo ""
echo "--- RESULTADO ---"
echo "Archivos listos  : $archivos_ok"
echo "Archivos con problema: $archivos_faltantes"
echo ""

if [ $archivos_faltantes -eq 0 ]
then
    echo "✅ Pipeline listo para ejecutarse."
else
    echo "❌ Corrige los archivos faltantes antes de continuar."
fi
```

**Salida esperada** (cuando los archivos no existen):
```
============================================
  VERIFICACIÓN DE ARCHIVOS DEL PIPELINE
============================================

❌ FALTANTE : muestra1.fastq
❌ FALTANTE : muestra2.fastq
❌ FALTANTE : referencia.fasta
❌ FALTANTE : adaptadores.txt

--- RESULTADO ---
Archivos listos      : 0
Archivos con problema: 4

❌ Corrige los archivos faltantes antes de continuar.
```

---

## 📸 8. Actividad Asincrónica

### 🎯 Misión: Construir herramientas de control de flujo bioinformático

Vas a crear **3 scripts** que usan bucles y condicionales para resolver problemas reales de laboratorio.

---

### 🧬 Script 1: `clasificador_secuencias.sh` *(Obligatorio)*

**Objetivo:** Dada una lista de secuencias de ADN, clasificar cada una como "corta" (<50 bp), "media" (50–500 bp) o "larga" (>500 bp), y contar cuántas hay de cada tipo.

**Secuencias de prueba** (inclúyelas directamente en el script como variable):
```
ATCG
ATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCG
ATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCGATCG
GCTAGCTA
```

**Requisitos:**
- Usar un bucle `for` para recorrer las secuencias
- Usar `if / elif / else` para clasificar según la longitud
- Al final mostrar el conteo de cada categoría

**Salida de ejemplo:**
```
=== CLASIFICADOR DE SECUENCIAS ===

Secuencia 1 (4 bp)   → CORTA
Secuencia 2 (48 bp)  → CORTA
Secuencia 3 (504 bp) → LARGA
Secuencia 4 (8 bp)   → CORTA

--- RESUMEN ---
Secuencias cortas  (<50 bp)  : 3
Secuencias medias  (50-500)  : 0
Secuencias largas  (>500 bp) : 1
```

---

### 🔬 Script 2: `buscador_genes.sh` *(Obligatorio)*

**Objetivo:** Dado un gen ingresado por el usuario, verificar si está en una lista de genes de resistencia antimicrobiana conocidos.

**Lista de genes de resistencia** (inclúyela en el script):
```
blaKPC blaNDM blaOXA mecA vanA tetM ermB
```

**Requisitos:**
- Usar `read -p` para pedir el nombre del gen al usuario
- Usar un bucle `for` para recorrer la lista
- Usar `if` para detectar si el gen ingresado coincide con alguno de la lista
- Mostrar si se encontró o no, y si se encontró, el número de posición en la lista

**Salida de ejemplo (gen encontrado):**
```
Ingresa el nombre del gen: mecA

Buscando mecA en base de datos de resistencia...

✅ Gen ENCONTRADO: mecA
   Posición en la base de datos: 4
   Asociado con resistencia a meticilina (MRSA)
```

**Salida de ejemplo (gen no encontrado):**
```
Ingresa el nombre del gen: gyrA

Buscando gyrA en base de datos de resistencia...

ℹ️  Gen no encontrado en la base de datos actual.
   gyrA podría estar en bases de datos adicionales.
```

---

### 🧪 Script 3: `analizador_fasta.sh` *(Obligatorio)*

**Objetivo:** Crear un archivo FASTA con varias secuencias y luego analizarlo con un bucle `while` que lea línea por línea, contando cuántas secuencias contiene y reportando la longitud de cada una.

**Requisitos:**
- El script debe crear el archivo FASTA al inicio (usando `cat > archivo.fasta << 'EOF'`)
- Usar un bucle `while read` para leer el archivo línea por línea
- Usar `if` para detectar las líneas de cabecera (las que empiezan con `>`)
- Contar el número de secuencias y acumular la longitud de cada una
- Mostrar un reporte final

**El archivo FASTA debe contener al menos estas 3 secuencias:**
```
>seq1|Staphylococcus_aureus
ATCGATCGATCGATCGATCG
>seq2|Escherichia_coli
GCTAGCTAGCTAGCTAGCTA
>seq3|Mycobacterium_tuberculosis
TTTTAAAACCCCGGGGTTTT
```

**Salida esperada:**
```
=== ANÁLISIS DEL ARCHIVO FASTA ===

Secuencia 1: seq1|Staphylococcus_aureus    → 20 bp
Secuencia 2: seq2|Escherichia_coli         → 20 bp
Secuencia 3: seq3|Mycobacterium_tuberculosis → 20 bp

--- REPORTE FINAL ---
Total de secuencias   : 3
Longitud promedio     : 20 bp
```

---

### 🏆 Script Bonus: `pipeline_qc.sh` *(Opcional — para nota extra)*

Crea un script que combine los tres anteriores: verifica que el archivo FASTA exista, lo analiza, y para cada secuencia clasifica su longitud. Al final, guarda el reporte en un archivo `reporte_qc.txt` usando redirección (`>`).

---

### ✅ Checklist de entrega

Antes de subir a GitHub, verifica:

- [ ] Los 3 scripts obligatorios están creados
- [ ] Cada script tiene `#!/bin/bash` en la primera línea
- [ ] Cada script tiene al menos un comentario con tu nombre y fecha
- [ ] Todos tienen permisos de ejecución (`chmod +x nombre_script.sh`)
- [ ] Los 3 scripts se ejecutan sin errores
- [ ] Incluiste capturas de pantalla de la ejecución de cada script
- [ ] Subiste todo a tu repositorio con un commit descriptivo

---

## 🗂️ Resumen de Comandos de la Sesión

| Estructura | Sintaxis | ¿Cuándo usarla? |
|------------|----------|-----------------|
| `for` | `for var in lista; do ...; done` | Cuando conoces los elementos de antemano |
| `while` | `while [ condición ]; do ...; done` | Cuando repites hasta que algo cambie |
| `if` simple | `if [ cond ]; then ...; fi` | Para ejecutar algo solo si se cumple |
| `if-else` | `if [ cond ]; then ...; else ...; fi` | Para elegir entre dos opciones |
| `if-elif-else` | `if ...; elif ...; else ...; fi` | Para elegir entre tres o más opciones |
| `&&` | `cmd1 && cmd2` | Ejecutar cmd2 solo si cmd1 fue exitoso |
| `\|\|` | `cmd1 \|\| cmd2` | Ejecutar cmd2 solo si cmd1 falló |

### Operadores más usados:

| Tipo | Operador | Significado |
|------|----------|-------------|
| Número | `-eq` `-ne` `-lt` `-gt` `-le` `-ge` | igual, distinto, menor, mayor, ≤, ≥ |
| Texto | `=` `!=` `-z` `-n` | igual, distinto, vacío, no vacío |
| Archivo | `-e` `-f` `-d` `-s` | existe, es archivo, es carpeta, no está vacío |

---

## 📚 Referencias Bibliográficas

1. Blum, R., & Bresnahan, C. (2021). *Linux Command Line and Shell Scripting Bible* (4th ed.). Wiley. Capítulo 11–13.

2. Documentación oficial de Bash — Conditional expressions:  
   [https://www.gnu.org/software/bash/manual/bash.html#Bash-Conditional-Expressions](https://www.gnu.org/software/bash/manual/bash.html#Bash-Conditional-Expressions)

3. ShellCheck — Verificador de sintaxis online:  
   [https://www.shellcheck.net/](https://www.shellcheck.net/)

---

> 🎓 *"Un script que solo ejecuta líneas en orden es como un protocolo de laboratorio que no puede adaptarse si falla un paso. Con bucles y condicionales, tus scripts toman decisiones — igual que tú lo harías en el banco de trabajo."*

---

*Documento preparado para la Sesión 09 - Semana 11 del curso Principios de Programación en Bioinformática. UPC exígete, innova.*
