# 🧬 Sesión 13: Scripts para Bioinformática II
## Arrays, Bucles FOR y Automatización de Análisis

**Docentes:** Frank Guzmán Escudero, Manuel Ramírez Sáenz  
**Universidad:** UPC - Facultad de Ciencias de la Salud - Programa de Biología  
**Horario:** 1:00 pm - 5:00 pm (Descanso: 2:45 pm - 3:00 pm)

---

## 🗃️ 1. Arrays (Listas) en Bash

### ¿Qué es un array?

Un **array** es una variable que almacena una **colección ordenada** de valores bajo un solo nombre. Cada valor ocupa una posición identificada por un número llamado **índice**, que siempre empieza en cero.

```
Nombre del array: GENES
                  ┌────────┬────────┬────────┬────────┬────────┐
  Valores:        │ BRCA1  │ BRCA2  │  TP53  │  PTEN  │ CHEK2  │
                  └────────┴────────┴────────┴────────┴────────┘
  Índices:            0        1        2        3        4
```

### Declaración de arrays — tres métodos

#### Método 1: Declaración directa (todos los elementos de una vez)

```bash
# Genes relacionados con cáncer de mama
GENES=("BRCA1" "BRCA2" "TP53" "PTEN" "CHEK2")

# Muestras de un experimento
MUESTRAS=("muestra_01" "muestra_02" "muestra_03")

# Archivos FASTA del proyecto
FASTAS=("ecoli.fasta" "salmonella.fasta" "klebsiella.fasta")
```

#### Método 2: Asignación por índice (elemento por elemento)

```bash
ORGANISMOS[0]="Escherichia coli"
ORGANISMOS[1]="Salmonella enterica"
ORGANISMOS[2]="Mycobacterium tuberculosis"
```

#### Método 3: Rangos automáticos con expansión de llaves `{}`

```bash
# Letras del abecedario
LETRAS=({A..Z})                        # A B C ... Z

# Cromosomas humanos (¡sin escribirlos uno a uno!)
CROMOSOMAS=(chr{1..22} chrX chrY)      # chr1 chr2 ... chr22 chrX chrY

# Identificadores de muestras con formato fijo
IDS=(muestra_{001..100})               # muestra_001 muestra_002 ... muestra_100
```

### 🔬 Pruébalo en tu terminal — tu primer array bioinformático:

```bash
# Crear array de bases nitrogenadas
BASES=("Adenina" "Timina" "Citosina" "Guanina")

# Ver todo el array
echo "Bases: ${BASES[@]}"

# Ver un elemento por índice
echo "Primera base: ${BASES[0]}"
echo "Última base : ${BASES[3]}"

# Crear array de cromosomas humanos
CROMOSOMAS=(chr{1..22} chrX chrY)
echo "Total de cromosomas: ${#CROMOSOMAS[@]}"
echo "Primero: ${CROMOSOMAS[0]}   Último: ${CROMOSOMAS[-1]}"
```

**Salida esperada:**
```
Bases: Adenina Timina Citosina Guanina
Primera base: Adenina
Última base : Guanina
Total de cromosomas: 24
Primero: chr1   Último: chrY
```

---

## 🛠️ 1. Operaciones con Arrays

### Leer el contenido del array

```bash
SECUENCIAS=("ATCG" "GCAAG" "TTTTAAAA" "CCGGCCGG")

echo ${SECUENCIAS[@]}     # Todos los elementos (separados por espacio)
echo ${SECUENCIAS[*]}     # Igual — diferencia técnica solo con comillas dobles
echo ${SECUENCIAS[0]}     # Solo el primero: ATCG
echo ${SECUENCIAS[-1]}    # Solo el último:  CCGGCCGG
echo ${SECUENCIAS[-2]}    # El penúltimo:    TTTTAAAA
```

### Información del array

```bash
GENES=("SOX13" "PAX5" "TC1" "ADF" "BRCA1")

echo "Total de genes : ${#GENES[@]}"     # → 5 (longitud del array)
echo "Índices        : ${!GENES[@]}"     # → 0 1 2 3 4
echo "Longitud gen 0 : ${#GENES[0]}"     # → 5 (longitud de "SOX13")
```

> ⚠️ **Distinción importante:** `${#ARRAY[@]}` es el número de elementos. `${#ARRAY[0]}` es la longitud del primer elemento como cadena de texto.

### Añadir elementos

```bash
GENES=("BRCA1" "TP53")

# Añadir uno o más al final
GENES+=("PTEN")
GENES+=("CHEK2" "PALB2")

echo ${GENES[@]}    # → BRCA1 TP53 PTEN CHEK2 PALB2

# Modificar un elemento específico
GENES[1]="TP53_mutado"
echo ${GENES[1]}    # → TP53_mutado
```

### Eliminar elementos

```bash
MUESTRAS=("S01" "S02" "S03" "S04" "S05")

unset MUESTRAS[2]        # Elimina S03 (índice 2)
echo ${MUESTRAS[@]}      # → S01 S02 S04 S05 (el índice 2 queda vacío)
echo ${#MUESTRAS[@]}     # → 4 (ya no cuenta el elemento eliminado)

unset MUESTRAS           # Elimina todo el array
```

### Arrays desde archivos del sistema

```bash
# Array con todos los archivos del directorio actual
ARCHIVOS=($(ls))

# Solo archivos FASTA
FASTAS=($(ls *.fasta 2>/dev/null))

# Solo scripts
SCRIPTS=($(ls *.sh 2>/dev/null))

echo "Archivos encontrados: ${#ARCHIVOS[@]}"
echo "FASTA encontrados   : ${#FASTAS[@]}"
```

### 🧪 Ejercicio 1 — Registro de muestras con array:

Crea `ejercicio1_arrays.sh` y ejecútalo:

```bash
#!/bin/bash
# ejercicio1_arrays.sh
# Gestiona un registro de muestras bacterianas usando arrays

# Definir arrays con información de muestras
ORGANISMOS=("Staphylococcus aureus" "Escherichia coli" "Klebsiella pneumoniae" "Pseudomonas aeruginosa")
CEPAS=("MRSA-01" "K12" "KP-NDM" "PA-XDR")
RESISTENCIAS=("Meticilina" "Ninguna" "Carbapenems" "Multifármaco")

echo "╔══════════════════════════════════════════════════════╗"
echo "║         REGISTRO DE MUESTRAS BACTERIANAS            ║"
echo "╚══════════════════════════════════════════════════════╝"
echo ""
echo "Total de muestras: ${#ORGANISMOS[@]}"
echo ""

# Mostrar registro
for i in ${!ORGANISMOS[@]}
do
    echo "─── MUESTRA $((i+1)) ─────────────────────────────"
    echo "  Organismo   : ${ORGANISMOS[$i]}"
    echo "  Cepa        : ${CEPAS[$i]}"
    echo "  Resistencia : ${RESISTENCIAS[$i]}"
done

echo ""
# Añadir nueva muestra
ORGANISMOS+=("Acinetobacter baumannii")
CEPAS+=("AB-CR")
RESISTENCIAS+=("Carbapenems")

echo "✅ Nueva muestra añadida. Total actualizado: ${#ORGANISMOS[@]}"
echo "   Última muestra: ${ORGANISMOS[-1]} — Cepa: ${CEPAS[-1]}"
```

**Salida esperada:**
```
╔══════════════════════════════════════════════════════╗
║         REGISTRO DE MUESTRAS BACTERIANAS            ║
╚══════════════════════════════════════════════════════╝

Total de muestras: 4

─── MUESTRA 1 ─────────────────────────────
  Organismo   : Staphylococcus aureus
  Cepa        : MRSA-01
  Resistencia : Meticilina
─── MUESTRA 2 ─────────────────────────────
  Organismo   : Escherichia coli
  Cepa        : K12
  Resistencia : Ninguna
─── MUESTRA 3 ─────────────────────────────
  Organismo   : Klebsiella pneumoniae
  Cepa        : KP-NDM
  Resistencia : Carbapenems
─── MUESTRA 4 ─────────────────────────────
  Organismo   : Pseudomonas aeruginosa
  Cepa        : PA-XDR
  Resistencia : Multifármaco

✅ Nueva muestra añadida. Total actualizado: 5
   Última muestra: Acinetobacter baumannii — Cepa: AB-CR
```

---

## 🔄 3. Bucle FOR con Lista de Elementos

### Sintaxis y estructura

```bash
for VARIABLE in elemento1 elemento2 elemento3
do
    # comandos que usan $VARIABLE
done
```

Cada vez que el bucle da una vuelta, `VARIABLE` toma el siguiente valor de la lista y se ejecutan los comandos del bloque `do...done`.

### Variantes de la lista

```bash
# Lista literal
for BASE in A T C G
do
    echo "Base: $BASE"
done

# Rango numérico
for I in {1..10}
do
    echo "Iteración $I"
done

# Rango con paso (de 2 en 2)
for I in {0..20..2}
do
    echo "Par: $I"
done

# Desde un array
GENES=("BRCA1" "TP53" "PTEN")
for GEN in ${GENES[@]}
do
    echo "Analizando: $GEN"
done

# Archivos del sistema
for ARCHIVO in *.fasta
do
    echo "Archivo: $ARCHIVO"
done
```

### 🔬 Pruébalo en tu terminal — recorrer cromosomas:

```bash
CROMOSOMAS=(chr{1..5} chrX chrY)

for CROMOSOMA in ${CROMOSOMAS[@]}
do
    echo "Procesando $CROMOSOMA..."
done

echo "Total procesados: ${#CROMOSOMAS[@]}"
```

**Salida esperada:**
```
Procesando chr1...
Procesando chr2...
Procesando chr3...
Procesando chr4...
Procesando chr5...
Procesando chrX...
Procesando chrY...
Total procesados: 7
```

### `for` con índices — acceder a varios arrays simultáneamente

Cuando necesitas combinar información de dos arrays relacionados:

```bash
for I in ${!ORGANISMOS[@]}
do
    echo "Muestra $((I+1)): ${ORGANISMOS[$I]} — Cepa: ${CEPAS[$I]}"
done
```

> 💡 `${!ARRAY[@]}` devuelve la lista de índices (0, 1, 2...). Esto te permite acceder a múltiples arrays al mismo tiempo usando el mismo índice `$I`.

### 🧪 Ejercicio 2 — Análisis de bases nitrogenadas:

```bash
#!/bin/bash
# ejercicio2_bases.sh
# Analiza y clasifica las bases nitrogenadas del ADN

BASES=("Adenina" "Timina" "Citosina" "Guanina")
SIMBOLOS=("A" "T" "C" "G")
TIPOS=("Purina" "Pirimidina" "Pirimidina" "Purina")
PARES=("T" "A" "G" "C")

echo "=== ANÁLISIS DE BASES NITROGENADAS ==="
echo ""

for I in ${!BASES[@]}
do
    echo "Base ${SIMBOLOS[$I]} — ${BASES[$I]}"
    echo "  Tipo         : ${TIPOS[$I]}"
    echo "  Par de Watson-Crick: ${SIMBOLOS[$I]} — ${PARES[$I]}"
    echo ""
done

echo "Total de bases en el ADN: ${#BASES[@]}"
```

**Salida esperada:**
```
=== ANÁLISIS DE BASES NITROGENADAS ===

Base A — Adenina
  Tipo         : Purina
  Par de Watson-Crick: A — T

Base T — Timina
  Tipo         : Pirimidina
  Par de Watson-Crick: T — A

Base C — Citosina
  Tipo         : Pirimidina
  Par de Watson-Crick: C — G

Base G — Guanina
  Tipo         : Purina
  Par de Watson-Crick: G — C

Total de bases en el ADN: 4
```

---

## ⚙️ 4. Bucle FOR con Tres Expresiones (Estilo C)

### Sintaxis

```bash
for (( INICIALIZACIÓN ; CONDICIÓN ; INCREMENTO ))
do
    comandos
done
```

| Expresión | Función | Ejemplo |
|-----------|---------|---------|
| **Inicialización** | Valor inicial del contador | `c=1` |
| **Condición** | Mientras sea verdadera, continúa | `c<=10` |
| **Incremento** | Cómo cambia el contador cada vuelta | `c++` ó `c+=2` |

> 💡 `c++` equivale a `c=$((c+1))`. Es una notación compacta para incrementar en 1.

### Tipos de incremento

```bash
# Incremento de 1 en 1 (hacia adelante)
for ((i=1; i<=5; i++))
do
    echo "Vuelta $i"
done

# Decremento (cuenta regresiva)
for ((i=10; i>=1; i--))
do
    echo "Cuenta regresiva: $i"
done

# Incremento personalizado (de 5 en 5)
for ((i=0; i<=100; i+=5))
do
    echo "Porcentaje: $i%"
done

# Potencias de 2
for ((i=1; i<=1024; i*=2))
do
    echo "Valor: $i"
done
```

### 🔬 Pruébalo en tu terminal — simulación de cobertura:

```bash
echo "=== SIMULACIÓN DE COBERTURA DE SECUENCIACIÓN ==="
echo ""

for ((cobertura=10; cobertura<=50; cobertura+=10))
do
    if [ $cobertura -ge 30 ]
    then
        echo "Cobertura ${cobertura}x → ✅ Suficiente para análisis de variantes"
    else
        echo "Cobertura ${cobertura}x → ⚠️  Insuficiente (mínimo 30x)"
    fi
done
```

**Salida esperada:**
```
=== SIMULACIÓN DE COBERTURA DE SECUENCIACIÓN ===

Cobertura 10x → ⚠️  Insuficiente (mínimo 30x)
Cobertura 20x → ⚠️  Insuficiente (mínimo 30x)
Cobertura 30x → ✅ Suficiente para análisis de variantes
Cobertura 40x → ✅ Suficiente para análisis de variantes
Cobertura 50x → ✅ Suficiente para análisis de variantes
```

### 🧪 Ejercicio 3 — Contador de iteraciones con estadísticas:

```bash
#!/bin/bash
# ejercicio3_cstyle.sh
# Simula el procesamiento de lecturas de secuenciación

TOTAL_LECTURAS=1000000
BLOQUE=100000
LECTURAS_PROCESADAS=0

echo "=== PROCESAMIENTO DE LECTURAS NGS ==="
echo "Total de lecturas: $TOTAL_LECTURAS"
echo ""

for ((procesadas=BLOQUE; procesadas<=TOTAL_LECTURAS; procesadas+=BLOQUE))
do
    PORCENTAJE=$((procesadas * 100 / TOTAL_LECTURAS))
    echo "Progreso: $procesadas / $TOTAL_LECTURAS lecturas ($PORCENTAJE%)"
done

echo ""
echo "✅ Procesamiento completado."
```

**Salida esperada:**
```
=== PROCESAMIENTO DE LECTURAS NGS ===
Total de lecturas: 1000000

Progreso: 100000 / 1000000 lecturas (10%)
Progreso: 200000 / 1000000 lecturas (20%)
Progreso: 300000 / 1000000 lecturas (30%)
Progreso: 400000 / 1000000 lecturas (40%)
Progreso: 500000 / 1000000 lecturas (50%)
Progreso: 600000 / 1000000 lecturas (60%)
Progreso: 700000 / 1000000 lecturas (70%)
Progreso: 800000 / 1000000 lecturas (80%)
Progreso: 900000 / 1000000 lecturas (90%)
Progreso: 1000000 / 1000000 lecturas (100%)

✅ Procesamiento completado.
```

---

## 🧬 5. Scripts Bioinformáticos: De Simple a Complejo

---

### 🟢 Nivel 1 — Básico: Arrays + FOR simples

**`analizar_concentraciones.sh`** — Evalúa concentraciones de ADN de muestras.

```bash
#!/bin/bash
# analizar_concentraciones.sh
# Evalúa concentraciones de ADN y clasifica las muestras
# Uso: bash analizar_concentraciones.sh

MUESTRAS=("Muestra_01" "Muestra_02" "Muestra_03" "Muestra_04" "Muestra_05")
CONCENTRACIONES=(26 70 80 35 150)
UMBRAL_MIN=50
UMBRAL_MAX=100

echo "╔══════════════════════════════════════════════════╗"
echo "║      ANÁLISIS DE CUANTIFICACIÓN DE ADN          ║"
echo "╚══════════════════════════════════════════════════╝"
echo ""
echo "Umbral mínimo: $UMBRAL_MIN ng/µL"
echo "Umbral máximo: $UMBRAL_MAX ng/µL"
echo ""

APTAS=0
NO_APTAS=0

for I in ${!MUESTRAS[@]}
do
    MUESTRA="${MUESTRAS[$I]}"
    CONC="${CONCENTRACIONES[$I]}"

    if [ $CONC -ge $UMBRAL_MIN ] && [ $CONC -le $UMBRAL_MAX ]
    then
        ESTADO="✅ APTA     "
        APTAS=$((APTAS + 1))
    elif [ $CONC -lt $UMBRAL_MIN ]
    then
        ESTADO="⚠️  DILUIDA  "
        NO_APTAS=$((NO_APTAS + 1))
    else
        ESTADO="⚠️  CONCENTRADA"
        NO_APTAS=$((NO_APTAS + 1))
    fi

    echo "  $ESTADO | ${MUESTRA} → ${CONC} ng/µL"
done

echo ""
echo "─────────────────────────────────────────────────"
echo "  Muestras aptas    : $APTAS / ${#MUESTRAS[@]}"
echo "  Muestras no aptas : $NO_APTAS / ${#MUESTRAS[@]}"
```

**Salida esperada:**
```
╔══════════════════════════════════════════════════╗
║      ANÁLISIS DE CUANTIFICACIÓN DE ADN          ║
╚══════════════════════════════════════════════════╝

Umbral mínimo: 50 ng/µL
Umbral máximo: 100 ng/µL

  ⚠️  DILUIDA   | Muestra_01 → 26 ng/µL
  ✅ APTA      | Muestra_02 → 70 ng/µL
  ✅ APTA      | Muestra_03 → 80 ng/µL
  ⚠️  DILUIDA   | Muestra_04 → 35 ng/µL
  ⚠️  CONCENTRADA | Muestra_05 → 150 ng/µL

─────────────────────────────────────────────────
  Muestras aptas    : 2 / 5
  Muestras no aptas : 3 / 5
```

---

**`crear_estructura_experimento.sh`** — Genera automáticamente la estructura de un experimento.

```bash
#!/bin/bash
# crear_estructura_experimento.sh
# Crea estructura de directorios y archivos para un experimento de PCR
# Uso: bash crear_estructura_experimento.sh <nombre_experimento> <num_muestras>

EXPERIMENTO="${1:-Experimento_PCR}"
NUM_MUESTRAS="${2:-10}"

echo "=== CREANDO ESTRUCTURA DE EXPERIMENTO ==="
echo "Experimento : $EXPERIMENTO"
echo "Muestras    : $NUM_MUESTRAS"
echo ""

# Crear directorio raíz
mkdir -p "$EXPERIMENTO"

# Crear subdirectorios
for DIR in raw_data processed results logs
do
    mkdir -p "$EXPERIMENTO/$DIR"
    echo "📁 Creado: $EXPERIMENTO/$DIR/"
done

echo ""
echo "📄 Creando archivos de muestra..."

# Crear archivos para cada muestra con formato de 3 dígitos
for ((I=1; I<=NUM_MUESTRAS; I++))
do
    NOMBRE=$(printf "muestra_%03d" $I)
    touch "$EXPERIMENTO/raw_data/${NOMBRE}.fastq"
    echo "   → ${NOMBRE}.fastq"
done

echo ""
echo "✅ Estructura creada. Total: $NUM_MUESTRAS archivos."
echo "   $(find $EXPERIMENTO -type f | wc -l) archivos en total."
```

**Ejecución:**
```bash
bash crear_estructura_experimento.sh Experimento_RNA 5
```
```
=== CREANDO ESTRUCTURA DE EXPERIMENTO ===
Experimento : Experimento_RNA
Muestras    : 5

📁 Creado: Experimento_RNA/raw_data/
📁 Creado: Experimento_RNA/processed/
📁 Creado: Experimento_RNA/results/
📁 Creado: Experimento_RNA/logs/

📄 Creando archivos de muestra...
   → muestra_001.fastq
   → muestra_002.fastq
   → muestra_003.fastq
   → muestra_004.fastq
   → muestra_005.fastq

✅ Estructura creada. Total: 5 archivos.
   5 archivos en total.
```

---

### 🟡 Nivel 2 — Intermedio: Arrays + FOR + Variables de sesiones anteriores

**`analizador_secuencias_array.sh`** — Analiza un array de secuencias con estadísticas.

```bash
#!/bin/bash
# analizador_secuencias_array.sh
# Analiza múltiples secuencias de ADN almacenadas en un array
# Integra: arrays, for, ${#}, ${//}, subcadenas y aritmética
# Uso: bash analizador_secuencias_array.sh

SECUENCIAS=(
    "ATCGATCG"
    "GCTAGCTAGCTAGCTA"
    "AAAATTTTCCCCGGGG"
    "ATCGATCGATCGATCG"
    "GCGCGCGCGCGCGCGCGCGC"
)
IDENTIFICADORES=("seq_ecoli" "seq_salm" "seq_klebs" "seq_pseudo" "seq_staph")

echo "╔══════════════════════════════════════════════════════╗"
echo "║        ANALIZADOR DE SECUENCIAS — MODO BATCH        ║"
echo "╚══════════════════════════════════════════════════════╝"
echo ""
echo "Total de secuencias a analizar: ${#SECUENCIAS[@]}"
echo ""

LONGITUD_MAX=0
ID_MAX=""
BASES_TOTALES=0
NUM_LARGAS=0

for I in ${!SECUENCIAS[@]}
do
    SEQ="${SECUENCIAS[$I]}"
    ID="${IDENTIFICADORES[$I]}"
    LONGITUD=${#SEQ}
    ARN="${SEQ//T/U}"
    CODON_INICIO="${SEQ:0:3}"
    BASES_TOTALES=$((BASES_TOTALES + LONGITUD))

    echo "── Secuencia $((I+1)): $ID ──────────────────────"
    echo "   ADN         : $SEQ"
    echo "   ARN         : $ARN"
    echo "   Longitud    : $LONGITUD bp"
    echo "   Codón inicio: $CODON_INICIO"

    # Detectar si el codón es de inicio
    if [ "$CODON_INICIO" = "ATG" ]
    then
        echo "   Inicio ATG  : ✅ Detectado"
    else
        echo "   Inicio ATG  : ❌ No detectado"
    fi

    # Clasificar por longitud
    if [ $LONGITUD -gt 15 ]
    then
        echo "   Categoría   : Larga (>15 bp)"
        NUM_LARGAS=$((NUM_LARGAS + 1))
    else
        echo "   Categoría   : Corta (≤15 bp)"
    fi

    # Guardar la más larga
    if [ $LONGITUD -gt $LONGITUD_MAX ]
    then
        LONGITUD_MAX=$LONGITUD
        ID_MAX=$ID
    fi
    echo ""
done

PROMEDIO=$((BASES_TOTALES / ${#SECUENCIAS[@]}))

echo "══════════════════════════════════════════════════════"
echo "  RESUMEN ESTADÍSTICO"
echo "══════════════════════════════════════════════════════"
echo "  Total secuencias analizadas : ${#SECUENCIAS[@]}"
echo "  Bases totales               : $BASES_TOTALES bp"
echo "  Longitud promedio           : $PROMEDIO bp"
echo "  Secuencia más larga         : $ID_MAX ($LONGITUD_MAX bp)"
echo "  Secuencias largas (>15 bp)  : $NUM_LARGAS"
```

**Salida esperada:**
```
╔══════════════════════════════════════════════════════╗
║        ANALIZADOR DE SECUENCIAS — MODO BATCH        ║
╚══════════════════════════════════════════════════════╝

Total de secuencias a analizar: 5

── Secuencia 1: seq_ecoli ──────────────────────
   ADN         : ATCGATCG
   ARN         : AUCGAUCG
   Longitud    : 8 bp
   Codón inicio: ATC
   Inicio ATG  : ❌ No detectado
   Categoría   : Corta (≤15 bp)
...
══════════════════════════════════════════════════════
  RESUMEN ESTADÍSTICO
══════════════════════════════════════════════════════
  Total secuencias analizadas : 5
  Bases totales               : 72 bp
  Longitud promedio           : 14 bp
  Secuencia más larga         : seq_staph (20 bp)
  Secuencias largas (>15 bp)  : 2
```

---

**`buscador_genes_resistencia.sh`** — Busca genes de resistencia en un array de secuencias conocidas.

```bash
#!/bin/bash
# buscador_genes_resistencia.sh
# Busca y clasifica genes de resistencia antimicrobiana
# Uso: bash buscador_genes_resistencia.sh

# Base de datos de genes de resistencia
GENES_BD=("blaKPC" "blaNDM" "blaOXA" "mecA" "vanA" "tetM" "ermB" "qnrS")
MECANISMOS=("Beta-lactamasa" "Metalo-beta-lactamasa" "Oxacilinasa" \
            "PBP2a MRSA" "D-Ala ligasa VRE" "Ribosoma (tet)" \
            "Metilasa ARN 23S" "Protección de girasa")
ANTIBIOTICOS=("Carbapenems" "Carbapenems" "Carbapenems" \
              "Meticilina" "Vancomicina" "Tetraciclinas" \
              "Macrólidos" "Quinolonas")

# Genes encontrados en las muestras del laboratorio
MUESTRAS_GENES=("mecA" "blaNDM" "gyrA" "blaKPC" "vanA" "ompK35" "ermB")
MUESTRAS_ID=("MRSA-01" "KP-NDM-02" "EC-03" "KP-KPC-04" "EF-05" "KP-06" "SA-07")

echo "╔══════════════════════════════════════════════════════════╗"
echo "║        SISTEMA DE DETECCIÓN DE RESISTENCIAS             ║"
echo "║              Análisis de $((${#MUESTRAS_GENES[@]})) Muestras                      ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

RESISTENTES=0
NO_RESISTENTES=0

for M in ${!MUESTRAS_GENES[@]}
do
    GEN_MUESTRA="${MUESTRAS_GENES[$M]}"
    ID_MUESTRA="${MUESTRAS_ID[$M]}"
    ENCONTRADO=false

    echo "🔍 Muestra: $ID_MUESTRA — Gen detectado: $GEN_MUESTRA"

    # Buscar el gen en la base de datos
    for B in ${!GENES_BD[@]}
    do
        if [ "$GEN_MUESTRA" = "${GENES_BD[$B]}" ]
        then
            echo "   ⚠️  GEN DE RESISTENCIA CONFIRMADO"
            echo "   Mecanismo   : ${MECANISMOS[$B]}"
            echo "   Resistente a: ${ANTIBIOTICOS[$B]}"
            ENCONTRADO=true
            RESISTENTES=$((RESISTENTES + 1))
            break
        fi
    done

    if [ "$ENCONTRADO" = false ]
    then
        echo "   ✅ Gen no asociado a resistencia conocida"
        NO_RESISTENTES=$((NO_RESISTENTES + 1))
    fi
    echo ""
done

echo "══════════════════════════════════════════════════════════"
echo "  REPORTE EPIDEMIOLÓGICO"
echo "══════════════════════════════════════════════════════════"
echo "  Muestras analizadas          : ${#MUESTRAS_GENES[@]}"
echo "  Con genes de resistencia     : $RESISTENTES"
echo "  Sin genes de resistencia     : $NO_RESISTENTES"
PORCENTAJE=$((RESISTENTES * 100 / ${#MUESTRAS_GENES[@]}))
echo "  Tasa de resistencia          : $PORCENTAJE%"
```

---

### 🔴 Nivel 3 — Avanzado: Pipeline de batch con arrays, C-style for y reporte

**`pipeline_batch_fasta.sh`** — Procesa múltiples archivos FASTA en lote, genera reporte completo.

```bash
#!/bin/bash
# pipeline_batch_fasta.sh
# Pipeline de análisis FASTA en modo batch (procesamiento por lotes)
#
# Uso  : bash pipeline_batch_fasta.sh [directorio_datos] [directorio_salida]
# Ejm  : bash pipeline_batch_fasta.sh ./datos ./resultados
#
# Integra: arrays, for lista, for C-style, variables de entorno,
#          $?, $$, expansión de comandos, aritmética y reportes
#
# Autor  : [Tu nombre]
# Versión: 1.0

# ══════════════════════════════════════════════════════════
# BLOQUE 1 — CONFIGURACIÓN DEL PIPELINE
# ══════════════════════════════════════════════════════════
SCRIPT=$(basename "$0")
PID=$$
FECHA=$(date +"%Y-%m-%d")
HORA_INICIO=$(date +"%H:%M:%S")
USUARIO=$(whoami)

DIR_DATOS="${1:-.}"
DIR_SALIDA="${2:-resultados_batch_${FECHA}}"
REPORTE="$DIR_SALIDA/reporte_batch_${FECHA}_${PID}.txt"

# ══════════════════════════════════════════════════════════
# BLOQUE 2 — VALIDACIÓN DEL ENTORNO
# ══════════════════════════════════════════════════════════
echo ""
echo "╔══════════════════════════════════════════════════════════╗"
echo "║          PIPELINE BATCH — ANÁLISIS FASTA                ║"
echo "║              $(date +"%Y-%m-%d %H:%M:%S")                    ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

# Verificar directorio de datos
if [ ! -d "$DIR_DATOS" ]
then
    echo "❌ Directorio no encontrado: $DIR_DATOS"
    exit 1
fi

# Recopilar archivos FASTA en un array
ARCHIVOS_FASTA=($(ls "$DIR_DATOS"/*.fasta 2>/dev/null))

if [ ${#ARCHIVOS_FASTA[@]} -eq 0 ]
then
    echo "⚠️  No se encontraron archivos .fasta en: $DIR_DATOS"
    echo "   Creando archivos de demostración..."

    # Crear archivos de demo para la práctica
    for ORG in ecoli salmonella klebsiella pseudomonas mycobacterium
    do
        DEMO="$DIR_DATOS/${ORG}_demo.fasta"
        echo ">seq_${ORG}_1 [organism=${ORG}]" > "$DEMO"
        echo "ATCGATCGATCGATCGATCGATCGATCGATCG" >> "$DEMO"
        echo ">seq_${ORG}_2 [organism=${ORG}]" >> "$DEMO"
        echo "GCTAGCTAGCTAGCTAGCTAGCTAGCTAGCTA" >> "$DEMO"
    done

    # Recargar el array
    ARCHIVOS_FASTA=($(ls "$DIR_DATOS"/*.fasta 2>/dev/null))
    echo "   ✅ Creados ${#ARCHIVOS_FASTA[@]} archivos de demo."
fi

# Crear directorio de salida
mkdir -p "$DIR_SALIDA"

echo "📋 Configuración del pipeline:"
echo "   Directorio de datos : $DIR_DATOS"
echo "   Directorio salida   : $DIR_SALIDA"
echo "   Archivos a procesar : ${#ARCHIVOS_FASTA[@]}"
echo "   PID del pipeline    : $PID"
echo ""

# ══════════════════════════════════════════════════════════
# BLOQUE 3 — INICIALIZAR REPORTE
# ══════════════════════════════════════════════════════════
cat > "$REPORTE" << EOF
══════════════════════════════════════════════════════════════
  REPORTE BATCH DE ANÁLISIS FASTA
  Pipeline: $SCRIPT | PID: $PID
  Usuario: $USUARIO | Fecha: $FECHA | Inicio: $HORA_INICIO
══════════════════════════════════════════════════════════════

Archivos procesados: ${#ARCHIVOS_FASTA[@]}
Directorio fuente : $DIR_DATOS

──────────────────────────────────────────────────────────────
  RESULTADOS POR ARCHIVO
──────────────────────────────────────────────────────────────
EOF

# ══════════════════════════════════════════════════════════
# BLOQUE 4 — PROCESAMIENTO EN LOTE (BATCH)
# ══════════════════════════════════════════════════════════
TOTAL_ARCHIVOS=${#ARCHIVOS_FASTA[@]}
ARCHIVOS_OK=0
ARCHIVOS_ERROR=0
TOTAL_SECUENCIAS=0
TOTAL_BASES=0

echo "🔄 Iniciando procesamiento en lote..."
echo ""

# Barra de progreso — usamos bucle C-style para control preciso
for ((IDX=0; IDX<TOTAL_ARCHIVOS; IDX++))
do
    ARCHIVO="${ARCHIVOS_FASTA[$IDX]}"
    NOMBRE=$(basename "$ARCHIVO" .fasta)
    PROGRESO=$(( (IDX + 1) * 100 / TOTAL_ARCHIVOS ))

    echo "  [$((IDX+1))/$TOTAL_ARCHIVOS] ($PROGRESO%) Procesando: $NOMBRE"

    # Verificar que el archivo tiene contenido
    if [ ! -s "$ARCHIVO" ]
    then
        echo "       ⚠️  Archivo vacío — omitido"
        ARCHIVOS_ERROR=$((ARCHIVOS_ERROR + 1))
        echo "  $NOMBRE: VACÍO — omitido" >> "$REPORTE"
        continue
    fi

    # Análisis del archivo
    NUM_SEQS=$(grep -c "^>" "$ARCHIVO" 2>/dev/null)
    CODIGO_GREP=$?

    if [ $CODIGO_GREP -ne 0 ]
    then
        echo "       ❌ Error al analizar el archivo"
        ARCHIVOS_ERROR=$((ARCHIVOS_ERROR + 1))
        echo "  $NOMBRE: ERROR en análisis" >> "$REPORTE"
        continue
    fi

    # Calcular bases totales (sin cabeceras ni newlines)
    BASES=$(grep -v "^>" "$ARCHIVO" | tr -d '\n' | wc -c)
    TAMANIO_KB=$(( $(wc -c < "$ARCHIVO") / 1024 + 1 ))

    # Longitud promedio
    if [ $NUM_SEQS -gt 0 ]
    then
        LONGITUD_PROM=$((BASES / NUM_SEQS))
    else
        LONGITUD_PROM=0
    fi

    # Acumuladores globales
    TOTAL_SECUENCIAS=$((TOTAL_SECUENCIAS + NUM_SEQS))
    TOTAL_BASES=$((TOTAL_BASES + BASES))
    ARCHIVOS_OK=$((ARCHIVOS_OK + 1))

    echo "       ✅ $NUM_SEQS secuencias | $BASES bp | prom: ${LONGITUD_PROM} bp"

    # Agregar al reporte
    cat >> "$REPORTE" << EOF

  Archivo   : $NOMBRE.fasta
  Secuencias: $NUM_SEQS
  Bases     : $BASES bp
  Promedio  : $LONGITUD_PROM bp/secuencia
  Tamaño    : $TAMANIO_KB KB
  Estado    : OK
EOF

done

# ══════════════════════════════════════════════════════════
# BLOQUE 5 — RESUMEN FINAL Y CIERRE DEL REPORTE
# ══════════════════════════════════════════════════════════
HORA_FIN=$(date +"%H:%M:%S")
PROMEDIO_GLOBAL=0
if [ $TOTAL_ARCHIVOS -gt 0 ] && [ $TOTAL_SECUENCIAS -gt 0 ]
then
    PROMEDIO_GLOBAL=$((TOTAL_BASES / TOTAL_SECUENCIAS))
fi

cat >> "$REPORTE" << EOF

──────────────────────────────────────────────────────────────
  RESUMEN GLOBAL
──────────────────────────────────────────────────────────────
  Archivos procesados  : $TOTAL_ARCHIVOS
  Procesados con éxito : $ARCHIVOS_OK
  Con errores          : $ARCHIVOS_ERROR
  Total secuencias     : $TOTAL_SECUENCIAS
  Total bases          : $TOTAL_BASES bp
  Longitud promedio    : $PROMEDIO_GLOBAL bp
  Hora de inicio       : $HORA_INICIO
  Hora de fin          : $HORA_FIN

══════════════════════════════════════════════════════════════
  FIN DEL REPORTE BATCH
══════════════════════════════════════════════════════════════
EOF

echo ""
echo "══════════════════════════════════════════════════════════"
echo "  RESUMEN DEL PIPELINE"
echo "══════════════════════════════════════════════════════════"
echo "  Archivos procesados  : $TOTAL_ARCHIVOS"
echo "  Exitosos             : $ARCHIVOS_OK"
echo "  Con errores          : $ARCHIVOS_ERROR"
echo "  Total secuencias     : $TOTAL_SECUENCIAS"
echo "  Total bases          : $TOTAL_BASES bp"
echo "  Longitud promedio    : $PROMEDIO_GLOBAL bp"
echo ""
echo "📄 Reporte completo: $REPORTE"
echo "🏁 Pipeline finalizado a las $HORA_FIN"
echo ""
exit 0
```

**Ejecución:**
```bash
bash pipeline_batch_fasta.sh ./datos ./mis_resultados
```
```
╔══════════════════════════════════════════════════════════╗
║          PIPELINE BATCH — ANÁLISIS FASTA                ║
║              2026-06-14 13:45:02                        ║
╚══════════════════════════════════════════════════════════╝

📋 Configuración del pipeline:
   Directorio de datos : ./datos
   Directorio salida   : ./mis_resultados
   Archivos a procesar : 5
   PID del pipeline    : 18742

🔄 Iniciando procesamiento en lote...

  [1/5] (20%) Procesando: ecoli_demo
       ✅ 2 secuencias | 64 bp | prom: 32 bp
  [2/5] (40%) Procesando: salmonella_demo
       ✅ 2 secuencias | 64 bp | prom: 32 bp
  [3/5] (60%) Procesando: klebsiella_demo
       ✅ 2 secuencias | 64 bp | prom: 32 bp
  [4/5] (80%) Procesando: pseudomonas_demo
       ✅ 2 secuencias | 64 bp | prom: 32 bp
  [5/5] (100%) Procesando: mycobacterium_demo
       ✅ 2 secuencias | 64 bp | prom: 32 bp

══════════════════════════════════════════════════════════
  RESUMEN DEL PIPELINE
══════════════════════════════════════════════════════════
  Archivos procesados  : 5
  Exitosos             : 5
  Con errores          : 0
  Total secuencias     : 10
  Total bases          : 320 bp
  Longitud promedio    : 32 bp

📄 Reporte completo: ./mis_resultados/reporte_batch_2026-06-14_18742.txt
🏁 Pipeline finalizado a las 13:45:03
```


**Requisitos:**
 antes de entregar: `bash -n nombre_script.sh`
- [ ] Los 3 scripts se ejecutan sin errores
- [ ] Incluiste capturas de pantalla de cada misión completada
- [ ] El `informe_mision.txt` está completo y en la misma carpeta
- [ ] Subiste todo con commit descriptivo: `git commit -m "Sesion 13: arrays y bucles for - Operacion ARRAY-LOOP-007"`

---

## 🗂️ Resumen de Comandos de la Sesión

### Arrays

| Operación | Sintaxis | Ejemplo | Resultado |
|-----------|----------|---------|-----------|
| Crear array | `ARR=(v1 v2 v3)` | `GENES=("BRCA1" "TP53")` | Array de 2 elementos |
| Crear con rango | `ARR=({a..b})` | `CROM=(chr{1..22} chrX chrY)` | Array de 24 elementos |
| Leer todos | `${ARR[@]}` | `echo ${GENES[@]}` | `BRCA1 TP53` |
| Leer por índice | `${ARR[n]}` | `echo ${GENES[0]}` | `BRCA1` |
| Último elemento | `${ARR[-1]}` | `echo ${GENES[-1]}` | `TP53` |
| Longitud del array | `${#ARR[@]}` | `echo ${#GENES[@]}` | `2` |
| Índices del array | `${!ARR[@]}` | `echo ${!GENES[@]}` | `0 1` |
| Añadir elementos | `ARR+=(v)` | `GENES+=("PTEN")` | Agrega al final |
| Modificar elemento | `ARR[n]=v` | `GENES[0]="BRCA2"` | Cambia el índice 0 |
| Eliminar elemento | `unset ARR[n]` | `unset GENES[0]` | Elimina el índice 0 |
| Eliminar array | `unset ARR` | `unset GENES` | Elimina todo |

### Bucle FOR

| Variante | Sintaxis | Uso típico |
|----------|----------|-----------|
| Lista explícita | `for x in a b c; do ...; done` | Pocos elementos conocidos |
| Rango numérico | `for i in {1..10}; do ...; done` | Rangos cortos |
| Rango con paso | `for i in {0..20..2}; do ...; done` | Pares, décimas, etc. |
| Desde un array | `for x in ${ARR[@]}; do ...; done` | Recorrer colecciones |
| Con índices | `for i in ${!ARR[@]}; do ...; done` | Combinar arrays paralelos |
| Estilo C | `for ((i=0; i<N; i++)); do ...; done` | Control numérico preciso |
| Archivos | `for f in *.fasta; do ...; done` | Procesar archivos en lote |

---

## 📚 Referencias Bibliográficas

1. Blum, R., & Bresnahan, C. (2021). *Linux Command Line and Shell Scripting Bible* (4th ed.). Wiley. Capítulo 11.

2. Hausenblas, M. (2022). *Learning Modern Linux*. O'Reilly Media. Capítulo 5.  
   [https://learning.oreilly.com/library/view/learning-modern-linux/9781098108939/](https://learning.oreilly.com/library/view/learning-modern-linux/9781098108939/)

3. Documentación oficial de Bash — Arrays:  
   [https://www.gnu.org/software/bash/manual/bash.html#Arrays](https://www.gnu.org/software/bash/manual/bash.html#Arrays)

4. Documentación oficial de Bash — Looping Constructs:  
   [https://www.gnu.org/software/bash/manual/bash.html#Looping-Constructs](https://www.gnu.org/software/bash/manual/bash.html#Looping-Constructs)

5. ShellCheck — Verificador de sintaxis Bash:  
   [https://www.shellcheck.net/](https://www.shellcheck.net/)

---

> 🎓 *"En bioinformática, la diferencia entre analizar una muestra y analizar mil es exactamente un bucle for y un array. El investigador que automatiza no trabaja más rápido — trabaja de forma cualitativamente diferente: dedica su tiempo a interpretar resultados, no a repetir comandos."*

---
