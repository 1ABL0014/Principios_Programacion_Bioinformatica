# 🧬 Sesión 11: Elementos de la Sintaxis de Shell Scripting II
## Variables: definición, tipos y alcance

**Docentes:** Frank Guzmán Escudero, Manuel Ramírez Sáenz
**Universidad:** UPC - Facultad de Ciencias de la Salud - Programa de Biología
**Horario:** 1:00 pm - 5:00 pm (Descanso: 2:45 pm - 3:00 pm)
**Bloque de esta sesión:** Variables (1:00 pm - 2:00 pm)

---

## 🎯 Logro de la Sesión

Al finalizar este bloque, el estudiante:
- Define y declara variables en Bash respetando la sintaxis y las reglas de nombres
- Distingue entre variables de usuario, variables de entorno y variables del sistema
- Usa comillas simples, dobles y ninguna de forma correcta según el caso
- Diferencia una variable local de una global (`export`) y explica el papel de la subshell
- Consulta y modifica la variable de entorno `PATH` para ejecutar herramientas bioinformáticas

**Palabras clave:** Variable, declaración, asignación, comillas, variable local, variable de entorno, `export`, subshell, `PATH`

---

## 📋 Pre-requisitos

- Haber completado las Sesiones 9 y 10
- Saber crear un script con shebang (`#!/bin/bash`) y ejecutarlo (`chmod +x`, `./script.sh`)
- Manejar comandos básicos de navegación y archivos (`pwd`, `ls`, `cd`, `mkdir`, `cat`, `echo`)

---

## 🧠 1. Repaso Rápido

```bash
#!/bin/bash                 # Shebang: indica qué intérprete ejecuta el script
echo "Hola, bioinformática" # Imprime un mensaje
pwd                         # Muestra el directorio actual
mkdir -p datos/raw          # Crea directorios (con -p crea también los padres)
```

Hoy vamos a guardar valores en memoria con nombre, usarlos y controlar dónde son visibles.

---

## 📦 2. ¿Qué es una variable?

Una **variable** es un espacio en memoria con un nombre, donde se guarda un valor que puedes consultar o cambiar cuando lo necesites.

**Analogía:** una variable es como un tubo de microcentrífuga rotulado. El rótulo es el nombre y lo que hay dentro es el valor.

```
  ┌──────────────────┐
  │ MUESTRA = "K12"  │   ← nombre: MUESTRA    valor: K12
  └──────────────────┘
```

### Sintaxis básica

```bash
nombre_variable=valor      # Asignar (declarar) un valor
echo $nombre_variable      # Leer el valor
echo ${nombre_variable}    # Leer el valor (forma explícita)
```

> ⚠️ **Regla crítica:** no pongas espacios alrededor del `=`. El shell interpretaría la palabra anterior como un comando.

```bash
# ✅ CORRECTO
PROYECTO="Analisis_RNA"
NUM_MUESTRAS=50

# ❌ INCORRECTO: error "command not found"
PROYECTO = "Analisis_RNA"
```

### Reglas para los nombres

| Regla | Ejemplo correcto | Ejemplo incorrecto |
|-------|------------------|--------------------|
| Solo letras, números y `_` | `NUM_MUESTRAS` | `num-muestras` |
| No puede empezar con número | `CEPA_1` | `1_CEPA` |
| Convención: MAYÚSCULAS para constantes | `RUTA_DATOS` | `ruta datos` |
| Nombres descriptivos | `ARCHIVO_ENTRADA` | `a` |

---

## 🔤 3. Leer variables: `$VAR` y `${VAR}`

```bash
ARCHIVO="genoma"

echo $ARCHIVO            # Forma simple
echo ${ARCHIVO}          # Forma con llaves
echo ${ARCHIVO}v1.fasta  # ✅ imprime: genomav1.fasta
echo $ARCHIVOv1.fasta    # ❌ busca la variable $ARCHIVOv1, que no existe
```

Usa llaves cuando el nombre de la variable va pegado a otro texto.

### 🔬 Pruébalo en tu terminal

```bash
ORGANISMO="Escherichia coli"
CEPA="K-12"
ANIO=2026

echo "Organismo: $ORGANISMO"
echo "Cepa: $CEPA"
echo "Año: $ANIO"
echo "ID completo: ${ORGANISMO}_${CEPA}_${ANIO}"
```

**Salida esperada:**
```
Organismo: Escherichia coli
Cepa: K-12
Año: 2026
ID completo: Escherichia coli_K-12_2026
```

---

### 🧪 Ejercicio 1: ¿dónde termina el nombre de la variable?

El shell lee el nombre de una variable hasta encontrar un carácter que no puede formar parte de él. El guion bajo `_` **sí** forma parte del nombre; el punto y el guion medio **no**. Por eso las llaves hacen falta cuando el texto que sigue a la variable empieza con letras, números o `_`.

Crea `ejercicio1_llaves.sh`:

```bash
#!/bin/bash
# ejercicio1_llaves.sh
# Compara $VAR y ${VAR} cuando el nombre va seguido de otros caracteres

ARCHIVO="genoma"
ESPECIE="ecoli"

echo "--- Caso 1: guion bajo después de la variable ---"
echo "A: $ARCHIVO_v1"
echo "B: ${ARCHIVO}_v1"

echo "--- Caso 2: punto después de la variable ---"
echo "A: $ARCHIVO.fasta"
echo "B: ${ARCHIVO}.fasta"

echo "--- Caso 3: número después de la variable ---"
echo "A: $ARCHIVO1"
echo "B: ${ARCHIVO}1"

echo "--- Caso 4: varias variables seguidas ---"
echo "A: $ESPECIE_$ARCHIVO"
echo "B: ${ESPECIE}_${ARCHIVO}"
```

**Salida esperada** (en la línea A de los casos 1 y 3 no aparece nada después de `A: `):
```
--- Caso 1: guion bajo después de la variable ---
A: 
B: genoma_v1
--- Caso 2: punto después de la variable ---
A: genoma.fasta
B: genoma.fasta
--- Caso 3: número después de la variable ---
A: 
B: genoma1
--- Caso 4: varias variables seguidas ---
A: genoma
B: ecoli_genoma
```

**Tabla de lectura:** antes de ejecutar, completa mentalmente la última columna.

| Escribes | El shell busca la variable | Resultado |
|----------|----------------------------|-----------|
| `$ARCHIVO_v1` | `ARCHIVO_v1` (no existe) | vacío |
| `${ARCHIVO}_v1` | `ARCHIVO` | `genoma_v1` |
| `$ARCHIVO.fasta` | `ARCHIVO` | `genoma.fasta` |
| `$ARCHIVO1` | `ARCHIVO1` (no existe) | vacío |
| `${ARCHIVO}1` | `ARCHIVO` | `genoma1` |

**Predice antes de ejecutar:** ¿qué imprime `echo $ESPECIE_$ARCHIVO`? ¿Y `echo ${ESPECIE}_${ARCHIVO}`? Escribe tu respuesta y compárala con la salida.

> 💡 Regla práctica: si tienes dudas, usa `${VAR}`. Es válido en todos los casos y evita errores difíciles de encontrar.

---

## 🔣 4. Comillas: qué interpreta el shell

Las comillas deciden si el shell expande las variables o las trata como texto literal.

| Tipo | Ejemplo | Resultado |
|------|---------|-----------|
| Dobles `" "` | `echo "Hola $USER"` | expande la variable |
| Simples `' '` | `echo 'Hola $USER'` | texto literal: `Hola $USER` |
| Ninguna | `echo Hola $USER` | expande, pero se rompe con espacios |

### El problema de los espacios

```bash
RUTA="mis datos"

mkdir $RUTA      # ❌ crea DOS carpetas: "mis" y "datos"
mkdir "$RUTA"    # ✅ crea UNA carpeta: "mis datos"
```

> ⚠️ **Regla de oro:** escribe siempre las variables entre comillas dobles: `"$VARIABLE"`. Los nombres de organismos, cepas y rutas suelen tener espacios.

### 🔬 Pruébalo en tu terminal

```bash
#!/bin/bash
# comillas.sh
ARCHIVO="genoma_k12.fasta"
RUTA="/datos/referencias"

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

## 🔢 5. Tipos de variables

En Bash todas las variables guardan **texto** por defecto. Cuando necesitas operar con números, usa la aritmética con `$(( ))`, que trabaja solo con enteros.

```bash
MUESTRAS=12
EXTRA=$((MUESTRAS + 3))     # 15
TOTAL=$((EXTRA * 2))        # 30
echo "Total de muestras: $TOTAL"
```

> 💡 Los decimales no se calculan con `$(( ))`. Se verán en una sesión posterior con la herramienta `bc`.

Según su alcance y origen, las variables se clasifican en tres grupos:

| Tipo | Quién la crea | Ejemplo | ¿Se hereda a subprocesos? |
|------|---------------|---------|---------------------------|
| **Local** (de usuario) | Tú, en el script o la terminal | `CEPA="MG1655"` | No |
| **De entorno** (global) | Tú, con `export` | `export DB_PATH="/data/refs"` | Sí |
| **Del sistema** (predefinida) | El sistema operativo | `$HOME`, `$USER`, `$PATH` | Sí |

---

## 🌍 6. Variables locales y globales

### Variable local

Existe solo en el shell o script donde fue creada.

```bash
#!/bin/bash
# ejemplo_local.sh
MUESTRA="bacteria_001"
echo "Dentro del script: $MUESTRA"
```

```bash
bash ejemplo_local.sh     # Dentro del script: bacteria_001
echo "$MUESTRA"           # (vacío: la variable no existe en tu terminal)
```

### Variable global (de entorno)

Se exporta con `export` y puede ser leída por los procesos que se lanzan desde ese shell.

```bash
export LABORATORIO="Genómica Computacional"
bash -c 'echo "En subshell: $LABORATORIO"'   # sí la ve
```

### 🔬 Pruébalo en tu terminal: la diferencia crítica

```bash
# Variable local
SECUENCIA_LOCAL="ATCG"
bash -c 'echo "Local en subshell: $SECUENCIA_LOCAL"'     # → vacío

# Variable global
export SECUENCIA_GLOBAL="GCTA"
bash -c 'echo "Global en subshell: $SECUENCIA_GLOBAL"'   # → GCTA
```

**Salida esperada:**
```
Local en subshell: 
Global en subshell: GCTA
```

### 🐚 Shell, subshell y `source`

Al ejecutar `bash script.sh`, Linux crea un **subshell** (proceso hijo) con su propia memoria. Los cambios que hace el hijo no regresan al padre.

```
TERMINAL (shell padre)
│   export DB_PATH="/data/refs"
│
├─► bash analisis.sh   (subshell)
│       DB_PATH="/data/refs"     ← heredada, porque fue exportada
│       TEMP="valor_temp"        ← nueva, NO sube al padre
│
└── echo $TEMP                   # → vacío
```

| Comando | ¿Dónde se ejecuta? | ¿Las variables quedan en tu terminal? |
|---------|--------------------|---------------------------------------|
| `bash script.sh` | En un subshell | ❌ No |
| `source script.sh` | En tu shell actual | ✅ Sí |

### 🔬 Pruébalo: `bash` frente a `source`

```bash
echo 'export DATOS_REF="/home/usuario/referencias"' > config_proyecto.sh

bash config_proyecto.sh
echo "$DATOS_REF"          # → vacío

source config_proyecto.sh
echo "$DATOS_REF"          # → /home/usuario/referencias
```

> 💡 Las herramientas bioinformáticas suelen activarse con `source`. Por ejemplo: `source activate mi_entorno`.

### 🧪 Ejercicio 2: alcance de las variables

Crea `ejercicio2_alcance.sh`:

```bash
#!/bin/bash
# ejercicio2_alcance.sh
# Muestra el alcance de variables locales y globales

ESPECIE_LOCAL="Salmonella enterica"
export ESPECIE_GLOBAL="Mycobacterium tuberculosis"

echo "=== SCRIPT PRINCIPAL ==="
echo "Local  : $ESPECIE_LOCAL"
echo "Global : $ESPECIE_GLOBAL"
echo ""

echo "=== SUBSHELL ==="
bash -c 'echo "Local  : $ESPECIE_LOCAL"; echo "Global : $ESPECIE_GLOBAL"'
```

**Salida esperada:**
```
=== SCRIPT PRINCIPAL ===
Local  : Salmonella enterica
Global : Mycobacterium tuberculosis

=== SUBSHELL ===
Local  : 
Global : Mycobacterium tuberculosis
```

**Pregunta de control:** si cambias `export` por una asignación normal en `ESPECIE_GLOBAL`, ¿qué línea del subshell cambia? Escribe tu respuesta antes de ejecutar.

---

## ⚙️ 7. Variables del sistema

Son variables que el sistema define al iniciar tu sesión. Están disponibles en cualquier script.

| Variable | Contenido | Ejemplo de valor |
|----------|-----------|------------------|
| `$HOME` | Directorio personal | `/home/estudiante` |
| `$USER` | Usuario actual | `estudiante` |
| `$SHELL` | Shell por defecto | `/bin/bash` |
| `$PWD` | Directorio de trabajo | `/home/estudiante/proyecto` |
| `$HOSTNAME` | Nombre de la máquina | `cloudshell-vm` |
| `$LANG` | Idioma y codificación | `es_PE.UTF-8` |
| `$PATH` | Rutas donde se buscan los programas | `/usr/local/bin:/usr/bin:/bin` |

Para verlas:

```bash
echo $HOME
printenv            # Lista todas las variables de entorno
env | grep -i path  # Filtra las que contienen "path"
```

### 🧪 Ejercicio 3: informe del entorno

Crea `ejercicio3_entorno.sh`:

```bash
#!/bin/bash
# ejercicio3_entorno.sh
# Informe del entorno usando variables del sistema

echo "=== INFORME DEL ENTORNO ==="
echo "Usuario        : $USER"
echo "Máquina        : $HOSTNAME"
echo "Shell          : $SHELL"
echo "Directorio HOME: $HOME"
echo "Directorio actual: $PWD"
echo "Idioma         : $LANG"
```

**Salida esperada (los valores dependen de tu cuenta):**
```
=== INFORME DEL ENTORNO ===
Usuario        : estudiante
Máquina        : cloudshell-vm
Shell          : /bin/bash
Directorio HOME: /home/estudiante
Directorio actual: /home/estudiante
Idioma         : es_PE.UTF-8
```

---

## 🛤️ 8. La variable `PATH`

`PATH` es la lista de carpetas donde el sistema busca un programa cuando escribes su nombre. Si la herramienta no está en ninguna de ellas, aparece `command not found`.

```
Escribes: fastqc

Shell busca fastqc en:
  /usr/local/bin      ← no está
  /usr/bin            ← no está
  /bin                ← no está
  ~/biotools/FastQC   ← ✅ está en PATH → se ejecuta
```

### Ver y agregar rutas

```bash
echo $PATH | tr ':' '\n'           # Una ruta por línea

export PATH=$PATH:/ruta/nueva      # Agregar al final (menor prioridad)
export PATH=/ruta/nueva:$PATH      # Agregar al inicio (mayor prioridad)
```

Un `export` solo dura mientras la terminal esté abierta. Para que sea permanente, agrega la línea al final de `~/.bashrc` y recarga el archivo con `source ~/.bashrc`.

### 🔬 Pruébalo en tu terminal: simulación de instalación

```bash
mkdir -p "$HOME/mis_biotools/bin"

cat > "$HOME/mis_biotools/bin/mibiotool" << 'EOF'
#!/bin/bash
echo "MiBioTool v1.0: herramienta bioinformática"
echo "Analizando: $1"
EOF

chmod +x "$HOME/mis_biotools/bin/mibiotool"

mibiotool genoma.fasta                       # → command not found

export PATH="$PATH:$HOME/mis_biotools/bin"
mibiotool genoma.fasta                       # → funciona
```

**Salida esperada:**
```
bash: mibiotool: command not found
MiBioTool v1.0: herramienta bioinformática
Analizando: genoma.fasta
```

### 🧪 Ejercicio 4: configurar PATH para un proyecto

Crea `ejercicio4_path.sh`:

```bash
#!/bin/bash
# ejercicio4_path.sh
# Agrega carpetas de herramientas al PATH del script

BIOTOOLS_DIR="$HOME/biotools"
mkdir -p "$BIOTOOLS_DIR/FastQC" "$BIOTOOLS_DIR/samtools/bin"

export PATH="$PATH:$BIOTOOLS_DIR/FastQC"
export PATH="$PATH:$BIOTOOLS_DIR/samtools/bin"

echo "Rutas de biotools en el PATH:"
echo "$PATH" | tr ':' '\n' | grep "biotools"
```

**Salida esperada:**
```
Rutas de biotools en el PATH:
/home/estudiante/biotools/FastQC
/home/estudiante/biotools/samtools/bin
```

> 💡 Este script exporta el PATH solo dentro de su propio subshell. Para ver el cambio en tu terminal, ejecútalo con `source`.

---

## 📸 9. Actividad Asincrónica

### 🎯 Misión: primer toolkit de variables

Crea los siguientes scripts en tu repositorio de GitHub, dentro de la carpeta `Sesion_11/`.

### 🧬 Script 1: `ficha_muestra.sh` *(Obligatorio)*

**Objetivo:** generar una ficha de identificación de una muestra usando variables locales y globales.

**Requisitos:**
- Define al menos 4 variables locales: organismo, cepa, tipo de muestra y responsable
- Exporta al menos una variable con `export`
- Muestra la ficha con `echo`, usando comillas dobles en todas las variables
- Incluye la fecha con `$(date +"%Y-%m-%d")`

**Salida de ejemplo:**
```
══════════════════════════════════
          FICHA DE MUESTRA
══════════════════════════════════
 Organismo   : Escherichia coli
 Cepa        : K-12
 Tipo        : cultivo puro
 Responsable : Ana García
 Fecha       : 2026-11-02
══════════════════════════════════
```

### 🔬 Script 2: `configurador_path.sh` *(Obligatorio)*

**Objetivo:** crear una carpeta para una herramienta bioinformática y agregarla al `PATH`.

**Requisitos:**
- Define la variable `HERRAMIENTA` con el nombre de la herramienta (por ejemplo, `fastqc`)
- Crea la carpeta `$HOME/biotools/$HERRAMIENTA/bin` con `mkdir -p`
- Agrega esa carpeta al `PATH` con `export`
- Imprime la nueva ruta con `echo` y `grep`

### ✅ Checklist de entrega

- [ ] Los dos scripts están en `Sesion_11/`
- [ ] Cada script empieza con `#!/bin/bash`
- [ ] Cada script tiene un comentario con tu nombre y la fecha
- [ ] Tienen permiso de ejecución (`chmod +x`)
- [ ] Pasan la revisión de sintaxis (`bash -n script.sh`)
- [ ] Ambos se ejecutan sin errores
- [ ] Incluiste capturas de la ejecución
- [ ] Commit: `git commit -m "Sesion 11: variables y PATH"`

---

## 🗂️ Resumen de Comandos de la Sesión

| Operación | Sintaxis | Ejemplo |
|-----------|----------|---------|
| Crear variable local | `VAR=valor` | `CEPA="MG1655"` |
| Crear variable de entorno | `export VAR=valor` | `export DB="/data/refs"` |
| Leer variable | `$VAR` o `${VAR}` | `echo $CEPA` |
| Delimitar el nombre con llaves | `${VAR}texto` | `echo ${ARCHIVO}_v1` → `genoma_v1` |
| Cargar configuración en la sesión | `source archivo.sh` | `source config.sh` |
| Aritmética entera | `$((expr))` | `$((10 * 3))` → `30` |
| Variable entre comillas | `"$VAR"` | `mkdir "$RUTA"` |
| Ver PATH legible | `echo $PATH \| tr ':' '\n'` | |
| Agregar al PATH | `export PATH="$PATH:/ruta"` | |

---

## 📚 Referencias Bibliográficas

1. Blum, R., & Bresnahan, C. (2021). *Linux Command Line and Shell Scripting Bible* (4th ed.). Wiley. Capítulos sobre variables y entorno de shell.
2. Documentación oficial de GNU Bash: *Shell Variables* y *Shell Parameter Expansion*.
   [https://www.gnu.org/software/bash/manual/bash.html](https://www.gnu.org/software/bash/manual/bash.html)
3. ShellCheck: validador de sintaxis Bash.
   [https://www.shellcheck.net/](https://www.shellcheck.net/)

---

> 🎓 *"Una variable bien nombrada es como un rótulo bien escrito en un tubo: cualquiera que abra tu código sabe qué contiene sin tener que adivinarlo."*

---

*Documento preparado para la Sesión 11 del curso Principios de Programación en Bioinformática. UPC exígete, innova.*
