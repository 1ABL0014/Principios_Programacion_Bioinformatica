# 🧬 Sesión 12: Scripts para bioinformática I
## Variables, Shell y Operaciones

**Docentes:** Frank Guzmán Escudero, Manuel Ramírez Sáenz  
**Universidad:** UPC - Facultad de Ciencias de la Salud - Programa de Biología  
**Horario:** 1:00 pm - 5:00 pm (Descanso: 2:45 pm - 3:00 pm)

---

## 🎯 Logro de la Sesión

Al finalizar esta sesión práctica, el estudiante:
- Definirá y utilizará variables en shell scripting con sintaxis correcta
- Diferenciará entre variables locales y globales (entorno)
- Comprenderá el modelo de shell y subshell y cómo afecta a las variables
- Manipulará la variable de entorno `PATH` para agregar herramientas bioinformáticas
- Aplicará variables especiales (`$0`, `$1`, `$#`, `$?`, `$$`) en scripts reales
- Realizará operaciones aritméticas y expansión de comandos dentro de scripts

**Palabras clave:** Variables, Shell, Subshell, PATH, Expansión de comandos, Variables especiales, Aritmética en Bash

---

## 📋 Pre-requisitos

- Haber completado las Sesiones 9, 10 y 11
- Saber crear y ejecutar scripts Bash (`chmod +x`, `./script.sh`)
- Conocer bucles `for`/`while` y estructuras `if/elif/else` (Sesión 11)
- Saber manipular cadenas con `${#var}`, `${var:n:m}` y `${var//x/y}` (Sesión 10)

---

## 🧠 1. Repaso Rápido

En las sesiones anteriores construiste las bases del scripting. Hoy conectaremos esas bases con el concepto de **variables con alcance controlado**. Recuerda lo esencial:

```bash
#!/bin/bash                         # Shebang (Sesión 9)

# Cadenas y lectura de usuario (Sesión 10)
read -p "Organismo: " organismo
arn=${adn//T/U}                     # Reemplazo de texto
longitud=${#adn}                    # Longitud de cadena

# Bucles y condicionales (Sesión 11)
for muestra in muestra1 muestra2
do
    if [ ${#muestra} -gt 5 ]; then
        echo "Nombre largo: $muestra"
    fi
done
```

Hoy agregaremos el **control del alcance** de esas variables, la **aritmética** y el uso de información del propio sistema operativo dentro de nuestros scripts.

---

## 📦 2. Variables: Conceptos Fundamentales

### ¿Qué es una variable?

Una **variable** es una ubicación en memoria con un nombre, donde se guarda un valor que puede ser consultado o modificado en cualquier momento del script.

**Analogía:** Una variable es como un tubo de microcentrífuga etiquetado: el nombre de la etiqueta es el nombre de la variable y lo que hay dentro es su valor.

```
  ┌─────────────────┐
  │ MUESTRA = "K12" │   ← el nombre es MUESTRA, el valor es "K12"
  └─────────────────┘
```

### Sintaxis básica

```bash
nombre_variable=valor      # Asignar un valor
echo $nombre_variable      # Leer el valor
echo ${nombre_variable}    # Leer el valor (con llaves — más explícito)
```

> ⚠️ **Regla crítica:** Nunca pongas espacios alrededor del `=`. El shell los interpretaría como argumentos de un comando y daría error.

```bash
# ✅ CORRECTO
PROYECTO="Analisis_RNA"
NUM_MUESTRAS=50

# ❌ INCORRECTO — generará error
PROYECTO = "Analisis_RNA"
NUM_MUESTRAS = 50
```

### Nombres de variables: convenciones

| Regla | Ejemplo correcto | Ejemplo incorrecto |
|-------|-----------------|-------------------|
| Solo letras, números y `_` | `NUM_MUESTRAS` | `num-muestras` |
| No puede empezar con número | `CEPA_1` | `1_CEPA` |
| Por convención: MAYÚSCULAS | `RUTA_DATOS` | `ruta_datos` |
| Nombres descriptivos | `ARCHIVO_ENTRADA` | `a` |

### Las dos formas de leer una variable

```bash
ARCHIVO="genoma"

echo $ARCHIVO            # Forma simple — la más común
echo ${ARCHIVO}          # Con llaves — necesario cuando sigue texto pegado

echo $ARCHIVOv1.fasta    # ❌ busca la variable $ARCHIVOv1 (no existe)
echo ${ARCHIVO}v1.fasta  # ✅ imprime: genomav1.fasta
```

### 🔬 Pruébalo en tu terminal:

```bash
ORGANISMO="Escherichia coli"
CEPA="K-12"
AÑO=2024

echo "Organismo: $ORGANISMO"
echo "Cepa: $CEPA"
echo "Año: $AÑO"
echo "ID completo: ${ORGANISMO}_${CEPA}_${AÑO}"
```

**Salida esperada:**
```
Organismo: Escherichia coli
Cepa: K-12
Año: 2024
ID completo: Escherichia coli_K-12_2024
```

---

## 🌍 3. Variables Locales vs Variables Globales

### Variables locales

Una **variable local** existe solo dentro del script o sesión donde fue creada. No se hereda a procesos hijos.

```bash
#!/bin/bash
# Script: ejemplo_local.sh
MUESTRA="bacteria_001"
echo "Dentro del script: $MUESTRA"
```

```bash
bash ejemplo_local.sh
# Output: Dentro del script: bacteria_001

echo $MUESTRA
# Output: (vacío — la variable no existe fuera del script)
```

### Variables globales (de entorno)

Una **variable global** se exporta al entorno y cualquier subproceso que se lance desde ese shell puede leerla.

```bash
#!/bin/bash
export LABORATORIO="Genómica Computacional"
echo "Laboratorio: $LABORATORIO"
bash -c 'echo "En subshell: $LABORATORIO"'
```

```bash
source ejemplo_global.sh
# Output: Laboratorio: Genómica Computacional
# Output: En subshell: Genómica Computacional

echo $LABORATORIO
# Output: Genómica Computacional  (persiste en la sesión)
```

### 🔬 Pruébalo en tu terminal — diferencia crítica:

```bash
# Variable local
SECUENCIA_LOCAL="ATCG"
bash -c 'echo "Local en subshell: $SECUENCIA_LOCAL"'    # → vacío

# Variable global
export SECUENCIA_GLOBAL="GCTA"
bash -c 'echo "Global en subshell: $SECUENCIA_GLOBAL"'  # → GCTA
```

**Salida esperada:**
```
Local en subshell: 
Global en subshell: GCTA
```

### Tabla comparativa

| Aspecto | Local | Global (`export`) |
|---------|-------|-------------------|
| Sintaxis | `variable=valor` | `export variable=valor` |
| Visible en el script actual | ✅ Sí | ✅ Sí |
| Heredada a subshells | ❌ No | ✅ Sí |
| Persiste al cerrar el script | ❌ No | ✅ Sí (en la sesión) |
| Caso de uso típico | Valores temporales internos | Configuraciones de herramientas |
| Ejemplo bioinformático | Nombre de archivo temporal | Ruta de instalación de BWA |

### 🧪 Ejercicio 1 — Diferencia entre local y global:

Crea el archivo `ejercicio1_scope.sh` y ejecútalo:

```bash
#!/bin/bash
# ejercicio1_scope.sh
# Demuestra el alcance de variables locales y globales

ESPECIE_LOCAL="Salmonella enterica"
export ESPECIE_GLOBAL="Mycobacterium tuberculosis"

echo "=== EN EL SCRIPT PRINCIPAL ==="
echo "Local  : $ESPECIE_LOCAL"
echo "Global : $ESPECIE_GLOBAL"
echo ""

echo "=== EN UN SUBSHELL ==="
bash -c '
echo "Local  : $ESPECIE_LOCAL"
echo "Global : $ESPECIE_GLOBAL"
'
```

**Salida esperada:**
```
=== EN EL SCRIPT PRINCIPAL ===
Local  : Salmonella enterica
Global : Mycobacterium tuberculosis

=== EN UN SUBSHELL ===
Local  : 
Global : Mycobacterium tuberculosis
```

---

## 🐚 4. Shell vs Subshell

### ¿Qué ocurre cuando ejecutas un script?

Cuando abres una terminal, trabajas en un **shell padre**. Al ejecutar un script con `bash script.sh`, Linux crea un **proceso hijo (subshell)** con su propia memoria. Los cambios en el hijo no afectan al padre.

```
TERMINAL (shell padre)
│   PROYECTO="GenomicaUPC"
│   export DB_PATH="/data/refs"
│
├─► bash analisis.sh  (subshell)
│       PROYECTO="GenomicaUPC"    ← heredada (export)
│       DB_PATH="/data/refs"      ← heredada (export)
│       TEMP="valor_temp"         ← nueva, NO sube al padre
│       [script termina]
│
└── echo $TEMP    # → vacío (el subshell ya no existe)
```

### Modificaciones en subshell NO afectan al padre

```bash
#!/bin/bash
# Script: modificacion.sh
export CEPA="MG1655"

echo "Antes   - Padre: $CEPA"
bash -c 'export CEPA="DH5alpha"; echo "Subshell: $CEPA"'
echo "Después - Padre: $CEPA"
```

```bash
bash modificacion.sh
# Output:
# Antes   - Padre: MG1655
# Subshell: DH5alpha
# Después - Padre: MG1655   ← NO cambió
```

> 💡 Este comportamiento es una **característica de seguridad**, no un error. Garantiza que un script no pueda corromper el entorno del usuario que lo lanzó.

### Comandos importantes para gestionar shells

| Comando | Descripción | Ejemplo |
|---------|-------------|---------|
| `bash` | Abre un nuevo subshell interactivo | `bash` |
| `bash script.sh` | Ejecuta script en subshell | `bash analisis.sh` |
| `source script.sh` | Ejecuta en el shell actual (hereda cambios) | `source config.sh` |
| `exit` | Sale del subshell actual | `exit` |
| `$$` | PID del proceso actual | `echo $$` |
| `$PPID` | PID del proceso padre | `echo $PPID` |

### 🔬 Pruébalo en tu terminal — diferencia entre `bash` y `source`:

```bash
# Crea un script que defina una variable
echo 'export DATOS_REF="/home/usuario/referencias"' > config_proyecto.sh

# Ejecutar con bash → la variable NO llega al terminal actual
bash config_proyecto.sh
echo $DATOS_REF    # → vacío

# Ejecutar con source → la variable SÍ llega al terminal actual
source config_proyecto.sh
echo $DATOS_REF    # → /home/usuario/referencias
```

**Salida esperada:**
```
                                    ← vacío (bash)
/home/usuario/referencias           ← source funciona
```

> 💡 `source` (o su equivalente `.`) es el mecanismo que usan las herramientas bioinformáticas para "activarse". Por ejemplo: `source activate mi_entorno_conda`.

---

## 🌐 5. Variables de Entorno del Sistema

### ¿Qué son?

Son variables **predefinidas por el sistema** que contienen información esencial sobre la sesión del usuario. Siempre están disponibles, en cualquier script.

### Variables del sistema más importantes

| Variable | Qué contiene | Ejemplo de valor |
|----------|-------------|-----------------|
| `$HOME` | Directorio personal del usuario | `/home/estudiante` |
| `$USER` | Nombre del usuario actual | `mramirez` |
| `$SHELL` | Shell por defecto | `/bin/bash` |
| `$PWD` | Directorio de trabajo actual | `/home/estudiante/proyecto` |
| `$PATH` | Rutas donde el sistema busca ejecutables | `/usr/local/bin:/usr/bin:/bin` |
| `$HOSTNAME` | Nombre de la máquina | `cloudshell-vm` |
| `$LANG` | Idioma del sistema | `es_PE.UTF-8` |
| `$$` | PID del proceso actual | `14523` |

### Visualizar variables de entorno

```bash
# Ver una variable específica
echo $HOME
echo $USER

# Ver todas las variables exportadas
printenv

# Buscar variables relacionadas con un tema
env | grep -i path
env | grep -i home
```

### 🧪 Ejercicio 2 — Informe del entorno del sistema:

Crea `ejercicio2_entorno.sh` y ejecútalo:

```bash
#!/bin/bash
# ejercicio2_entorno.sh
# Genera un informe del entorno del sistema usando variables predefinidas

echo "╔══════════════════════════════════════════╗"
echo "║      INFORME DEL ENTORNO DEL SISTEMA     ║"
echo "╚══════════════════════════════════════════╝"
echo ""
echo "👤 Usuario         : $USER"
echo "🖥️  Máquina         : $HOSTNAME"
echo "🐚 Shell           : $SHELL"
echo "📂 Directorio HOME : $HOME"
echo "📍 Directorio actual: $PWD"
echo "🌐 Idioma          : $LANG"
echo "🔢 PID del script  : $$"
echo ""
echo "📌 Rutas en PATH:"
echo "$PATH" | tr ':' '\n' | while read ruta
do
    echo "   → $ruta"
done
```

**Salida esperada:**
```
╔══════════════════════════════════════════╗
║      INFORME DEL ENTORNO DEL SISTEMA     ║
╚══════════════════════════════════════════╝

👤 Usuario         : estudiante
🖥️  Máquina         : cloudshell-vm
🐚 Shell           : /bin/bash
📂 Directorio HOME : /home/estudiante
📍 Directorio actual: /home/estudiante
🌐 Idioma          : es_PE.UTF-8
🔢 PID del script  : 14523

📌 Rutas en PATH:
   → /usr/local/bin
   → /usr/bin
   → /bin
   ...
```

---

## 🛤️ 6. La Variable PATH

### ¿Qué es PATH?

`PATH` es la lista de directorios donde el sistema busca un programa cuando escribes su nombre. Si tu herramienta no está en ninguno de esos directorios, el shell responde con `command not found`.

```
Escribes: fastqc

Shell busca fastqc en:
  /usr/local/bin   ← no está
  /usr/bin         ← no está
  /bin             ← no está
  ~/biotools/FastQC ← ✅ ENCONTRADO → ejecuta
```

### Ver el PATH actual

```bash
# Compacto
echo $PATH

# Legible (un directorio por línea)
echo $PATH | tr ':' '\n'
```

### Agregar una ruta al PATH

```bash
# Agregar al final (prioridad baja)
export PATH=$PATH:/ruta/nueva

# Agregar al inicio (prioridad alta — se busca primero)
export PATH=/ruta/nueva:$PATH
```

### Hacer el PATH permanente

Los cambios con `export` duran solo hasta cerrar la terminal. Para que persistan:

```bash
nano ~/.bashrc

# Agregar al final del archivo:
export PATH=$PATH:~/biotools/FastQC
export PATH=$PATH:~/biotools/samtools/bin
export PATH=$PATH:~/biotools/bwa

# Guardar (Ctrl+O, Enter, Ctrl+X) y recargar:
source ~/.bashrc
```

### 🔬 Pruébalo en tu terminal — simulación de instalación:

```bash
# Crear un directorio de herramientas
mkdir -p ~/mis_biotools/bin

# Crear un "programa" ficticio
echo '#!/bin/bash
echo "MiBioTool v1.0 — Herramienta bioinformática"
echo "Analizando: $@"' > ~/mis_biotools/bin/mibiotool

chmod +x ~/mis_biotools/bin/mibiotool

# Intentar ejecutarlo sin PATH actualizado
mibiotool genoma.fasta   # → command not found

# Agregar al PATH
export PATH=$PATH:~/mis_biotools/bin

# Ahora sí funciona
mibiotool genoma.fasta
```

**Salida esperada:**
```
-bash: mibiotool: command not found
MiBioTool v1.0 — Herramienta bioinformática
Analizando: genoma.fasta
```

### 🧪 Ejercicio 3 — Configurador de PATH para proyecto:

```bash
#!/bin/bash
# ejercicio3_path.sh
# Configura el PATH para un proyecto bioinformático

PROYECTO="analisis_rnaseq"
BIOTOOLS_DIR="$HOME/biotools"

echo "=== CONFIGURACIÓN DE PATH PARA: $PROYECTO ==="
echo ""
echo "PATH original (${PATH//:/  |  })..."
echo ""

# Agregar directorios de herramientas
export PATH=$PATH:$BIOTOOLS_DIR/FastQC
export PATH=$PATH:$BIOTOOLS_DIR/STAR/bin/Linux_x86_64
export PATH=$PATH:$BIOTOOLS_DIR/samtools/bin

echo "Directorios agregados al PATH:"
echo "  ✅ $BIOTOOLS_DIR/FastQC"
echo "  ✅ $BIOTOOLS_DIR/STAR/bin/Linux_x86_64"
echo "  ✅ $BIOTOOLS_DIR/samtools/bin"
echo ""
echo "PATH actualizado:"
echo "$PATH" | tr ':' '\n' | grep "biotools"
```

---

## ⚙️ 7. Operaciones con Variables: Comillas

Las comillas controlan **qué interpreta el shell** y qué trata como texto literal.

### Comillas dobles `" "` — permiten expansión

```bash
ORGANISMO="E. coli"
echo "Procesando: $ORGANISMO"       # → Procesando: E. coli
echo "Fecha: $(date +%Y-%m-%d)"    # → Fecha: 2026-06-14
echo "Directorio: $PWD"            # → Directorio: /home/usuario
```

### Comillas simples `' '` — texto literal, sin expansión

```bash
ORGANISMO="E. coli"
echo 'Procesando: $ORGANISMO'      # → Procesando: $ORGANISMO (literal)
echo 'Fecha: $(date)'              # → Fecha: $(date) (literal)
```

### Sin comillas — funciona pero riesgoso con espacios

```bash
RUTA="/home/mi usuario/datos"      # Tiene un espacio
mkdir $RUTA    # ❌ crea TWO directorios: /home/mi  y  usuario/datos
mkdir "$RUTA"  # ✅ crea UN directorio con el nombre completo
```

> ⚠️ **Regla de oro:** Siempre pon variables entre comillas dobles: `"$VARIABLE"`. Te evitará errores difíciles de encontrar cuando los valores contienen espacios (nombres de organismos, rutas, etc.).

### 🔬 Pruébalo en tu terminal — comparación de comillas:

```bash
#!/bin/bash
ARCHIVO="genoma_k12.fasta"
RUTA="/datos/referencias"

echo ""
echo "=== COMILLAS DOBLES ==="
echo "Archivo : $ARCHIVO"
echo "Ruta    : $RUTA"

echo ""
echo "=== COMILLAS SIMPLES ==="
echo 'Archivo : $ARCHIVO'
echo 'Ruta    : $RUTA'
```

**Salida esperada:**
```
=== COMILLAS DOBLES ===
Archivo : genoma_k12.fasta
Ruta    : /datos/referencias

=== COMILLAS SIMPLES ===
Archivo : $ARCHIVO
Ruta    : $RUTA
```

---

## 🔢 8. Operaciones Aritméticas

Bash solo trabaja con **enteros** de forma nativa. Para decimales se usa la herramienta `bc`.

### Método 1: `$(( ))` — recomendado

```bash
suma=$((13 + 8))             # → 21
resta=$((50 - 15))           # → 35
multiplicacion=$((4 * 25))   # → 100
division=$((100 / 4))        # → 25
modulo=$((17 % 5))           # → 2 (resto de la división)
potencia=$((2 ** 10))        # → 1024
```

### Método 2: `bc` — para decimales

```bash
# Decimales con 2 cifras
promedio=$(echo "scale=2; (85 + 90 + 78) / 3" | bc)
echo "Promedio: $promedio"    # → Promedio: 84.33

# Porcentaje
porcentaje=$(echo "scale=1; 347 * 100 / 1500" | bc)
echo "Porcentaje: $porcentaje%"   # → Porcentaje: 23.1%
```

### 🧪 Ejercicio 4 — Calculadora genómica:

```bash
#!/bin/bash
# ejercicio4_aritmetica.sh
# Calcula estadísticas básicas de un experimento de secuenciación

echo "=== CALCULADORA DE SECUENCIACIÓN ==="
echo ""

# Variables del experimento
LECTURAS_TOTALES=15000000
LECTURAS_CALIDAD=13250000
TAMANIO_GENOMA_MB=4
COBERTURA_MIN=30

# Cálculo de lecturas descartadas
LECTURAS_DESCARTADAS=$((LECTURAS_TOTALES - LECTURAS_CALIDAD))

# Porcentaje de calidad (entero)
PORCENTAJE_CALIDAD=$((LECTURAS_CALIDAD * 100 / LECTURAS_TOTALES))

# Cobertura estimada (cada lectura ~150 bp, genoma en bp)
TAMANIO_GENOMA_BP=$((TAMANIO_GENOMA_MB * 1000000))
COBERTURA=$((LECTURAS_CALIDAD * 150 / TAMANIO_GENOMA_BP))

echo "📊 RESULTADOS DEL ANÁLISIS DE CALIDAD"
echo "───────────────────────────────────────"
echo "  Lecturas totales     : $LECTURAS_TOTALES"
echo "  Lecturas con calidad : $LECTURAS_CALIDAD"
echo "  Lecturas descartadas : $LECTURAS_DESCARTADAS"
echo "  Retención de calidad : $PORCENTAJE_CALIDAD%"
echo ""
echo "📐 ESTIMACIÓN DE COBERTURA"
echo "───────────────────────────────────────"
echo "  Genoma objetivo      : $TAMANIO_GENOMA_MB Mb"
echo "  Cobertura estimada   : ${COBERTURA}x"
echo ""

if [ $COBERTURA -ge $COBERTURA_MIN ]
then
    echo "✅ Cobertura suficiente para análisis de variantes."
else
    echo "⚠️  Cobertura insuficiente. Mínimo requerido: ${COBERTURA_MIN}x"
fi
```

**Salida esperada:**
```
=== CALCULADORA DE SECUENCIACIÓN ===

📊 RESULTADOS DEL ANÁLISIS DE CALIDAD
───────────────────────────────────────
  Lecturas totales     : 15000000
  Lecturas con calidad : 13250000
  Lecturas descartadas : 1750000
  Retención de calidad : 88%

📐 ESTIMACIÓN DE COBERTURA
───────────────────────────────────────
  Genoma objetivo      : 4 Mb
  Cobertura estimada   : 496x

✅ Cobertura suficiente para análisis de variantes.
```

---

## 🔄 9. Expansión de Comandos

La **expansión de comandos** captura la salida de un comando y la guarda en una variable. Es uno de los mecanismos más usados en scripting bioinformático.

### Sintaxis moderna: `$(comando)` — recomendada

```bash
FECHA=$(date +"%Y-%m-%d")
USUARIO=$(whoami)
DIRECTORIO=$(pwd)
NUM_ARCHIVOS=$(ls -1 *.fasta 2>/dev/null | wc -l)
```

### Sintaxis clásica: `` `comando` `` (backticks) — menos recomendada

```bash
FECHA=`date +"%Y-%m-%d"`     # Funciona, pero difícil de anidar
```

> 💡 Prefiere siempre `$()` porque se puede anidar: `$(comando $(subcomando))`.

### 🔬 Pruébalo en tu terminal — información dinámica del proyecto:

```bash
#!/bin/bash
# info_proyecto.sh

PROYECTO="Pipeline_RNAseq"

echo "=== INFORMACIÓN DINÁMICA DEL PROYECTO ==="
echo ""
echo "Proyecto      : $PROYECTO"
echo "Fecha inicio  : $(date +"%Y-%m-%d")"
echo "Hora inicio   : $(date +"%H:%M:%S")"
echo "Usuario       : $(whoami)"
echo "Máquina       : $(hostname)"
echo "Kernel        : $(uname -r)"
echo "Directorio    : $(pwd)"
echo "Archivos FASTA: $(ls -1 *.fasta 2>/dev/null | wc -l) encontrados"
```

**Salida esperada:**
```
=== INFORMACIÓN DINÁMICA DEL PROYECTO ===

Proyecto      : Pipeline_RNAseq
Fecha inicio  : 2026-06-14
Hora inicio   : 13:05:47
Usuario       : mramirez
Máquina       : cloudshell-vm
Kernel        : 5.15.0-1058-gcp
Directorio    : /home/mramirez/proyectos
Archivos FASTA: 3 encontrados
```

---

## ⭐ 10. Variables Especiales del Script

Bash tiene variables predefinidas que contienen información sobre el script en ejecución, sus argumentos y el resultado de los comandos.

### Tabla de variables especiales

| Variable | Contenido | Ejemplo de uso |
|----------|-----------|----------------|
| `$0` | Nombre del script | `echo "Script: $0"` |
| `$1`, `$2`, `$3`... | Argumentos posicionales | `ARCHIVO=$1` |
| `$#` | Número total de argumentos | Validar que se pasaron args |
| `$@` | Todos los argumentos (lista) | `for arg in $@` |
| `$$` | PID del proceso actual | Crear archivos temporales únicos |
| `$?` | Código de salida del último comando | Verificar si falló |
| `$PPID` | PID del proceso padre | Debug de procesos |

### `$1, $2...` y `$#` — argumentos posicionales

Cuando ejecutas `bash script.sh arg1 arg2`, el script puede acceder a esos argumentos:

```bash
#!/bin/bash
# procesar_muestra.sh
echo "Script    : $0"
echo "Nº de args: $#"
echo "Arg 1     : $1"
echo "Arg 2     : $2"
echo "Todos     : $@"
```

```bash
bash procesar_muestra.sh ecoli_K12.fasta resultados/
# Output:
# Script    : procesar_muestra.sh
# Nº de args: 2
# Arg 1     : ecoli_K12.fasta
# Arg 2     : resultados/
# Todos     : ecoli_K12.fasta resultados/
```

### `$?` — código de salida

Todo comando en Linux termina con un código:
- `0` = éxito
- Cualquier otro número = error (el valor indica el tipo de error)

```bash
ls archivo_existente.fasta
echo "Código de salida: $?"     # → 0

ls archivo_inexistente.fasta
echo "Código de salida: $?"     # → 2
```

### `$$` — PID para archivos temporales únicos

```bash
#!/bin/bash
# Crear archivo temporal con nombre único (evita conflictos si el script corre en paralelo)
TEMP_FILE="/tmp/resultado_$$"
grep ">" mi_archivo.fasta > "$TEMP_FILE"
cat "$TEMP_FILE"
rm "$TEMP_FILE"    # Siempre limpiar los temporales
```

### 🧪 Ejercicio 5 — Script con validación de argumentos:

```bash
#!/bin/bash
# ejercicio5_argumentos.sh
# Demuestra el uso de variables especiales para validar entrada

echo "=== VALIDADOR DE ARGUMENTOS ==="
echo "Script: $(basename $0)"
echo "Argumentos recibidos: $#"
echo ""

# Verificar que se pase al menos un argumento
if [ $# -eq 0 ]
then
    echo "❌ ERROR: No ingresaste argumentos."
    echo "   Uso: bash $0 <organismo> <archivo.fasta>"
    echo "   Ejemplo: bash $0 ecoli genoma.fasta"
    exit 1
fi

if [ $# -lt 2 ]
then
    echo "⚠️  ADVERTENCIA: Se esperan 2 argumentos, recibiste $#."
    echo "   Continuando con valores por defecto..."
    ORGANISMO="$1"
    ARCHIVO="genoma_default.fasta"
else
    ORGANISMO="$1"
    ARCHIVO="$2"
fi

echo "✅ Configuración aceptada:"
echo "   Organismo : $ORGANISMO"
echo "   Archivo   : $ARCHIVO"
echo "   PID       : $$"
```

**Ejecución sin argumentos:**
```
bash ejercicio5_argumentos.sh
# Output:
# === VALIDADOR DE ARGUMENTOS ===
# Script: ejercicio5_argumentos.sh
# Argumentos recibidos: 0
# 
# ❌ ERROR: No ingresaste argumentos.
#    Uso: bash ejercicio5_argumentos.sh <organismo> <archivo.fasta>
```

**Ejecución correcta:**
```
bash ejercicio5_argumentos.sh "E. coli" genoma_k12.fasta
# Output:
# ✅ Configuración aceptada:
#    Organismo : E. coli
#    Archivo   : genoma_k12.fasta
#    PID       : 15823
```

---

## 🧬 11. Scripts Bioinformáticos: De Simple a Complejo

Esta sección presenta scripts progresivos que integran todos los conceptos de la sesión aplicados a problemas reales de bioinformática.

---

### 🟢 Nivel 1 — Básico: Variables y echo

**`etiqueta_muestra.sh`** — Genera una etiqueta estándar para registro de muestras.

```bash
#!/bin/bash
# etiqueta_muestra.sh
# Genera etiqueta estandarizada para registro de muestra biológica
# Autor: [Tu nombre] | Fecha: 2026-06-14
# Uso: bash etiqueta_muestra.sh

echo "=========================================="
echo "      SISTEMA DE REGISTRO DE MUESTRAS     "
echo "=========================================="
echo ""

read -p "Nombre del organismo  : " ORGANISMO
read -p "Número de cepa        : " CEPA
read -p "Tipo de muestra       : " TIPO
read -p "Nombre del responsable: " RESPONSABLE

# Variables del sistema
FECHA=$(date +"%Y-%m-%d")
HORA=$(date +"%H:%M")
ID_MUESTRA="${ORGANISMO:0:3}_${CEPA}_${FECHA}"

echo ""
echo "══════════════════════════════════"
echo "         ETIQUETA GENERADA        "
echo "══════════════════════════════════"
echo " ID        : ${ID_MUESTRA^^}"
echo " Organismo : $ORGANISMO"
echo " Cepa      : $CEPA"
echo " Tipo      : $TIPO"
echo " Fecha     : $FECHA — $HORA"
echo " Responsable: $RESPONSABLE"
echo "══════════════════════════════════"
```

**Ejemplo de ejecución:**
```
Nombre del organismo  : Escherichia coli
Número de cepa        : K-12
Tipo de muestra       : cultivo puro
Nombre del responsable: Ana García

══════════════════════════════════
         ETIQUETA GENERADA        
══════════════════════════════════
 ID        : ESC_K-12_2026-06-14
 Organismo : Escherichia coli
 Cepa      : K-12
 Tipo      : cultivo puro
 Fecha     : 2026-06-14 — 13:22
 Responsable: Ana García
══════════════════════════════════
```

---

**`estadisticas_secuencia.sh`** — Analiza una secuencia de ADN con aritmética básica.

```bash
#!/bin/bash
# estadisticas_secuencia.sh
# Calcula estadísticas básicas de una secuencia ingresada
# Uso: bash estadisticas_secuencia.sh

read -p "Ingresa una secuencia de ADN (A, T, C, G): " SECUENCIA
SECUENCIA="${SECUENCIA^^}"    # Convertir a mayúsculas

LONGITUD=${#SECUENCIA}

# Extraer extremos
EXTREMO_5="${SECUENCIA:0:6}"
EXTREMO_3="${SECUENCIA: -6}"

# Transcripción ADN → ARN
ARN="${SECUENCIA//T/U}"

# Detectar codón de inicio
INICIO="${SECUENCIA:0:3}"

echo ""
echo "=== ANÁLISIS DE SECUENCIA ==="
echo "Secuencia ADN  : $SECUENCIA"
echo "Longitud       : $LONGITUD bp"
echo "Extremo 5'     : $EXTREMO_5"
echo "Extremo 3'     : $EXTREMO_3"
echo "ARN mensajero  : $ARN"
echo ""

if [ "$INICIO" = "ATG" ]
then
    echo "✅ Codón de inicio ATG detectado en posición 1"
else
    echo "ℹ️  No inicia con ATG. Primer codón: $INICIO"
fi
```

**Ejemplo de ejecución:**
```
Ingresa una secuencia de ADN: atgcttgcaatcgatcgattt

=== ANÁLISIS DE SECUENCIA ===
Secuencia ADN  : ATGCTTGCAATCGATCGATTT
Longitud       : 21 bp
Extremo 5'     : ATGCTT
Extremo 3'     : GATTT
ARN mensajero  : AUGCUUGCAAUCGAUCGAUUU

✅ Codón de inicio ATG detectado en posición 1
```

---

### 🟡 Nivel 2 — Intermedio: Entorno, Expansión y Variables Especiales

**`configurar_proyecto.sh`** — Inicializa un proyecto bioinformático con variables de entorno.

```bash
#!/bin/bash
# configurar_proyecto.sh
# Inicializa entorno completo para un proyecto de análisis
# Uso: bash configurar_proyecto.sh <nombre_proyecto>
# Ejemplo: bash configurar_proyecto.sh RNAseq_MRSA_2026

# ── Validar argumento ──────────────────────────────────────────────
if [ $# -eq 0 ]
then
    echo "❌ ERROR: Debes proporcionar un nombre de proyecto."
    echo "   Uso: bash $0 <nombre_proyecto>"
    exit 1
fi

NOMBRE_PROYECTO="$1"
FECHA=$(date +"%Y-%m-%d")
USUARIO=$(whoami)
SCRIPT_DIR=$(dirname "$(realpath "$0")")

# ── Directorios del proyecto ───────────────────────────────────────
export PROYECTO_HOME="$HOME/proyectos/$NOMBRE_PROYECTO"
export DATOS_RAW="$PROYECTO_HOME/datos_raw"
export DATOS_PROC="$PROYECTO_HOME/datos_procesados"
export RESULTADOS="$PROYECTO_HOME/resultados"
export LOGS_DIR="$PROYECTO_HOME/logs"
export SCRIPTS_DIR="$PROYECTO_HOME/scripts"
export REF_DIR="$PROYECTO_HOME/referencias"

echo "╔══════════════════════════════════════════════╗"
echo "║     INICIALIZANDO PROYECTO BIOINFORMÁTICO    ║"
echo "╚══════════════════════════════════════════════╝"
echo ""
echo "📌 Proyecto   : $NOMBRE_PROYECTO"
echo "👤 Usuario    : $USUARIO"
echo "📅 Fecha      : $FECHA"
echo "🏠 Ubicación  : $PROYECTO_HOME"
echo ""

# ── Crear estructura de directorios ───────────────────────────────
echo "📁 Creando estructura de directorios..."
mkdir -p "$DATOS_RAW" "$DATOS_PROC" "$RESULTADOS" \
         "$LOGS_DIR" "$SCRIPTS_DIR" "$REF_DIR"

# ── Agregar scripts al PATH ────────────────────────────────────────
export PATH="$PATH:$SCRIPTS_DIR"

# ── Crear archivo de configuración ────────────────────────────────
CONFIG_FILE="$PROYECTO_HOME/proyecto_config.sh"
cat > "$CONFIG_FILE" << EOF
# Configuración del proyecto: $NOMBRE_PROYECTO
# Generado automáticamente el $FECHA por $USUARIO

export PROYECTO_NOMBRE="$NOMBRE_PROYECTO"
export PROYECTO_HOME="$PROYECTO_HOME"
export DATOS_RAW="$DATOS_RAW"
export DATOS_PROC="$DATOS_PROC"
export RESULTADOS="$RESULTADOS"
export LOGS_DIR="$LOGS_DIR"
export SCRIPTS_DIR="$SCRIPTS_DIR"
export REF_DIR="$REF_DIR"
export PATH="\$PATH:\$SCRIPTS_DIR"
EOF

# ── Crear log inicial ──────────────────────────────────────────────
LOG_FILE="$LOGS_DIR/proyecto_${FECHA}.log"
echo "[$FECHA $(date +%H:%M:%S)] Proyecto '$NOMBRE_PROYECTO' inicializado por $USUARIO" > "$LOG_FILE"
echo "[$FECHA $(date +%H:%M:%S)] PID del script de configuración: $$" >> "$LOG_FILE"

# ── Verificar resultado ────────────────────────────────────────────
if [ $? -eq 0 ]
then
    echo "✅ Estructura creada exitosamente:"
    find "$PROYECTO_HOME" -type d | sort | sed 's|.*/||' | while read dir
    do
        echo "   📂 $dir"
    done
    echo ""
    echo "💡 Para activar el entorno en nuevas sesiones:"
    echo "   source $CONFIG_FILE"
else
    echo "❌ Error al crear la estructura del proyecto."
    exit 1
fi
```

**Ejecución:**
```bash
bash configurar_proyecto.sh RNAseq_MRSA_2026
```
```
╔══════════════════════════════════════════════╗
║     INICIALIZANDO PROYECTO BIOINFORMÁTICO    ║
╚══════════════════════════════════════════════╝

📌 Proyecto   : RNAseq_MRSA_2026
👤 Usuario    : mramirez
📅 Fecha      : 2026-06-14
🏠 Ubicación  : /home/mramirez/proyectos/RNAseq_MRSA_2026

📁 Creando estructura de directorios...
✅ Estructura creada exitosamente:
   📂 RNAseq_MRSA_2026
   📂 datos_procesados
   📂 datos_raw
   📂 logs
   📂 referencias
   📂 resultados
   📂 scripts

💡 Para activar el entorno en nuevas sesiones:
   source /home/mramirez/proyectos/RNAseq_MRSA_2026/proyecto_config.sh
```

---

**`registro_ejecucion.sh`** — Usa `$?`, `$$` y `$#` para rastrear el estado de herramientas.

```bash
#!/bin/bash
# registro_ejecucion.sh
# Registra la ejecución de herramientas y captura errores
# Uso: bash registro_ejecucion.sh <archivo.fasta>

SCRIPT=$(basename "$0")
FECHA=$(date +"%Y-%m-%d_%H-%M-%S")
LOG="ejecucion_${FECHA}_$$.log"

echo "=== REGISTRO DE EJECUCIÓN ===" | tee "$LOG"
echo "Script   : $SCRIPT"            | tee -a "$LOG"
echo "PID      : $$"                 | tee -a "$LOG"
echo "Fecha    : $FECHA"             | tee -a "$LOG"
echo "Argumentos: $#"               | tee -a "$LOG"
echo ""                             | tee -a "$LOG"

# Verificar argumento
if [ $# -lt 1 ]
then
    echo "❌ Faltan argumentos. Uso: bash $SCRIPT <archivo.fasta>" | tee -a "$LOG"
    exit 1
fi

ARCHIVO="$1"

# Verificar que el archivo existe
echo "🔍 Verificando archivo: $ARCHIVO" | tee -a "$LOG"
ls "$ARCHIVO" > /dev/null 2>&1
CODIGO_LS=$?

if [ $CODIGO_LS -eq 0 ]
then
    echo "✅ Archivo encontrado (código: $CODIGO_LS)"      | tee -a "$LOG"
else
    echo "❌ Archivo NO encontrado (código: $CODIGO_LS)"   | tee -a "$LOG"
    exit 1
fi

# Contar secuencias
NUM_SEQS=$(grep -c ">" "$ARCHIVO")
CODIGO_GREP=$?

echo "✅ Secuencias encontradas: $NUM_SEQS (código: $CODIGO_GREP)" | tee -a "$LOG"

# Calcular tamaño
TAMANIO=$(wc -c < "$ARCHIVO")
TAMANIO_KB=$((TAMANIO / 1024))

echo "📦 Tamaño del archivo: $TAMANIO_KB KB"              | tee -a "$LOG"
echo ""                                                   | tee -a "$LOG"
echo "📄 Log guardado en: $LOG"
```

---

### 🔴 Nivel 3 — Avanzado: Pipeline completo con variables, validación y reporte

**`analizador_fasta_completo.sh`** — Analiza uno o múltiples archivos FASTA, valida con `$?`, genera reporte con variables de sistema.

```bash
#!/bin/bash
# analizador_fasta_completo.sh
# Pipeline de análisis de archivos FASTA con reporte automático
#
# Uso  : bash analizador_fasta_completo.sh <archivo.fasta> [directorio_salida]
# Ejm  : bash analizador_fasta_completo.sh ecoli_genes.fasta resultados/
#
# Autor : [Tu nombre]
# Fecha : 2026-06-14
# Versión: 1.0

# ══════════════════════════════════════════════════════════
# BLOQUE 1 — CONFIGURACIÓN INICIAL
# ══════════════════════════════════════════════════════════
SCRIPT_NAME=$(basename "$0")
SCRIPT_PID=$$
FECHA=$(date +"%Y-%m-%d")
HORA=$(date +"%H:%M:%S")
USUARIO=$(whoami)
MAQUINA=$(hostname)

# ══════════════════════════════════════════════════════════
# BLOQUE 2 — VALIDACIÓN DE ARGUMENTOS
# ══════════════════════════════════════════════════════════
if [ $# -lt 1 ]
then
    echo ""
    echo "❌ ERROR: Argumento faltante."
    echo ""
    echo "   Uso: bash $SCRIPT_NAME <archivo.fasta> [dir_salida]"
    echo "   Ejm: bash $SCRIPT_NAME ecoli_genes.fasta resultados/"
    echo ""
    exit 1
fi

ARCHIVO_ENTRADA="$1"
DIR_SALIDA="${2:-./resultados_$(date +%Y%m%d)}"

# ══════════════════════════════════════════════════════════
# BLOQUE 3 — VALIDACIÓN DEL ARCHIVO
# ══════════════════════════════════════════════════════════
echo ""
echo "╔══════════════════════════════════════════════════════╗"
echo "║        ANALIZADOR DE ARCHIVOS FASTA — v1.0          ║"
echo "╚══════════════════════════════════════════════════════╝"
echo ""

# Verificar existencia
if [ ! -f "$ARCHIVO_ENTRADA" ]
then
    echo "❌ Archivo no encontrado: $ARCHIVO_ENTRADA"
    exit 1
fi

# Verificar que no esté vacío
if [ ! -s "$ARCHIVO_ENTRADA" ]
then
    echo "❌ El archivo está vacío: $ARCHIVO_ENTRADA"
    exit 1
fi

# Verificar que tenga formato FASTA (debe tener líneas con >)
NUM_HEADERS=$(grep -c "^>" "$ARCHIVO_ENTRADA" 2>/dev/null)
if [ $? -ne 0 ] || [ "$NUM_HEADERS" -eq 0 ]
then
    echo "❌ El archivo no tiene formato FASTA válido."
    exit 1
fi

echo "✅ Archivo validado: $ARCHIVO_ENTRADA"
echo ""

# ══════════════════════════════════════════════════════════
# BLOQUE 4 — ANÁLISIS DEL ARCHIVO
# ══════════════════════════════════════════════════════════
NOMBRE_BASE=$(basename "$ARCHIVO_ENTRADA" .fasta)
TAMANIO_BYTES=$(wc -c < "$ARCHIVO_ENTRADA")
TAMANIO_KB=$((TAMANIO_BYTES / 1024))
TOTAL_LINEAS=$(wc -l < "$ARCHIVO_ENTRADA")
LINEAS_SECUENCIA=$((TOTAL_LINEAS - NUM_HEADERS))

# Extraer información de las cabeceras
PRIMERA_SEQ=$(grep "^>" "$ARCHIVO_ENTRADA" | head -1 | sed 's/>//')
ULTIMA_SEQ=$(grep "^>" "$ARCHIVO_ENTRADA" | tail -1 | sed 's/>//')

# Longitud total de secuencias (sin cabeceras ni saltos de línea)
BASES_TOTALES=$(grep -v "^>" "$ARCHIVO_ENTRADA" | tr -d '\n' | wc -c)
LONGITUD_PROMEDIO=$((BASES_TOTALES / NUM_HEADERS))

# ══════════════════════════════════════════════════════════
# BLOQUE 5 — CREAR DIRECTORIO Y REPORTE
# ══════════════════════════════════════════════════════════
mkdir -p "$DIR_SALIDA"
REPORTE="$DIR_SALIDA/${NOMBRE_BASE}_reporte_${FECHA}.txt"

cat > "$REPORTE" << EOF
══════════════════════════════════════════════════════════
  REPORTE DE ANÁLISIS FASTA
  Generado por: $SCRIPT_NAME (PID: $SCRIPT_PID)
══════════════════════════════════════════════════════════

METADATOS DE EJECUCIÓN
──────────────────────────────────────────────────────────
  Usuario      : $USUARIO
  Máquina      : $MAQUINA
  Fecha        : $FECHA
  Hora         : $HORA
  Script       : $SCRIPT_NAME

INFORMACIÓN DEL ARCHIVO
──────────────────────────────────────────────────────────
  Archivo      : $ARCHIVO_ENTRADA
  Nombre base  : $NOMBRE_BASE
  Tamaño       : $TAMANIO_BYTES bytes ($TAMANIO_KB KB)
  Líneas totales: $TOTAL_LINEAS

ANÁLISIS DE SECUENCIAS
──────────────────────────────────────────────────────────
  Nº de secuencias  : $NUM_HEADERS
  Bases totales     : $BASES_TOTALES bp
  Longitud promedio : $LONGITUD_PROMEDIO bp
  Primera secuencia : $PRIMERA_SEQ
  Última secuencia  : $ULTIMA_SEQ

CABECERAS ENCONTRADAS
──────────────────────────────────────────────────────────
$(grep "^>" "$ARCHIVO_ENTRADA" | nl -ba)

══════════════════════════════════════════════════════════
  FIN DEL REPORTE
══════════════════════════════════════════════════════════
EOF

# ══════════════════════════════════════════════════════════
# BLOQUE 6 — MOSTRAR RESUMEN EN PANTALLA
# ══════════════════════════════════════════════════════════
echo "📊 RESULTADOS DEL ANÁLISIS"
echo "──────────────────────────────────────────────"
echo "  Archivo analizado : $ARCHIVO_ENTRADA"
echo "  Secuencias        : $NUM_HEADERS"
echo "  Bases totales     : $BASES_TOTALES bp"
echo "  Longitud promedio : $LONGITUD_PROMEDIO bp"
echo "  Tamaño del archivo: $TAMANIO_KB KB"
echo ""
echo "📄 Reporte guardado en: $REPORTE"
echo ""

# ══════════════════════════════════════════════════════════
# BLOQUE 7 — CÓDIGO DE SALIDA
# ══════════════════════════════════════════════════════════
HORA_FIN=$(date +"%H:%M:%S")
echo "🏁 Análisis completado a las $HORA_FIN"
exit 0
```

**Ejecución:**
```bash
bash analizador_fasta_completo.sh ecoli_genes.fasta mis_resultados/
```
```
╔══════════════════════════════════════════════════════╗
║        ANALIZADOR DE ARCHIVOS FASTA — v1.0          ║
╚══════════════════════════════════════════════════════╝

✅ Archivo validado: ecoli_genes.fasta

📊 RESULTADOS DEL ANÁLISIS
──────────────────────────────────────────────
  Archivo analizado : ecoli_genes.fasta
  Secuencias        : 5
  Bases totales     : 3847 bp
  Longitud promedio : 769 bp
  Tamaño del archivo: 4 KB

📄 Reporte guardado en: mis_resultados/ecoli_genes_reporte_2026-06-14.txt

🏁 Análisis completado a las 13:28:42
```

---

## 📸 12. Actividad Asincrónica

### 🎯 Misión: construir tu propio toolkit de variables y análisis

Crea los siguientes scripts en tu repositorio de GitHub, en la carpeta `Sesion_12/`.

---

### 🧬 Script 1: `mi_laboratorio.sh` *(Obligatorio)*

**Objetivo:** Script interactivo que pide información del laboratorio y genera una ficha de identificación usando variables locales, globales y expansión de comandos.

**Requisitos:**
- `read -p` para pedir al menos 4 datos (laboratorio, línea de investigación, número de muestras, investigador)
- Al menos una variable con `export`
- Usar `$(date)` y `$(whoami)` para datos automáticos
- Mostrar la ficha con un formato limpio usando `echo`

---

### 🔬 Script 2: `configurador_path.sh` *(Obligatorio)*

**Objetivo:** Script que simula configurar el entorno de trabajo para una herramienta bioinformática, modificando `PATH` y creando un archivo de configuración.

**Requisitos:**
- Aceptar el nombre de la herramienta como argumento `$1`
- Validar con `$#` que se recibió el argumento
- Crear el directorio `~/biotools/<herramienta>/bin`
- Agregar ese directorio al `PATH` con `export`
- Guardar la configuración en `~/.bashrc_biotools` (no modificar `.bashrc` real)
- Verificar con `$?` que cada paso fue exitoso

---

### 🧪 Script 3: `calculadora_cobertura.sh` *(Obligatorio)*

**Objetivo:** Dado un archivo FASTA y el tamaño del genoma de referencia, calcular la cobertura estimada de secuenciación.

**Requisitos:**
- Aceptar `$1` = archivo FASTA y `$2` = tamaño del genoma en Mb
- Validar que ambos argumentos existan con `$#`
- Calcular: número de secuencias, bases totales, cobertura estimada (bases / genoma_bp)
- Usar aritmética con `$(( ))` para la división
- Mostrar si la cobertura es suficiente (≥ 30x) o insuficiente usando `if`
- El nombre del script (`$0`) debe aparecer en el mensaje de uso

---

### 🏆 Script Bonus: `pipeline_variables.sh` *(Opcional — para nota extra)*

Crea un pipeline que integre **todos los conceptos de la sesión**:

1. Acepta un archivo FASTA como argumento
2. Usa `export` para definir variables de entorno del pipeline
3. Valida el archivo con operadores de archivo (`-f`, `-s`)
4. Extrae información con expansión de comandos (`$(grep...)`, `$(wc...)`)
5. Calcula estadísticas con aritmética (`$(( ))`)
6. Usa `$?` para verificar cada paso y registrar errores
7. Genera un reporte con `$$` en el nombre del archivo temporal
8. Guarda todo en un directorio nombrado con `$(date +%Y%m%d)_$$`

---

### ✅ Checklist de entrega

Antes de subir a GitHub, verifica:

- [ ] Los 3 scripts obligatorios están en la carpeta `Sesion_12/`
- [ ] Cada script tiene `#!/bin/bash` en la primera línea
- [ ] Cada script tiene cabecera de comentarios con nombre, fecha y uso
- [ ] Todos tienen permisos de ejecución (`chmod +x nombre_script.sh`)
- [ ] Ningún script falla con `bash -n script.sh` (verifica sintaxis)
- [ ] Los 3 scripts se ejecutan sin errores
- [ ] Incluiste capturas de pantalla de la ejecución de cada script
- [ ] Subiste todo con commit descriptivo: `git commit -m "Sesion 12: variables y operaciones"`

---

## 🗂️ Resumen de Comandos de la Sesión

### Variables

| Operación | Sintaxis | Ejemplo |
|-----------|----------|---------|
| Crear variable local | `VAR=valor` | `CEPA="MG1655"` |
| Crear variable global | `export VAR=valor` | `export DB="/data/refs"` |
| Leer variable | `$VAR` o `${VAR}` | `echo $CEPA` |
| Variable pegada a texto | `${VAR}texto` | `echo "${CEPA}_v2"` |
| Cargar config en sesión | `source archivo.sh` | `source config.sh` |

### Variables especiales

| Variable | Qué contiene |
|----------|-------------|
| `$0` | Nombre del script |
| `$1`, `$2`... | Argumentos posicionales |
| `$#` | Número de argumentos |
| `$@` | Todos los argumentos |
| `$$` | PID del proceso actual |
| `$?` | Código de salida del último comando |
| `$PPID` | PID del proceso padre |

### Operaciones

| Operación | Sintaxis | Ejemplo | Resultado |
|-----------|----------|---------|-----------|
| Aritmética (enteros) | `$((expr))` | `$((10 * 3))` | `30` |
| Aritmética (decimales) | `$(echo "scale=2; expr" \| bc)` | `$(echo "scale=2; 10/3" \| bc)` | `3.33` |
| Expansión de comando | `$(comando)` | `$(date +%Y)` | `2026` |
| Comillas dobles | `"$VAR"` | `echo "$USER"` | expande variable |
| Comillas simples | `'$VAR'` | `echo '$USER'` | texto literal |

### PATH

| Acción | Comando |
|--------|---------|
| Ver PATH legible | `echo $PATH \| tr ':' '\n'` |
| Agregar al final | `export PATH=$PATH:/nueva/ruta` |
| Agregar al inicio | `export PATH=/nueva/ruta:$PATH` |
| Hacer permanente | Editar `~/.bashrc` y `source ~/.bashrc` |

---

## 📚 Referencias Bibliográficas

1. Hausenblas, M. (2022). *Learning Modern Linux*. O'Reilly Media. Capítulo 5.  
   [https://learning.oreilly.com/library/view/learning-modern-linux/9781098108939/](https://learning.oreilly.com/library/view/learning-modern-linux/9781098108939/)

2. Blum, R., & Bresnahan, C. (2021). *Linux Command Line and Shell Scripting Bible* (4th ed.). Wiley. Capítulos 5–6.

3. Kothari, D., Shriram, K., & Sundaram, R. (2011). *Linux*. New Age International. Capítulo 7.  
   [https://catalogo.upc.edu.pe/permalink/51UPC_INST/logil2/cdi_proquest_ebookcentral_EBC5490883](https://catalogo.upc.edu.pe/permalink/51UPC_INST/logil2/cdi_proquest_ebookcentral_EBC5490883)

4. Documentación oficial de Bash — Shell Variables:  
   [https://www.gnu.org/software/bash/manual/bash.html#Shell-Variables](https://www.gnu.org/software/bash/manual/bash.html#Shell-Variables)

5. ShellCheck — Validador de sintaxis Bash:  
   [https://www.shellcheck.net/](https://www.shellcheck.net/)

---

> 🎓 *"Un script sin variables es como un protocolo de laboratorio que repite el nombre de cada reactivo en cada paso. Las variables no solo ahorran tiempo: hacen que tu código sea legible, reutilizable y fácil de adaptar cuando cambia una condición experimental — que en bioinformática, siempre cambia."*

---

*Documento preparado para la Sesión 10 - Semana 12 del curso Principios de Programación en Bioinformática. UPC exígete, innova.*
