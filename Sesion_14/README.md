# 🧬 Sesión 14: Integración y Pipelines
## Automatización del Ensamblaje de Genomas Bacterianos con Nanopore

**Docentes:** Frank Guzmán Escudero, Manuel Ramírez Sáenz  
**Universidad:** UPC - Facultad de Ciencias de la Salud - Programa de Biología  
**Horario:** 1:00 pm - 5:00 pm (Descanso: 2:45 pm - 3:00 pm)

---

## 🎯 Logro de la Sesión

Al finalizar esta sesión práctica, el estudiante:
- Integrará **todos los conceptos de Shell Scripting** de las sesiones 9 a 13 en un pipeline real
- Comprenderá el flujo de trabajo completo del ensamblaje de genomas bacterianos con tecnología **Nanopore**
- Relacionará cada herramienta bioinformática con el concepto de scripting que la automatiza
- Construirá scripts modulares que encadenan pasos de control de calidad, filtrado, ensamblaje y validación
- Diseñará un **pipeline reproducible** capaz de procesar múltiples aislamientos bacterianos en paralelo

**Palabras clave:** Pipeline, Nanopore, Ensamblaje genómico, Flye, Medaka, QUAST, Automatización, Reproducibilidad

---

## 📋 Pre-requisitos

- Haber completado las Sesiones 9 a 13 (fundamento completo del curso)
- Tener acceso a Google Cloud Shell o terminal Linux
- Conocer el concepto de **lecturas largas (long reads)** de secuenciación
- Haber revisado el material del curso de Genómica/Ómicas sobre secuenciación Nanopore

> 💡 **Conexión con el curso de Ómicas:** En el laboratorio de genómica trabajan con el secuenciador Oxford Nanopore MinION para obtener el genoma completo de bacterias de interés clínico (como *Klebsiella pneumoniae*, *Acinetobacter baumannii*, *E. coli*). Esta sesión te mostrará cómo el Shell Scripting convierte ese flujo de trabajo manual de 8 pasos en un pipeline automático que puedes ejecutar con un solo comando.

---

## 🧠 1. Repaso: Todo lo que necesitas para este pipeline

Antes de comenzar, revisa el mapa de herramientas que traes de las sesiones anteriores:

```bash
# ─── SESIÓN 9: La base ──────────────────────────────────────────
#!/bin/bash                              # Shebang: define el intérprete
# Comentarios explicativos              # Todo script bien documentado

# ─── SESIÓN 10: Manipulación de cadenas ─────────────────────────
MUESTRA="klebsiella_001"
PREFIJO="${MUESTRA:0:5}"                 # "kleb" — extraer subcadena
ARN="${SECUENCIA//T/U}"                  # Reemplazar caracteres
LONGITUD=${#MUESTRA}                     # Longitud de la cadena

# ─── SESIÓN 11: Control de flujo ────────────────────────────────
for ARCHIVO in *.fastq.gz; do           # Iterar sobre archivos
    if [ -s "$ARCHIVO" ]; then          # Si el archivo tiene contenido
        echo "Procesando: $ARCHIVO"
    fi
done

# ─── SESIÓN 12: Variables y operaciones ─────────────────────────
export THREADS=8                        # Variable de entorno global
N50=$((BASES_TOTALES / LECTURAS))       # Aritmética
FECHA=$(date +"%Y-%m-%d")              # Expansión de comandos
COBERTURA=$(echo "scale=1; $BASES / $GENOMA" | bc)   # Decimales
if [ $? -eq 0 ]; then echo "OK"; fi    # Verificar éxito del comando

# ─── SESIÓN 13: Arrays y FOR en lote ────────────────────────────
MUESTRAS=("ecoli_01" "kpneumo_02" "abaum_03")
for MUESTRA in "${MUESTRAS[@]}"; do     # Procesar todas las muestras
    bash ensamblar.sh "$MUESTRA"
done
```

Hoy todo esto se convierte en **un solo pipeline de producción**.

---

## 🔬 2. El Flujo de Trabajo Nanopore: De la Bacteria al Genoma

### ¿Qué es la secuenciación Nanopore?

Oxford Nanopore Technology (ONT) es una plataforma de secuenciación de **tercera generación** que produce **lecturas largas** (10,000 – 50,000 bp) en tiempo real. Esto es ideal para el ensamblaje de genomas bacterianos porque las lecturas largas pueden cruzar regiones repetitivas que las plataformas cortas (Illumina) no pueden resolver.

```
BACTERIA EN EL LABORATORIO
         │
         ▼
┌─────────────────────┐
│  1. Extracción ADN  │  ← Trabajo de laboratorio húmedo
│  2. Preparación     │
│     biblioteca      │
└──────────┬──────────┘
           │
           ▼
┌─────────────────────┐
│  3. Secuenciación   │  ← MinION / GridION (Oxford Nanopore)
│     Nanopore        │     Produce archivos .fast5 o .pod5
└──────────┬──────────┘
           │
           ▼  ← DESDE AQUÍ ENTRA EL SHELL SCRIPTING
┌─────────────────────┐
│  4. Basecalling     │  → Dorado/Guppy      → .fastq.gz
├─────────────────────┤
│  5. Control de      │  → NanoStat/NanoPlot → Reportes QC
│     Calidad         │
├─────────────────────┤
│  6. Filtrado y      │  → Filtlong/Porechop → .fastq.gz filtrado
│     Limpieza        │
├─────────────────────┤
│  7. Ensamblaje      │  → Flye              → .fasta (contigs)
├─────────────────────┤
│  8. Pulido          │  → Medaka            → .fasta (consenso)
│     (Polishing)     │
├─────────────────────┤
│  9. Control de      │  → QUAST / CheckM    → Métricas de calidad
│     Calidad del     │
│     Ensamblaje      │
├─────────────────────┤
│ 10. Anotación       │  → Prokka            → .gff / .gbk
└─────────────────────┘
           │
           ▼
  GENOMA ANOTADO LISTO
```

### Mapa de herramientas y conceptos de scripting

| Paso del pipeline | Herramienta | Concepto de scripting aplicado |
|------------------|-------------|-------------------------------|
| Configuración del entorno | Conda / bash | `export`, `PATH`, `source` (S12) |
| Validación de entrada | bash | `if -f -s`, `$?`, `$#` (S11, S12) |
| QC de lecturas | NanoStat | Variables, redirección `>`, `2>` (S04, S12) |
| Filtrado | Filtlong | Arrays, `for`, argumentos `$1 $2` (S12, S13) |
| Ensamblaje en lote | Flye | Arrays, `for` C-style, `$?` (S13) |
| Pulido | Medaka | Variables de entorno, `&&` condicional (S04) |
| QC del ensamblaje | QUAST | Pipes `|`, redirección, `tee` (S04) |
| Reporte final | bash | Expansión `$()`, here-doc, aritmética (S12) |

---

## ⚙️ 3. Configuración del Entorno del Pipeline

### El archivo de configuración: el cerebro del pipeline

Antes de correr cualquier análisis, un buen pipeline define **todas sus variables en un único archivo de configuración**. Esto hace que el pipeline sea reproducible y fácil de adaptar.

```bash
# config_pipeline.sh
# Fuente: source config_pipeline.sh
# ─────────────────────────────────────────────────────────────
# HERRAMIENTAS (rutas a ejecutables o comandos de conda)
# ─────────────────────────────────────────────────────────────
export DORADO="dorado"
export NANOSTAT="NanoStat"
export FILTLONG="filtlong"
export FLYE="flye"
export MEDAKA="medaka_consensus"
export QUAST="quast.py"
export PROKKA="prokka"
export CHECKM="checkm"

# ─────────────────────────────────────────────────────────────
# PARÁMETROS BIOLÓGICOS
# ─────────────────────────────────────────────────────────────
export GENOMA_SIZE="5m"          # Tamaño estimado del genoma bacteriano (~5 Mb)
export COBERTURA_MIN=50          # Cobertura mínima aceptable (50x)
export CALIDAD_MIN=8             # Q-score mínimo de Nanopore
export LONGITUD_MIN=1000         # Longitud mínima de lectura (bp)

# ─────────────────────────────────────────────────────────────
# RECURSOS COMPUTACIONALES
# ─────────────────────────────────────────────────────────────
export THREADS=$(nproc)          # Usa todos los núcleos disponibles
export MEMORIA="16G"

# ─────────────────────────────────────────────────────────────
# DIRECTORIOS DEL PROYECTO
# ─────────────────────────────────────────────────────────────
export DIR_RAW="01_raw"
export DIR_QC="02_qc"
export DIR_FILTRADO="03_filtrado"
export DIR_ENSAMBLAJE="04_ensamblaje"
export DIR_PULIDO="05_pulido"
export DIR_QC_ASM="06_qc_ensamblaje"
export DIR_ANOTACION="07_anotacion"
export DIR_REPORTES="08_reportes"
```

### 🔬 Pruébalo en tu terminal — activar el entorno:

```bash
# Crear el archivo de configuración
nano config_pipeline.sh

# Activarlo en la sesión actual
source config_pipeline.sh

# Verificar que las variables están disponibles
echo "Threads    : $THREADS"
echo "Genoma     : $GENOMA_SIZE"
echo "Cobertura  : $COBERTURA_MIN x"
echo "Directorio : $DIR_ENSAMBLAJE"
```

**Salida esperada:**
```
Threads    : 8
Genoma     : 5m
Cobertura  : 50 x
Directorio : 04_ensamblaje
```

---

## 📁 4. Paso 0 — Estructura del Proyecto y Validación de Entrada

El primer script de cualquier pipeline inicializa la estructura de directorios y verifica que los datos de entrada existen y son válidos.

### 🧪 Ejercicio 1 — Script de inicialización:

Crea `00_inicializar_proyecto.sh`:

```bash
#!/bin/bash
# 00_inicializar_proyecto.sh
# Inicializa la estructura del proyecto de ensamblaje Nanopore
# Uso: bash 00_inicializar_proyecto.sh <nombre_proyecto> <directorio_fastq>

source config_pipeline.sh

PROYECTO="$1"
DIR_FASTQ="$2"

# ── Validar argumentos ─────────────────────────────────────────────
if [ $# -lt 2 ]
then
    echo ""
    echo "❌ ERROR: Faltan argumentos."
    echo "   Uso: bash $0 <nombre_proyecto> <directorio_fastq>"
    echo "   Ejm: bash $0 MRSA_Peru_2026 /datos/nanopore/corrida_01"
    echo ""
    exit 1
fi

echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║    PIPELINE DE ENSAMBLAJE GENÓMICO NANOPORE — UPC 2026     ║"
echo "║    Inicio: $(date +'%Y-%m-%d %H:%M:%S')                         ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""
echo "📌 Proyecto  : $PROYECTO"
echo "👤 Usuario   : $(whoami)"
echo "🖥️  Máquina   : $(hostname)"
echo "🧵 Threads   : $THREADS"
echo ""

# ── Verificar directorio de datos ──────────────────────────────────
if [ ! -d "$DIR_FASTQ" ]
then
    echo "❌ No se encontró el directorio: $DIR_FASTQ"
    exit 1
fi

# ── Detectar muestras disponibles ──────────────────────────────────
ARCHIVOS_FASTQ=($(ls "$DIR_FASTQ"/*.fastq.gz 2>/dev/null))

if [ ${#ARCHIVOS_FASTQ[@]} -eq 0 ]
then
    echo "⚠️  No se encontraron archivos .fastq.gz en $DIR_FASTQ"
    echo "   Creando datos de demostración para la práctica..."

    mkdir -p "$DIR_FASTQ"
    for ORG in kpneumo_001 ecoli_002 abaum_003
    do
        # Crear FASTQ simulado con encabezados reales Nanopore
        python3 -c "
import random, string
bases = 'ATCG'
for i in range(100):
    read_id = 'read_' + ''.join(random.choices(string.hexdigits, k=8))
    seq = ''.join(random.choices(bases, k=random.randint(8000,15000)))
    qual = ''.join([chr(random.randint(33,74)) for _ in seq])
    print(f'@{read_id} runid=abc123 sampleid=${ORG}')
    print(seq)
    print('+')
    print(qual)
" | gzip > "$DIR_FASTQ/${ORG}.fastq.gz"
        echo "   → Creado: ${ORG}.fastq.gz"
    done
    ARCHIVOS_FASTQ=($(ls "$DIR_FASTQ"/*.fastq.gz))
fi

# ── Crear estructura de directorios ────────────────────────────────
echo ""
echo "📁 Creando estructura del proyecto: $PROYECTO/"
DIRS=($DIR_RAW $DIR_QC $DIR_FILTRADO $DIR_ENSAMBLAJE \
      $DIR_PULIDO $DIR_QC_ASM $DIR_ANOTACION $DIR_REPORTES)

for DIR in "${DIRS[@]}"
do
    mkdir -p "$PROYECTO/$DIR"
    echo "   ✅ $PROYECTO/$DIR/"
done

# ── Generar tabla de muestras ───────────────────────────────────────
TABLA="$PROYECTO/muestras.tsv"
echo -e "ID\tArchivo\tRuta_completa" > "$TABLA"

IDX=1
MUESTRAS_IDS=()
for FASTQ in "${ARCHIVOS_FASTQ[@]}"
do
    NOMBRE=$(basename "$FASTQ" .fastq.gz)
    MUESTRAS_IDS+=("$NOMBRE")
    echo -e "$IDX\t$NOMBRE\t$FASTQ" >> "$TABLA"
    IDX=$((IDX + 1))
done

echo ""
echo "📋 Muestras registradas: ${#MUESTRAS_IDS[@]}"
echo ""
cat "$TABLA"
echo ""
echo "✅ Proyecto inicializado. Tabla de muestras: $TABLA"
echo "   Siguiente paso: bash 01_control_calidad.sh $PROYECTO"
```

**Salida esperada:**
```
╔══════════════════════════════════════════════════════════════╗
║    PIPELINE DE ENSAMBLAJE GENÓMICO NANOPORE — UPC 2026     ║
║    Inicio: 2026-06-14 14:00:01                              ║
╚══════════════════════════════════════════════════════════════╝

📌 Proyecto  : MRSA_Peru_2026
👤 Usuario   : mramirez
🖥️  Máquina   : cloudshell-vm
🧵 Threads   : 8

📁 Creando estructura del proyecto: MRSA_Peru_2026/
   ✅ MRSA_Peru_2026/01_raw/
   ✅ MRSA_Peru_2026/02_qc/
   ✅ MRSA_Peru_2026/03_filtrado/
   ✅ MRSA_Peru_2026/04_ensamblaje/
   ✅ MRSA_Peru_2026/05_pulido/
   ✅ MRSA_Peru_2026/06_qc_ensamblaje/
   ✅ MRSA_Peru_2026/07_anotacion/
   ✅ MRSA_Peru_2026/08_reportes/

📋 Muestras registradas: 3

ID  Archivo         Ruta_completa
1   kpneumo_001     /datos/nanopore/kpneumo_001.fastq.gz
2   ecoli_002       /datos/nanopore/ecoli_002.fastq.gz
3   abaum_003       /datos/nanopore/abaum_003.fastq.gz

✅ Proyecto inicializado.
```

---

## 📊 5. Paso 1 — Control de Calidad de Lecturas Nanopore

### ¿Qué métricas importan en Nanopore?

Antes de ensamblar, debemos conocer la calidad del experimento de secuenciación:

| Métrica | Herramienta | ¿Qué indica? | Valor deseable |
|---------|-------------|-------------|----------------|
| **Total de bases** | NanoStat | Cuánta información tenemos | > 250 Mb (50x cobertura) |
| **Longitud promedio** | NanoStat | Qué tan largas son las lecturas | > 5,000 bp |
| **N50** | NanoStat | Longitud de la lectura mediana ponderada | > 10,000 bp |
| **Q-score promedio** | NanoStat | Calidad de la secuenciación | > Q10 |
| **Distribución de longitudes** | NanoPlot | Visualización de calidad | — |

### 🔬 Pruébalo en tu terminal — qué haría NanoStat:

```bash
# Este sería el comando real (requiere NanoStat instalado):
# NanoStat --fastq muestra.fastq.gz --outdir qc/ --name muestra_QC

# Para la práctica, simularemos su salida:
cat << 'EOF'
General summary:
Mean read length:                 12,547.3
Mean read quality:                    14.2
Median read length:               10,832.0
Median read quality:                  14.5
Number of reads:                  82,341.0
Read length N50:                  16,204.0
Total bases:                 1,032,894,327
Number, percentage and megabases of reads above quality cutoffs
>Q5:    82341 (100.0%) 1032.9Mb
>Q7:    81923 (99.5%) 1027.3Mb
>Q10:   79122 (96.1%) 995.4Mb
>Q12:   71348 (86.6%) 883.2Mb
>Q15:   43211 (52.5%) 521.7Mb
EOF
```

### 🧪 Ejercicio 2 — Script de control de calidad en lote:

Crea `01_control_calidad.sh`:

```bash
#!/bin/bash
# 01_control_calidad.sh
# Ejecuta control de calidad sobre todas las muestras del proyecto
# Uso: bash 01_control_calidad.sh <directorio_proyecto>

source config_pipeline.sh
PROYECTO="$1"

if [ $# -lt 1 ] || [ ! -d "$PROYECTO" ]
then
    echo "❌ Uso: bash $0 <directorio_proyecto>"
    exit 1
fi

TABLA="$PROYECTO/muestras.tsv"
LOG="$PROYECTO/$DIR_QC/qc_$(date +%Y%m%d_%H%M%S).log"

echo "╔════════════════════════════════════════════════════╗"
echo "║    PASO 1: CONTROL DE CALIDAD DE LECTURAS         ║"
echo "╚════════════════════════════════════════════════════╝"
echo ""

# Leer muestras desde la tabla (saltar encabezado con tail)
MUESTRAS_NOMBRES=()
MUESTRAS_RUTAS=()

while IFS=$'\t' read -r ID NOMBRE RUTA
do
    MUESTRAS_NOMBRES+=("$NOMBRE")
    MUESTRAS_RUTAS+=("$RUTA")
done < <(tail -n +2 "$TABLA")

echo "Muestras a procesar: ${#MUESTRAS_NOMBRES[@]}"
echo ""

APROBADAS=0
RECHAZADAS=0
RECHAZADAS_LISTA=()

for I in ${!MUESTRAS_NOMBRES[@]}
do
    MUESTRA="${MUESTRAS_NOMBRES[$I]}"
    FASTQ="${MUESTRAS_RUTAS[$I]}"
    DIR_SALIDA="$PROYECTO/$DIR_QC/$MUESTRA"
    mkdir -p "$DIR_SALIDA"

    echo "── [$((I+1))/${#MUESTRAS_NOMBRES[@]}] $MUESTRA ──────────────────────"

    # Verificar que el archivo existe y tiene contenido
    if [ ! -f "$FASTQ" ] || [ ! -s "$FASTQ" ]
    then
        echo "   ❌ Archivo no encontrado o vacío: $FASTQ"
        RECHAZADAS=$((RECHAZADAS + 1))
        RECHAZADAS_LISTA+=("$MUESTRA")
        continue
    fi

    # En un entorno real, ejecutaríamos:
    # NanoStat --fastq "$FASTQ" --outdir "$DIR_SALIDA" --name "$MUESTRA" \
    #          --threads $THREADS > "$DIR_SALIDA/nanostat.log" 2>&1
    # CODIGO=$?

    # Para la práctica — simular métricas de NanoStat
    TOTAL_READS=$((RANDOM % 50000 + 30000))
    MEAN_LEN=$((RANDOM % 8000 + 8000))
    MEAN_QUAL=$((RANDOM % 5 + 10))
    N50=$((MEAN_LEN + RANDOM % 5000))
    TOTAL_BASES=$((TOTAL_READS * MEAN_LEN))
    COBERTURA_EST=$((TOTAL_BASES / 5000000))

    # Guardar métricas en archivo de resumen
    cat > "$DIR_SALIDA/resumen_qc.txt" << EOF
Muestra          : $MUESTRA
Lecturas totales : $TOTAL_READS
Longitud media   : $MEAN_LEN bp
Q-score medio    : $MEAN_QUAL
N50              : $N50 bp
Bases totales    : $TOTAL_BASES bp
Cobertura estim. : ${COBERTURA_EST}x
EOF

    echo "   📊 Lecturas     : $TOTAL_READS"
    echo "   📏 Long. media  : $MEAN_LEN bp"
    echo "   ⭐ Q-score      : Q${MEAN_QUAL}"
    echo "   📐 N50          : $N50 bp"
    echo "   🧬 Bases totales: $TOTAL_BASES bp"
    echo "   📈 Cobertura    : ${COBERTURA_EST}x"

    # Evaluar si la muestra aprueba los criterios de calidad
    if [ $MEAN_QUAL -ge $CALIDAD_MIN ] && [ $COBERTURA_EST -ge $COBERTURA_MIN ]
    then
        echo "   ✅ APROBADA — Calidad y cobertura aceptables"
        APROBADAS=$((APROBADAS + 1))
        echo "$MUESTRA	$FASTQ	APROBADA" >> "$PROYECTO/muestras_qc.tsv"
    else
        echo "   ❌ RECHAZADA — Calidad insuficiente"
        RECHAZADAS=$((RECHAZADAS + 1))
        RECHAZADAS_LISTA+=("$MUESTRA")
        echo "$MUESTRA	$FASTQ	RECHAZADA" >> "$PROYECTO/muestras_qc.tsv"
    fi
    echo ""
done

echo "════════════════════════════════════════════════════"
echo "  RESUMEN DEL CONTROL DE CALIDAD"
echo "════════════════════════════════════════════════════"
echo "  Total muestras  : ${#MUESTRAS_NOMBRES[@]}"
echo "  Aprobadas       : $APROBADAS ✅"
echo "  Rechazadas      : $RECHAZADAS ❌"

if [ ${#RECHAZADAS_LISTA[@]} -gt 0 ]
then
    echo "  Muestras rechazadas:"
    for M in "${RECHAZADAS_LISTA[@]}"
    do
        echo "    → $M"
    done
fi

echo ""
echo "📄 Resultados en: $PROYECTO/$DIR_QC/"
echo "   Siguiente paso: bash 02_filtrar.sh $PROYECTO"
```

---

## 🔧 6. Paso 2 — Filtrado y Limpieza de Lecturas

### ¿Por qué filtrar?

Las lecturas Nanopore pueden contener:
- **Secuencias de adaptadores** (Porechop las elimina)
- **Lecturas muy cortas** (< 1,000 bp) que no ayudan al ensamblaje
- **Lecturas de baja calidad** (Q < 8) que introducen errores
- **Exceso de cobertura** — con 200x, Filtlong selecciona las mejores lecturas hasta 100x

### 🧪 Ejercicio 3 — Script de filtrado con Filtlong:

Crea `02_filtrar.sh`:

```bash
#!/bin/bash
# 02_filtrar.sh
# Filtra y limpia lecturas Nanopore con Filtlong
# Uso: bash 02_filtrar.sh <directorio_proyecto>
#
# Filtlong selecciona las mejores lecturas por longitud y calidad.
# Documentación: https://github.com/rrwick/Filtlong

source config_pipeline.sh
PROYECTO="$1"

if [ ! -f "$PROYECTO/muestras_qc.tsv" ]
then
    echo "❌ No se encontró muestras_qc.tsv. Ejecuta primero 01_control_calidad.sh"
    exit 1
fi

echo "╔════════════════════════════════════════════════════╗"
echo "║    PASO 2: FILTRADO DE LECTURAS (Filtlong)        ║"
echo "╚════════════════════════════════════════════════════╝"
echo ""
echo "Parámetros de filtrado:"
echo "  Longitud mínima : $LONGITUD_MIN bp"
echo "  Q-score mínimo  : $CALIDAD_MIN"
echo "  Cobertura máx.  : ${COBERTURA_MIN}x (bases objetivo: $((COBERTURA_MIN * 5000000)))"
echo ""

BASES_OBJETIVO=$((COBERTURA_MIN * 5000000))
PROCESADAS=0
ERRORES=0

# Solo procesar muestras APROBADAS en el QC
while IFS=$'\t' read -r MUESTRA FASTQ ESTADO
do
    if [ "$ESTADO" != "APROBADA" ]
    then
        echo "  ⏭️  Omitiendo $MUESTRA (estado: $ESTADO)"
        continue
    fi

    echo "── Filtrando: $MUESTRA ────────────────────────────"

    FASTQ_FILTRADO="$PROYECTO/$DIR_FILTRADO/${MUESTRA}_filtrado.fastq.gz"
    mkdir -p "$PROYECTO/$DIR_FILTRADO"

    # Comando real de Filtlong:
    # filtlong \
    #     --min_length $LONGITUD_MIN \
    #     --min_mean_q $CALIDAD_MIN \
    #     --target_bases $BASES_OBJETIVO \
    #     "$FASTQ" | gzip > "$FASTQ_FILTRADO"
    # CODIGO=$?

    # Para la práctica — simular el filtrado copiando el archivo
    cp "$FASTQ" "$FASTQ_FILTRADO" 2>/dev/null || \
        echo "   (Archivo simulado)" && \
        echo "sim_data" | gzip > "$FASTQ_FILTRADO"

    CODIGO=$?

    if [ $CODIGO -eq 0 ]
    then
        echo "   ✅ Filtrado completado"
        echo "   📁 Salida: $FASTQ_FILTRADO"
        PROCESADAS=$((PROCESADAS + 1))
        # Registrar para el siguiente paso
        echo "$MUESTRA	$FASTQ_FILTRADO" >> "$PROYECTO/muestras_filtradas.tsv"
    else
        echo "   ❌ Error en el filtrado (código: $CODIGO)"
        ERRORES=$((ERRORES + 1))
    fi
    echo ""

done < "$PROYECTO/muestras_qc.tsv"

echo "════════════════════════════════════════════════════"
echo "  Muestras filtradas : $PROCESADAS ✅"
echo "  Errores            : $ERRORES ❌"
echo "  Siguiente paso     : bash 03_ensamblar.sh $PROYECTO"
```

---

## 🏗️ 7. Paso 3 — Ensamblaje con Flye

### ¿Qué es Flye?

**Flye** es el ensamblador de genomas más utilizado para lecturas largas Nanopore. Su algoritmo construye el genoma completo a partir de las lecturas superpuestas, produciendo contigs (fragmentos contiguos de ADN) que idealmente representan cromosomas o plásmidos completos.

```
Lecturas Nanopore (caóticas):
  ATCGATCG----CGATCGAT----TCGATCGAT
      CGATCGATCG----ATCGATCGAT
           ATCGATCGATCGAT----CGATCGAT

Flye → Grafo de ensamblaje → Contigs → Genoma
  ATCGATCGATCGATCGATCGATCGATCGATCG...  (cromosoma completo)
```

### 🔬 El comando real de Flye:

```bash
# Ensamblaje de un genoma bacteriano con lecturas Nanopore (Q20+)
flye \
    --nano-hq muestra_filtrada.fastq.gz \
    --out-dir ensamblaje_muestra/ \
    --genome-size 5m \
    --threads 8 \
    --iterations 3

# Para lecturas de menor calidad (Q<20):
# --nano-raw  en lugar de  --nano-hq
```

**Archivos de salida importantes de Flye:**

| Archivo | Contenido |
|---------|-----------|
| `assembly.fasta` | Contigs del ensamblaje |
| `assembly_info.txt` | Información por contig (longitud, cobertura, circularidad) |
| `assembly_graph.gfa` | Grafo de ensamblaje (visualizable con Bandage) |
| `flye.log` | Log completo del proceso |

### 🧪 Ejercicio 4 — Script de ensamblaje en lote:

Crea `03_ensamblar.sh`:

```bash
#!/bin/bash
# 03_ensamblar.sh
# Ensambla genomas bacterianos con Flye — procesamiento en lote
# Uso: bash 03_ensamblar.sh <directorio_proyecto>

source config_pipeline.sh
PROYECTO="$1"

if [ ! -f "$PROYECTO/muestras_filtradas.tsv" ]
then
    echo "❌ Ejecuta primero 02_filtrar.sh"
    exit 1
fi

echo "╔════════════════════════════════════════════════════════════╗"
echo "║    PASO 3: ENSAMBLAJE DE GENOMAS (Flye)                  ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "Parámetros de Flye:"
echo "  Modo          : --nano-hq (lecturas Q20+)"
echo "  Tamaño genoma : $GENOMA_SIZE"
echo "  Threads       : $THREADS"
echo "  Iteraciones   : 3"
echo ""

# Leer tabla de muestras filtradas
MUESTRAS=()
FASTQS=()
while IFS=$'\t' read -r MUESTRA FASTQ
do
    MUESTRAS+=("$MUESTRA")
    FASTQS+=("$FASTQ")
done < "$PROYECTO/muestras_filtradas.tsv"

echo "Muestras a ensamblar: ${#MUESTRAS[@]}"
echo ""

ENSAMBLADAS=0
FALLIDAS=0
HORA_INICIO=$(date +%s)

for ((I=0; I<${#MUESTRAS[@]}; I++))
do
    MUESTRA="${MUESTRAS[$I]}"
    FASTQ="${FASTQS[$I]}"
    DIR_ASM="$PROYECTO/$DIR_ENSAMBLAJE/$MUESTRA"
    PROGRESO=$(( (I+1) * 100 / ${#MUESTRAS[@]} ))

    echo "── [$((I+1))/${#MUESTRAS[@]}] ($PROGRESO%) Ensamblando: $MUESTRA"
    echo "   Inicio: $(date +'%H:%M:%S')"
    mkdir -p "$DIR_ASM"

    # ── COMANDO REAL DE FLYE ──────────────────────────────────────
    # flye \
    #     --nano-hq "$FASTQ" \
    #     --out-dir "$DIR_ASM" \
    #     --genome-size $GENOMA_SIZE \
    #     --threads $THREADS \
    #     --iterations 3 \
    #     > "$DIR_ASM/flye.log" 2>&1
    # CODIGO_FLYE=$?
    # ─────────────────────────────────────────────────────────────

    # Para la práctica — crear un FASTA de ensamblaje simulado
    python3 -c "
import random
bases = 'ATCG'
# Simular 1-3 contigs (cromosoma + posibles plásmidos)
contigs = [('contig_1', 4800000), ('contig_2', 85000)]
for nombre, longitud in contigs:
    seq = ''.join(random.choices(bases, k=longitud))
    print(f'>{nombre} length={longitud} circular=Y')
    # Imprimir en líneas de 80 caracteres
    for j in range(0, len(seq), 80):
        print(seq[j:j+80])
" > "$DIR_ASM/assembly.fasta"

    # Crear assembly_info simulado
    cat > "$DIR_ASM/assembly_info.txt" << EOF
#seq_name	length	cov.	circ.	repeat	mult.	alt_group	graph_path
contig_1	4800000	$(( RANDOM % 100 + 80 ))	Y	N	1	*	*
contig_2	85000	$(( RANDOM % 50 + 20 ))	Y	N	1	*	*
EOF

    CODIGO_FLYE=0   # Simulación exitosa

    if [ $CODIGO_FLYE -eq 0 ] && [ -f "$DIR_ASM/assembly.fasta" ]
    then
        NUM_CONTIGS=$(grep -c "^>" "$DIR_ASM/assembly.fasta")
        TOTAL_BASES=$(grep -v "^>" "$DIR_ASM/assembly.fasta" | tr -d '\n' | wc -c)
        TOTAL_MB=$(echo "scale=2; $TOTAL_BASES / 1000000" | bc)

        echo "   ✅ Ensamblaje completado"
        echo "   🧩 Contigs      : $NUM_CONTIGS"
        echo "   🧬 Bases totales: ${TOTAL_MB} Mb"
        echo "   📁 Salida       : $DIR_ASM/"

        ENSAMBLADAS=$((ENSAMBLADAS + 1))
        echo "$MUESTRA	$DIR_ASM/assembly.fasta	$NUM_CONTIGS	$TOTAL_MB" \
            >> "$PROYECTO/muestras_ensambladas.tsv"
    else
        echo "   ❌ Ensamblaje fallido (código: $CODIGO_FLYE)"
        echo "   📋 Log: $DIR_ASM/flye.log"
        FALLIDAS=$((FALLIDAS + 1))
    fi
    echo ""
done

HORA_FIN=$(date +%s)
DURACION=$(( (HORA_FIN - HORA_INICIO) / 60 ))

echo "════════════════════════════════════════════════════════════"
echo "  Ensamblajes completados : $ENSAMBLADAS ✅"
echo "  Fallidos                : $FALLIDAS ❌"
echo "  Tiempo total            : ${DURACION} minutos"
echo "  Siguiente paso          : bash 04_pulir.sh $PROYECTO"
```

---

## ✨ 8. Paso 4 — Pulido con Medaka

### ¿Por qué pulir el ensamblaje?

El ensamblaje de Flye puede tener errores sistemáticos de homopolímeros (ej: `AAAA` puede convertirse en `AAAAT`). **Medaka** usa las lecturas originales para corregir el consenso del ensamblaje, mejorando la precisión del genoma final.

```
Antes del pulido (Flye):   ATCGAAAAT-TGCATCG   ← error de homopolímero
Después del pulido (Medaka): ATCGAAAATTGCATCG   ← corregido
```

```bash
#!/bin/bash
# 04_pulir.sh
# Pule los ensamblajes con Medaka para corregir errores de consenso
# Uso: bash 04_pulir.sh <directorio_proyecto>

source config_pipeline.sh
PROYECTO="$1"

if [ ! -f "$PROYECTO/muestras_ensambladas.tsv" ]
then
    echo "❌ Ejecuta primero 03_ensamblar.sh"
    exit 1
fi

echo "╔════════════════════════════════════════════════════════════╗"
echo "║    PASO 4: PULIDO DE ENSAMBLAJES (Medaka)                ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""
echo "Modelo Medaka: r1041_e82_400bps_hac_v4.3.0"
echo ""

PULIDAS=0
FALLIDAS=0

while IFS=$'\t' read -r MUESTRA FASTA CONTIGS MB
do
    echo "── Puliendo: $MUESTRA ───────────────────────────────────"
    DIR_PULIDO_M="$PROYECTO/$DIR_PULIDO/$MUESTRA"
    FASTA_PULIDO="$DIR_PULIDO_M/${MUESTRA}_pulido.fasta"
    mkdir -p "$DIR_PULIDO_M"

    # FASTQ filtrado (necesario para el pulido)
    FASTQ_FILTRADO="$PROYECTO/$DIR_FILTRADO/${MUESTRA}_filtrado.fastq.gz"

    # ── COMANDO REAL DE MEDAKA ────────────────────────────────────
    # medaka_consensus \
    #     -i "$FASTQ_FILTRADO" \
    #     -d "$FASTA" \
    #     -o "$DIR_PULIDO_M" \
    #     -t $THREADS \
    #     -m r1041_e82_400bps_hac_v4.3.0 \
    #     > "$DIR_PULIDO_M/medaka.log" 2>&1
    # CODIGO=$?
    # cp "$DIR_PULIDO_M/consensus.fasta" "$FASTA_PULIDO"
    # ─────────────────────────────────────────────────────────────

    # Simulación para práctica
    cp "$FASTA" "$FASTA_PULIDO" 2>/dev/null || \
        echo ">contig_1_pulido" > "$FASTA_PULIDO"
    CODIGO=0

    if [ $CODIGO -eq 0 ]
    then
        echo "   ✅ Pulido completado"
        echo "   📁 Genoma final: $FASTA_PULIDO"
        PULIDAS=$((PULIDAS + 1))
        echo "$MUESTRA	$FASTA_PULIDO" >> "$PROYECTO/muestras_pulidas.tsv"
    else
        echo "   ❌ Error en pulido"
        FALLIDAS=$((FALLIDAS + 1))
    fi
    echo ""

done < "$PROYECTO/muestras_ensambladas.tsv"

echo "════════════════════════════════════════════════════════════"
echo "  Genomas pulidos: $PULIDAS ✅  |  Fallidos: $FALLIDAS ❌"
echo "  Siguiente paso : bash 05_qc_ensamblaje.sh $PROYECTO"
```

---

## 📐 9. Paso 5 — Control de Calidad del Ensamblaje

### Métricas de calidad de un buen ensamblaje bacteriano

| Herramienta | Métrica | Valor deseable para bacteria |
|-------------|---------|------------------------------|
| **QUAST** | N50 | > 500,000 bp (idealmente = tamaño del cromosoma) |
| **QUAST** | Número de contigs | 1–5 (1 cromosoma + plásmidos) |
| **QUAST** | Cobertura del genoma | > 95% |
| **CheckM** | Completitud | > 95% |
| **CheckM** | Contaminación | < 5% |
| **BUSCO** | Genes core presentes | > 95% |

```bash
#!/bin/bash
# 05_qc_ensamblaje.sh
# Evalúa la calidad de los ensamblajes con QUAST y CheckM
# Uso: bash 05_qc_ensamblaje.sh <directorio_proyecto>

source config_pipeline.sh
PROYECTO="$1"

echo "╔════════════════════════════════════════════════════════════╗"
echo "║    PASO 5: CONTROL DE CALIDAD DEL ENSAMBLAJE             ║"
echo "║    Herramientas: QUAST + CheckM                          ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

APROBADOS=0
RECHAZADOS=0
REPORTE_GLOBAL="$PROYECTO/$DIR_QC_ASM/reporte_qc_ensamblajes.tsv"

echo -e "Muestra\tContigs\tN50\tCompletitud\tContaminacion\tEstado" \
    > "$REPORTE_GLOBAL"

while IFS=$'\t' read -r MUESTRA FASTA
do
    DIR_QC_M="$PROYECTO/$DIR_QC_ASM/$MUESTRA"
    mkdir -p "$DIR_QC_M"

    echo "── Evaluando: $MUESTRA ──────────────────────────────────"

    # ── QUAST (métricas de ensamblaje) ───────────────────────────
    # quast.py "$FASTA" -o "$DIR_QC_M/quast/" --threads $THREADS \
    #     > "$DIR_QC_M/quast.log" 2>&1

    # Simular métricas QUAST
    NUM_CONTIGS=$((RANDOM % 3 + 1))
    N50=$((RANDOM % 2000000 + 3000000))
    N50_KB=$((N50 / 1000))
    GENOMA_TOTAL=$((NUM_CONTIGS == 1 ? 4800000 + RANDOM % 400000 : \
                    4800000 + RANDOM % 400000 + 85000))
    GENOMA_MB=$(echo "scale=2; $GENOMA_TOTAL / 1000000" | bc)

    echo "   📊 QUAST:"
    echo "      Contigs      : $NUM_CONTIGS"
    echo "      N50          : ${N50_KB} Kbp"
    echo "      Genoma total : ${GENOMA_MB} Mb"

    # ── CheckM (completitud y contaminación) ─────────────────────
    # checkm lineage_wf "$DIR_QC_M" "$DIR_QC_M/checkm/" \
    #     --threads $THREADS --file "$DIR_QC_M/checkm.tsv"

    # Simular métricas CheckM
    COMPLETITUD=$((RANDOM % 6 + 94))
    CONTAMINACION=$((RANDOM % 4))

    echo "   🔬 CheckM:"
    echo "      Completitud  : ${COMPLETITUD}%"
    echo "      Contaminación: ${CONTAMINACION}%"

    # ── Evaluación de criterios ───────────────────────────────────
    if [ $N50 -ge 500000 ] && \
       [ $COMPLETITUD -ge 95 ] && \
       [ $CONTAMINACION -le 5 ]
    then
        ESTADO="✅ APROBADO"
        APROBADOS=$((APROBADOS + 1))
        echo "$MUESTRA	$FASTA" >> "$PROYECTO/muestras_aprobadas.tsv"
    else
        ESTADO="❌ RECHAZADO"
        RECHAZADOS=$((RECHAZADOS + 1))
        [ $N50 -lt 500000 ]    && echo "   ⚠️  N50 bajo (< 500 Kbp)"
        [ $COMPLETITUD -lt 95 ] && echo "   ⚠️  Completitud insuficiente (< 95%)"
        [ $CONTAMINACION -gt 5 ] && echo "   ⚠️  Contaminación elevada (> 5%)"
    fi

    echo "   $ESTADO"
    echo -e "$MUESTRA\t$NUM_CONTIGS\t${N50_KB}K\t${COMPLETITUD}%\t${CONTAMINACION}%\t$ESTADO" \
        >> "$REPORTE_GLOBAL"
    echo ""

done < "$PROYECTO/muestras_pulidas.tsv"

echo "════════════════════════════════════════════════════════════"
echo "  Ensamblajes aprobados : $APROBADOS ✅"
echo "  Ensamblajes rechazados: $RECHAZADOS ❌"
echo "  Reporte global        : $REPORTE_GLOBAL"
echo "  Siguiente paso        : bash 06_anotar.sh $PROYECTO"
```

---

## 🏷️ 10. Paso 6 — Anotación con Prokka

### ¿Qué hace Prokka?

**Prokka** identifica y anota todos los genes del genoma ensamblado: genes codificantes de proteínas, ARNs ribosomales, ARNs de transferencia y otros elementos genéticos.

```bash
#!/bin/bash
# 06_anotar.sh
# Anota los genomas aprobados con Prokka
# Uso: bash 06_anotar.sh <directorio_proyecto>

source config_pipeline.sh
PROYECTO="$1"

echo "╔════════════════════════════════════════════════════════════╗"
echo "║    PASO 6: ANOTACIÓN GENÓMICA (Prokka)                   ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

if [ ! -f "$PROYECTO/muestras_aprobadas.tsv" ]
then
    echo "❌ No hay muestras aprobadas. Verifica el paso 05."
    exit 1
fi

TOTAL=$(wc -l < "$PROYECTO/muestras_aprobadas.tsv")
echo "Genomas a anotar: $TOTAL"
echo ""

ANOTADAS=0

while IFS=$'\t' read -r MUESTRA FASTA
do
    DIR_ANOT="$PROYECTO/$DIR_ANOTACION/$MUESTRA"
    mkdir -p "$DIR_ANOT"

    echo "── Anotando: $MUESTRA ────────────────────────────────────"

    # ── COMANDO REAL DE PROKKA ────────────────────────────────────
    # prokka \
    #     --outdir "$DIR_ANOT" \
    #     --prefix "$MUESTRA" \
    #     --kingdom Bacteria \
    #     --cpus $THREADS \
    #     --centre UPC \
    #     --compliant \
    #     "$FASTA" \
    #     > "$DIR_ANOT/prokka.log" 2>&1
    # CODIGO=$?
    # ─────────────────────────────────────────────────────────────

    # Simular salida de Prokka
    GENES=$((RANDOM % 500 + 3800))
    CDSS=$((GENES - 100))
    TRNAS=$((RANDOM % 10 + 60))
    RRNAS=3
    CODIGO=0

    if [ $CODIGO -eq 0 ]
    then
        # Simular archivos de salida de Prokka
        echo "LOCUS	$MUESTRA" > "$DIR_ANOT/${MUESTRA}.gbk"
        echo "##gff-version 3" > "$DIR_ANOT/${MUESTRA}.gff"
        cp "$FASTA" "$DIR_ANOT/${MUESTRA}.fna"

        echo "   ✅ Anotación completada"
        echo "   🧬 CDS (genes codificantes) : $CDSS"
        echo "   🔬 tRNA                     : $TRNAS"
        echo "   🔵 rRNA                     : $RRNAS"
        echo "   📁 Archivos: .gff / .gbk / .fna / .faa"

        ANOTADAS=$((ANOTADAS + 1))
        echo "$MUESTRA	$DIR_ANOT	$CDSS	$TRNAS" \
            >> "$PROYECTO/muestras_anotadas.tsv"
    else
        echo "   ❌ Error en la anotación"
    fi
    echo ""

done < "$PROYECTO/muestras_aprobadas.tsv"

echo "════════════════════════════════════════════════════════════"
echo "  Genomas anotados: $ANOTADAS ✅"
echo "  Siguiente paso  : bash 07_reporte_final.sh $PROYECTO"
```

---

## 📋 11. Paso Final — Reporte Integrado del Proyecto

El pipeline cierra con un reporte que consolida todas las métricas de cada muestra, integrando variables de entorno, expansión de comandos, aritmética y manejo de archivos.

```bash
#!/bin/bash
# 07_reporte_final.sh
# Genera el reporte integrado del proyecto de ensamblaje
# Uso: bash 07_reporte_final.sh <directorio_proyecto>

source config_pipeline.sh
PROYECTO="$1"
FECHA=$(date +"%Y-%m-%d")
HORA=$(date +"%H:%M:%S")
USUARIO=$(whoami)
MAQUINA=$(hostname)
REPORTE="$PROYECTO/$DIR_REPORTES/reporte_final_${PROYECTO}_${FECHA}.txt"

mkdir -p "$PROYECTO/$DIR_REPORTES"

cat > "$REPORTE" << EOF
══════════════════════════════════════════════════════════════════════
  REPORTE FINAL — ENSAMBLAJE DE GENOMAS BACTERIANOS NANOPORE
  Proyecto  : $PROYECTO
  Generado  : $FECHA $HORA
  Usuario   : $USUARIO @ $MAQUINA
══════════════════════════════════════════════════════════════════════

PARÁMETROS DEL PIPELINE
──────────────────────────────────────────────────────────────────────
  Tamaño de genoma esperado : $GENOMA_SIZE
  Cobertura mínima          : ${COBERTURA_MIN}x
  Q-score mínimo            : Q$CALIDAD_MIN
  Longitud mínima de lectura: $LONGITUD_MIN bp
  Threads utilizados        : $THREADS

RESUMEN POR ETAPA
──────────────────────────────────────────────────────────────────────
EOF

# Contadores por etapa
TOTAL_INICIAL=$(wc -l < "$PROYECTO/muestras.tsv" 2>/dev/null || echo 0)
TOTAL_QC=$(grep -c "APROBADA" "$PROYECTO/muestras_qc.tsv" 2>/dev/null || echo 0)
TOTAL_ENSAMBLADAS=$(wc -l < "$PROYECTO/muestras_ensambladas.tsv" 2>/dev/null || echo 0)
TOTAL_APROBADAS=$(wc -l < "$PROYECTO/muestras_aprobadas.tsv" 2>/dev/null || echo 0)
TOTAL_ANOTADAS=$(wc -l < "$PROYECTO/muestras_anotadas.tsv" 2>/dev/null || echo 0)

cat >> "$REPORTE" << EOF
  Paso 0 — Muestras iniciales        : $TOTAL_INICIAL
  Paso 1 — Aprobadas en QC lecturas  : $TOTAL_QC
  Paso 3 — Ensamblajes completados   : $TOTAL_ENSAMBLADAS
  Paso 5 — Aprobadas en QC ensamblaje: $TOTAL_APROBADAS
  Paso 6 — Genomas anotados          : $TOTAL_ANOTADAS

RESULTADOS POR MUESTRA
──────────────────────────────────────────────────────────────────────
EOF

# Tabla de QC de ensamblajes
if [ -f "$PROYECTO/$DIR_QC_ASM/reporte_qc_ensamblajes.tsv" ]
then
    cat "$PROYECTO/$DIR_QC_ASM/reporte_qc_ensamblajes.tsv" >> "$REPORTE"
fi

cat >> "$REPORTE" << EOF

ARCHIVOS FINALES (Genomas anotados)
──────────────────────────────────────────────────────────────────────
EOF

if [ -f "$PROYECTO/muestras_anotadas.tsv" ]
then
    while IFS=$'\t' read -r MUESTRA DIR_ANOT CDSS TRNAS
    do
        echo "  $MUESTRA" >> "$REPORTE"
        echo "    → GFF  : $DIR_ANOT/${MUESTRA}.gff" >> "$REPORTE"
        echo "    → GBK  : $DIR_ANOT/${MUESTRA}.gbk" >> "$REPORTE"
        echo "    → FASTA: $DIR_ANOT/${MUESTRA}.fna" >> "$REPORTE"
        echo "    → CDS  : $CDSS genes | tRNA: $TRNAS" >> "$REPORTE"
        echo "" >> "$REPORTE"
    done < "$PROYECTO/muestras_anotadas.tsv"
fi

echo "══════════════════════════════════════════════════════════════════════" >> "$REPORTE"
echo "  FIN DEL REPORTE" >> "$REPORTE"
echo "══════════════════════════════════════════════════════════════════════" >> "$REPORTE"

# Mostrar reporte en pantalla
cat "$REPORTE"
echo ""
echo "📄 Reporte guardado en: $REPORTE"
```

---

## 🚀 12. El Pipeline Completo — Un Solo Comando

La integración final: un script maestro que ejecuta todos los pasos en secuencia, verificando el éxito de cada uno antes de continuar.

```bash
#!/bin/bash
# pipeline_nanopore_completo.sh
# PIPELINE MAESTRO — Ensamblaje de Genomas Bacterianos Nanopore
#
# Uso  : bash pipeline_nanopore_completo.sh <proyecto> <dir_fastq>
# Ejm  : bash pipeline_nanopore_completo.sh MRSA_2026 /datos/corrida_01
#
# Integra: S09 (scripts) + S10 (strings) + S11 (for/if) +
#          S12 (variables/$?) + S13 (arrays/batch)

PROYECTO="$1"
DIR_FASTQ="$2"
LOG_MASTER="${PROYECTO}_pipeline.log"

# ── Función para ejecutar cada paso ──────────────────────────────
ejecutar_paso() {
    local NUMERO="$1"
    local NOMBRE="$2"
    local SCRIPT="$3"
    local ARGS="${@:4}"

    echo ""
    echo "══════════════════════════════════════════════════"
    echo "  PASO $NUMERO: $NOMBRE"
    echo "  Inicio: $(date +'%H:%M:%S')"
    echo "══════════════════════════════════════════════════"

    bash "$SCRIPT" $ARGS 2>&1 | tee -a "$LOG_MASTER"
    local CODIGO=$?

    if [ $CODIGO -ne 0 ]
    then
        echo ""
        echo "❌ PIPELINE INTERRUMPIDO en Paso $NUMERO: $NOMBRE"
        echo "   Código de error: $CODIGO"
        echo "   Revisa el log: $LOG_MASTER"
        exit $CODIGO
    fi

    echo "  ✅ Paso $NUMERO completado."
    return 0
}

# ── Inicio del pipeline maestro ───────────────────────────────────
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║    🧬 PIPELINE NANOPORE — ENSAMBLAJE BACTERIANO             ║"
echo "║    Proyecto : $PROYECTO"
echo "║    Inicio   : $(date +'%Y-%m-%d %H:%M:%S')"
echo "║    PID      : $$"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

HORA_INICIO=$(date +%s)

ejecutar_paso 0 "Inicialización y validación"    "00_inicializar_proyecto.sh"  "$PROYECTO" "$DIR_FASTQ"
ejecutar_paso 1 "Control de calidad de lecturas" "01_control_calidad.sh"       "$PROYECTO"
ejecutar_paso 2 "Filtrado de lecturas (Filtlong)" "02_filtrar.sh"              "$PROYECTO"
ejecutar_paso 3 "Ensamblaje (Flye)"              "03_ensamblar.sh"             "$PROYECTO"
ejecutar_paso 4 "Pulido (Medaka)"                "04_pulir.sh"                 "$PROYECTO"
ejecutar_paso 5 "QC del ensamblaje (QUAST+CheckM)" "05_qc_ensamblaje.sh"     "$PROYECTO"
ejecutar_paso 6 "Anotación (Prokka)"             "06_anotar.sh"                "$PROYECTO"
ejecutar_paso 7 "Reporte final"                  "07_reporte_final.sh"         "$PROYECTO"

HORA_FIN=$(date +%s)
DURACION_MIN=$(( (HORA_FIN - HORA_INICIO) / 60 ))
DURACION_SEG=$(( (HORA_FIN - HORA_INICIO) % 60 ))

echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║    ✅ PIPELINE COMPLETADO EXITOSAMENTE                      ║"
echo "║    Tiempo total: ${DURACION_MIN}m ${DURACION_SEG}s"
echo "║    Log completo: $LOG_MASTER"
echo "╚══════════════════════════════════════════════════════════════╝"
```

---

## 📸 13. Actividad Asincrónica

### 🎯 Misión: Construir tu propio módulo del pipeline

Elige **uno de los tres módulos** y desarróllalo completamente. El script debe poder ejecutarse de forma independiente y también ser llamado por el pipeline maestro.

---

#### 🧬 Módulo A: `mi_qc_lector.sh` *(Obligatorio — elige uno)*

**Objetivo:** Script que recibe un directorio con archivos `.fastq.gz` y genera un reporte de calidad para cada uno, clasificando las muestras como aptas o no aptas.

**Requisitos:**
- Aceptar el directorio como `$1`; validar con `$#` y `-d`
- Usar `source config_pipeline.sh` para los umbrales
- Array para almacenar los nombres de las muestras aprobadas
- Bucle `for` que procese todos los `.fastq.gz` del directorio
- `if/elif` para clasificar: APTA / COBERTURA BAJA / CALIDAD BAJA
- `$?` para verificar cada operación
- Generar archivo `resumen_qc.tsv` con columnas: Muestra, Lecturas, Bases, Cobertura, Estado
- Mostrar al final cuántas aprobaron y cuántas no

---

#### 🏗️ Módulo B: `mi_ensamblador.sh` *(Obligatorio — elige uno)*

**Objetivo:** Script que recibe una tabla de muestras y ensambla cada una con Flye (simulado), generando métricas post-ensamblaje.

**Requisitos:**
- Leer la tabla de entrada con `while IFS read`
- Variable de entorno `export FLYE_PARAMS` con los parámetros de Flye
- Bucle C-style `for ((i=0; i<N; i++))` para mostrar barra de progreso
- Crear el directorio de salida con `mkdir -p`
- Calcular N50 simulado con aritmética `$(( ))`
- Verificar cada ensamblaje con `-f` y `-s`
- Guardar log con `tee`: mostrar en pantalla Y guardar en archivo
- Usar `$$` en el nombre del archivo de log temporal

---

#### 📊 Módulo C: `mi_reporte.sh` *(Obligatorio — elige uno)*

**Objetivo:** Script que lee todas las tablas generadas por el pipeline (`muestras_qc.tsv`, `muestras_ensambladas.tsv`, `muestras_aprobadas.tsv`) y genera un reporte HTML simple con los resultados.

**Requisitos:**
- Leer las tres tablas con `while read`
- Calcular estadísticas globales: total, tasa de éxito (con `bc` para decimal), promedio de contigs
- Usar here-doc `<< EOF` para generar el HTML
- Incrustar la fecha con `$(date)` y el usuario con `$(whoami)`
- Guardar en `reporte_${PROYECTO}_$(date +%Y%m%d).html`
- Mostrar resumen en pantalla al terminar

---

### ✅ Checklist de Entrega

Antes de subir a GitHub, verifica:

- [ ] Tu módulo está en la carpeta `Sesion_14/` del repositorio
- [ ] El script tiene `#!/bin/bash` y cabecera con nombre, fecha y descripción
- [ ] Tiene `source config_pipeline.sh` al inicio
- [ ] Valida argumentos con `$#` y muestra mensaje de uso
- [ ] Usa al menos: una variable con `export`, un array, un bucle `for`, un `if`, y `$?`
- [ ] Tiene permisos de ejecución (`chmod +x`)
- [ ] Se ejecuta sin errores con `bash -n mi_modulo.sh` (verifica sintaxis)
- [ ] Incluiste captura de pantalla de la ejecución
- [ ] Subiste con commit: `git commit -m "Sesion 14: modulo pipeline Nanopore"`

---

## 🗂️ Resumen: Shell Scripting → Pipeline Nanopore

| Concepto aprendido | Sesión | Aplicación en el pipeline Nanopore |
|-------------------|--------|-------------------------------------|
| Shebang, comentarios, `echo` | S09 | Cabecera y mensajes de todos los scripts |
| `read`, `${#}`, `${//}`, subcadenas | S10 | Extraer nombres de muestra, prefijos de archivos |
| `for`, `while`, `if/elif/else` | S11 | Iterar sobre muestras, decidir si una pasa el QC |
| `export`, `PATH`, `$?`, `$$`, `$1` | S12 | Config centralizado, verificar éxito, logs únicos |
| Arrays, `for` lista, `for` C-style | S13 | Procesar lotes de muestras, barra de progreso |
| `>`, `>>`, `2>`, `\|`, `tee` | S04 | Redirigir logs, capturar errores, ver y guardar |

---

## 📚 Referencias Bibliográficas

1. Blum, R., & Bresnahan, C. (2021). *Linux Command Line and Shell Scripting Bible* (4th ed.). Wiley. Capítulos 11–15.

2. Kolmogorov, M. et al. (2019). Assembly of long error-prone reads using repeat graphs. *Nature Biotechnology*, 37(5), 540–546.  
   [https://doi.org/10.1038/s41587-019-0072-8](https://doi.org/10.1038/s41587-019-0072-8)

3. Seemann, T. (2014). Prokka: rapid prokaryotic genome annotation. *Bioinformatics*, 30(14), 2068–2069.  
   [https://doi.org/10.1093/bioinformatics/btu153](https://doi.org/10.1093/bioinformatics/btu153)

4. Oxford Nanopore Technologies — Documentación oficial:  
   [https://nanoporetech.com/document/genomic-dna-by-ligation](https://nanoporetech.com/document/genomic-dna-by-ligation)

5. Wick, R. R. et al. (2021). Trycycler: consensus long-read assemblies for bacterial genomes. *Genome Biology*, 22(1), 266.  
   [https://doi.org/10.1186/s13059-021-02483-z](https://doi.org/10.1186/s13059-021-02483-z)

6. Documentación de Flye: [https://github.com/mikolmogorov/Flye](https://github.com/mikolmogorov/Flye)

7. Documentación de Medaka: [https://github.com/nanoporetech/medaka](https://github.com/nanoporetech/medaka)

8. Documentación de QUAST: [https://quast.sourceforge.net/docs/manual.html](https://quast.sourceforge.net/docs/manual.html)

---

> 🎓 *"Un pipeline no es solo una colección de comandos — es un protocolo computacional reproducible. Cuando publiques el genoma de una nueva cepa resistente de Klebsiella pneumoniae, los revisores pedirán exactamente esto: los scripts que usaste, los parámetros que configuraste y las métricas de calidad que obtuviste. Lo que aprendiste en este curso es la base de esa ciencia reproducible."*

---

*Documento preparado para la Sesión 12 - Semana 14 del curso Principios de Programación en Bioinformática. UPC exígete, innova.*
