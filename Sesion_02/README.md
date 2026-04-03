# Sesión 02 — Ambiente de Trabajo 🖥️🐧

> **Curso:** Principios de Programación en Bioinformática (1ABL0014)  
> **Programa:** Biología — Facultad de Ciencias de la Salud  
> **Universidad:** Universidad Peruana de Ciencias Aplicadas (UPC)  
> **Semestre:** 2026-1 | **Ciclo:** 4  
> **Docentes:** Frank Guzman Escudero · Manuel Ramírez Sáenz

---

## 🎯 Logro de la Sesión

Al finalizar esta sesión, el estudiante **utiliza las herramientas esenciales para trabajar de manera efectiva en entornos de escritorio y en la línea de comandos**, incluyendo la instalación y gestión de software bioinformático con Conda.

---

## 🧭 ¿Por qué importa esta sesión en bioinformática?

Antes de analizar un genoma, ensamblar transcriptomas o estudiar metagenomas, todo bioinformático necesita un **ambiente de trabajo funcional y reproducible**. Esto significa:

- Un sistema operativo donde las herramientas bioinformáticas están disponibles (mayoritariamente **GNU/Linux**).
- Una **terminal** para ejecutar comandos sin limitaciones gráficas.
- Un **gestor de paquetes** (Conda) para instalar programas complejos con todas sus dependencias.

> 💡 **Dato real:** El 95% de los servidores de cómputo en bioinformática corren GNU/Linux. Aprender a trabajar en este entorno desde ahora es invertir en tu carrera científica.

---

## 📋 Agenda

| # | Tema | Tiempo estimado |
|---|------|----------------|
| 1 | Entorno de escritorio y terminal | 20 min |
| 2 | Interfaz de línea de comandos (CLI) | 40 min |
| 3 | Localización de comandos y sistema de archivos | 20 min |
| 4 | Instalación y administración con Conda | 40 min |

---

## 1. 🖥️ Entorno de Escritorio y Terminal

### ¿Por qué GNU/Linux para bioinformática?

GNU/Linux domina la bioinformática por razones concretas:

| Característica | GNU/Linux | Windows | macOS |
|---|---|---|---|
| Herramientas bioinformáticas nativas | ✅ Miles | ⚠️ Limitadas | ✅ Buenas |
| Acceso a servidores HPC | ✅ Nativo (SSH) | ⚠️ Requiere cliente | ✅ Nativo |
| Automatización por scripts | ✅ Bash nativo | ⚠️ PowerShell | ✅ Bash/Zsh |
| Costo de licencia | ✅ Gratuito | ❌ De pago | ❌ Hardware Apple |
| Soporte comunidad científica | ✅ Muy alto | ⚠️ Limitado | ✅ Alto |
| Reproducibilidad de análisis | ✅ Alta | ⚠️ Variable | ✅ Alta |

---

### Opciones para tener GNU/Linux

Dependiendo de tu equipo y nivel de experiencia, tienes tres caminos principales:

#### 🔵 Opción A — Instalación nativa (Dual Boot)
La opción más completa. Windows y Ubuntu coexisten en el mismo disco.

**Pasos resumidos:**
1. Descargar la imagen ISO de Ubuntu LTS desde [ubuntu.com](https://www.ubuntu.com/)
2. Crear un USB booteable con **Rufus** (Windows) o **Etcher** (multiplataforma)
3. Instalar Windows primero (si usas dual boot), luego Ubuntu
4. Durante la instalación de Ubuntu, asignar al menos **25 GB** de espacio en disco

> ⚠️ **LTS = Long Term Support**: Ubuntu ofrece versiones LTS con 5 años de soporte de seguridad. Para bioinformática, **siempre elige la versión LTS más reciente** (actualmente Ubuntu 24.04 LTS).

**Requisitos mínimos de hardware:**
```
CPU:  2 GHz dual-core (recomendado: 4 núcleos+)
RAM:  4 GB (recomendado: 8 GB+ para análisis bioinformáticos)
Disco: 25 GB libres (recomendado: 50 GB+ para datos genómicos)
```

---

#### 🟡 Opción B — Máquina Virtual (VirtualBox)
Instala Ubuntu dentro de Windows como un programa más. Ideal si no quieres modificar tu disco.

**Desventajas para bioinformática:**
- Rendimiento reducido (la VM comparte recursos con Windows)
- No recomendado para análisis con archivos grandes (>10 GB)
- Para comenzar a aprender: perfecta opción

**Pasos básicos en VirtualBox:**
1. Descargar VirtualBox desde [virtualbox.org](https://www.virtualbox.org/)
2. Crear nueva máquina → tipo Linux → Ubuntu 64-bit
3. Asignar **8 GB de RAM** y **4 CPUs** (ajustar según tu equipo)
4. Crear disco virtual de **25 GB** o más
5. Cargar la imagen ISO de Ubuntu y arrancar

> 💡 **Tip:** En VirtualBox, asigna el 50% de tu RAM disponible. Si tienes 16 GB, asigna 8 GB a la VM.

---

#### 🟢 Opción C — WSL2 (Windows Subsystem for Linux)
La opción más rápida para usuarios de Windows. Ubuntu corre integrado dentro de Windows 10/11 sin reiniciar.

**Instalación desde PowerShell (como administrador):**
```powershell
wsl --install -d Ubuntu-22.04
```

**Ventajas para empezar:**
- Sin reiniciar el equipo
- Acceso directo a archivos de Windows desde Linux
- Ideal para practicar comandos y aprender Conda

**Limitación importante:**
- No es recomendado para análisis que requieran GUI de Linux (visualizadores genómicos)
- Para trabajo serio: usar WSL2 + Windows Terminal + VS Code con extensión Remote-WSL

---

### La Terminal: tu principal herramienta

La **terminal** (también llamada consola o emulador de terminal) es la ventana que te permite comunicarte con el sistema operativo mediante texto.

```bash
# Así se ve el prompt de la terminal en Ubuntu:
usuario@nombre-equipo:~$
```

**Anatomía del prompt:**
```
usuario       → tu nombre de usuario en el sistema
@             → separador
nombre-equipo → nombre de tu computadora (hostname)
:             → separador
~             → directorio actual (~ = carpeta home)
$             → indica que eres usuario normal (# = superusuario/root)
```

**Atajos esenciales de la terminal:**

| Atajo | Función |
|-------|---------|
| `Tab` | Autocompletar nombres de archivos y comandos |
| `↑ / ↓` | Navegar por el historial de comandos |
| `Ctrl + C` | Cancelar el comando en ejecución |
| `Ctrl + L` | Limpiar la pantalla (equivale a `clear`) |
| `Ctrl + D` | Cerrar sesión / señal de fin de archivo (EOF) |
| `Ctrl + A` | Ir al inicio de la línea |
| `Ctrl + E` | Ir al final de la línea |

---

## 2. 💻 Interfaz de Línea de Comandos (CLI)

La CLI (Command Line Interface) es la forma de interactuar con el sistema mediante comandos escritos. En bioinformática, dominar la CLI es **fundamental**: la mayoría de herramientas (BLAST, BWA, SAMtools, FastQC…) solo tienen interfaz de comandos.

### Anatomía de un comando

```
comando   [opciones]   [argumentos]
   │           │            │
   │           │            └─ sobre qué actúa (archivo, directorio, etc.)
   │           └─ modifican el comportamiento (-h, -v, --help)
   └─ el programa a ejecutar
```

**Ejemplo:**
```bash
ls    -lh    /home/usuario/datos/
│      │         │
│      │         └─ argumento: directorio a listar
│      └─ opciones: -l (formato largo) -h (tamaño legible)
└─ comando: listar archivos
```

---

### Comandos fundamentales

#### Navegación y sistema

```bash
# ¿Dónde estoy? (Print Working Directory)
pwd
# Salida: /home/manuel

# Listar archivos del directorio actual
ls

# Listar con detalles y tamaños legibles
ls -lh

# Listar también archivos ocultos
ls -la

# Cambiar de directorio
cd /home/manuel/datos/

# Volver al directorio anterior
cd ..

# Volver al home directamente
cd ~
# o simplemente:
cd

# Crear un directorio nuevo
mkdir analisis_01

# Crear directorios anidados de una vez
mkdir -p proyecto/datos/raw
```

---

#### Monitoreo del sistema (útil en servidores bioinformáticos)

```bash
# Ver procesos activos en tiempo real (q para salir)
top

# Versión mejorada y colorida (instalar: sudo apt install htop)
htop

# Ver espacio en disco (disk free)
df -h
# Salida ejemplo:
# Filesystem      Size  Used Avail Use% Mounted on
# /dev/sda1       100G   45G   55G  45% /

# Ver memoria RAM libre
free -h

# Ver historial de comandos ejecutados
history

# Ver historial filtrado (todos los comandos con "conda")
history | grep conda

# Limpiar pantalla
clear
```

---

#### El comando `cat` — El navaja suiza del texto

`cat` (concatenate) permite crear, ver, combinar y redirigir archivos de texto. En bioinformática se usa constantemente con archivos FASTA, FASTQ, VCF, etc.

```bash
# Ver el contenido de un archivo
cat secuencia.fasta

# Crear un archivo de texto desde la terminal
cat > mi_archivo.txt
# Escribe línea por línea, presiona Ctrl+D para terminar

# Crear un archivo FASTA de ejemplo
cat > gen_01.fasta
>gen_01 hypothetical protein
ATGCGGAATCGATCGATCGATCGA
# Ctrl+D para guardar

# Ver el archivo recién creado
cat gen_01.fasta

# Concatenar dos archivos FASTA en uno solo ← muy común en bioinformática
cat gen_01.fasta gen_02.fasta > genes_combinados.fasta

# Usar wildcard (*) para combinar todos los FASTA de un directorio
cat *.fasta > todos_los_genes.fasta

# Ver información del kernel de Linux
cat /proc/version

# Ver información de la CPU (útil al conectarte a un servidor)
cat /proc/cpuinfo | grep "model name"
```

---

#### Comandos de usuario y sesión

```bash
# ¿Con qué usuario estoy conectado?
whoami

# ¿Quién más está conectado en este sistema? (útil en servidores compartidos)
who

# Ver fecha y hora actual
date

# Cerrar la sesión de terminal
exit
```

---

### Redirección: el flujo de datos en la terminal

Uno de los conceptos más poderosos de la CLI es la **redirección**:

```bash
# > redirige la salida a un archivo (sobrescribe)
ls -lh > lista_archivos.txt

# >> agrega al final de un archivo (no sobrescribe)
echo "nueva línea" >> lista_archivos.txt

# | (pipe) pasa la salida de un comando como entrada al siguiente
cat /proc/cpuinfo | grep "model name"

# Ejemplo bioinformático: contar cuántas secuencias tiene un FASTA
grep -c "^>" secuencias.fasta
```

---

### Ejemplo práctico: trabajar con archivos FASTA en la terminal

```bash
# Crear carpeta de trabajo
mkdir -p ~/practica_s02/secuencias
cd ~/practica_s02/secuencias

# Crear dos secuencias FASTA de ejemplo
cat > gen_01.fasta
>gen_01 hypothetical protein Escherichia coli
ATGCGGAATCGATCGATCG
# Ctrl+D

cat > gen_02.fasta
>gen_02 ribosomal protein Salmonella enterica
CCGCATTAGCTAGCTAGCT
# Ctrl+D

# Ver cada archivo
cat gen_01.fasta
cat gen_02.fasta

# Combinar ambos en un solo archivo multiFASTA
cat gen_01.fasta gen_02.fasta > genes.fasta

# Verificar el resultado
cat genes.fasta
ls -lh

# Contar cuántas secuencias hay en el multiFASTA
grep -c "^>" genes.fasta
```

---

## 3. 📂 Localización de Comandos y Sistema de Archivos

### Estructura del sistema de archivos en GNU/Linux

A diferencia de Windows (que organiza por unidades: C:, D:), Linux tiene **un único árbol de directorios** que parte de la raíz `/`:

```
/                          ← raíz del sistema (root)
├── bin/                   ← programas esenciales del sistema
├── usr/
│   └── bin/               ← programas de usuario
├── home/
│   └── manuel/            ← tu directorio personal (~)
│       ├── datos/
│       ├── scripts/
│       └── resultados/
├── etc/                   ← archivos de configuración
├── tmp/                   ← archivos temporales
├── var/                   ← logs y datos variables
└── opt/                   ← software adicional de terceros
```

### Directorios clave para bioinformática

| Directorio | Contenido | Relevancia bioinformática |
|---|---|---|
| `/bin` | Programas esenciales del SO | `cat`, `ls`, `grep`, `awk` |
| `/usr/bin` | Programas instalados para usuarios | Python, Perl, herramientas del sistema |
| `/home/usuario/` | Tu espacio de trabajo | Aquí guardas scripts, datos, resultados |
| `/opt/` | Software externo grande | A veces GATK, databases de BLAST |
| `/tmp/` | Archivos temporales | Cuidado: se borra al reiniciar |

```bash
# Ver qué hay en /bin (comandos del sistema)
ls /bin | head -20

# Ver qué hay en /usr/bin
ls /usr/bin | head -20

# Buscar dónde está instalado un programa
which python
which conda
which samtools
```

---

### Rutas absolutas vs. relativas

```bash
# Ruta ABSOLUTA: parte siempre desde la raíz /
cd /home/manuel/practica_s02/secuencias

# Ruta RELATIVA: parte desde donde estás ahora
# (si estás en /home/manuel/)
cd practica_s02/secuencias

# Símbolos útiles
.   # directorio actual
..  # directorio padre
~   # tu directorio home (/home/tu_usuario)
```

---

## 4. 🐍 Instalación y Administración con Conda

### ¿Qué es Conda y por qué es esencial en bioinformática?

**Conda** es simultáneamente un **gestor de paquetes** y un **gestor de entornos**. Fue creado originalmente para resolver el problema de las dependencias en proyectos de ciencia de datos, y hoy es el estándar de facto en bioinformática.

**El problema que Conda resuelve:**

Imagina que quieres instalar dos herramientas:
- `HerramientaA` → requiere Python 2.7
- `HerramientaB` → requiere Python 3.11

Sin Conda, estas dos versiones conflictúan. Con Conda, cada herramienta vive en su propio **entorno aislado**.

```
Sistema operativo
└── Conda (gestor)
    ├── base          (Python 3.11, paquetes básicos)
    ├── samtools_env  (SAMtools 1.19, htslib...)
    ├── qc_env        (FastQC, Trimmomatic...)
    └── assembly_env  (SPAdes, QUAST, Python 3.9...)
```

---

### Conda vs. Miniconda vs. Anaconda

```
┌─────────────────────────────────────────────────────────────┐
│                        ANACONDA                             │
│   (Miniconda + 150 paquetes científicos pre-instalados)    │
│   Tamaño: ~3 GB   │   Para: usuarios que quieren todo      │
│                                                             │
│   ┌─────────────────────────────────────────────────────┐  │
│   │                    MINICONDA                        │  │
│   │   (Conda + Python + paquetes base)                  │  │
│   │   Tamaño: ~400 MB   │   ✅ Recomendado              │  │
│   │                                                     │  │
│   │   ┌─────────────────────────────────────────────┐  │  │
│   │   │                  CONDA                      │  │  │
│   │   │   (Solo el gestor, sin Python)              │  │  │
│   │   └─────────────────────────────────────────────┘  │  │
│   └─────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

> ✅ **Recomendación:** Instala **Miniconda** y agrega solo lo que necesites. Es más limpio y eficiente para bioinformática.

---

### Instalación de Miniconda en GNU/Linux

```bash
# 1. Crear el directorio de instalación
mkdir -p ~/miniconda3

# 2. Descargar el instalador
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
     -O ~/miniconda3/miniconda.sh

# 3. Ejecutar el instalador en modo silencioso
bash ~/miniconda3/miniconda.sh -b -u ~/miniconda3

# 4. Eliminar el instalador (ya no lo necesitas)
rm -f ~/miniconda3/miniconda.sh

# 5. Inicializar conda en bash (solo se hace una vez)
~/miniconda3/bin/conda init bash

# 6. Recargar la configuración del shell
source ~/.bashrc

# 7. Verificar la instalación
conda --version
# Salida esperada: conda 24.x.x
```

> Después del paso 5, notarás que tu prompt cambia a: `(base) usuario@equipo:~$`  
> El prefijo `(base)` indica que estás en el entorno base de conda.

---

### Canales de Conda

Los **canales** son repositorios donde Conda busca paquetes. Para bioinformática, hay tres canales esenciales:

```
Canal           Contenido principal
────────────────────────────────────────────────────
defaults        Paquetes oficiales de Anaconda
conda-forge     Paquetes de la comunidad (muy completo)
bioconda        ← EL canal de bioinformática 🧬
                Más de 9,000 herramientas: SAMtools,
                BWA, GATK, FastQC, Trimmomatic, etc.
```

**Configurar los canales (ejecutar una sola vez):**

```bash
conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge

# Verificar la configuración
conda config --get channels
```

> ⚠️ **Orden importa:** conda-forge debe quedar con la **mayor prioridad**. El orden de los comandos anteriores lo garantiza.

---

### Comandos esenciales de Conda

```bash
# ── INFORMACIÓN ──────────────────────────────────────
conda --version                  # Versión de conda instalada
conda info                       # Información del entorno actual
conda env list                   # Listar todos los entornos
conda list                       # Paquetes instalados en el entorno activo

# ── BUSCAR PAQUETES ──────────────────────────────────
conda search samtools            # Buscar versiones disponibles
conda search -c bioconda fastqc  # Buscar en canal específico

# ── CREAR Y GESTIONAR ENTORNOS ───────────────────────
# Crear entorno con un paquete específico
conda create -n samtools -c bioconda samtools=1.19.2

# Crear entorno con Python específico + múltiples paquetes
conda create -n qc_tools python=3.11 fastqc trimmomatic

# Activar un entorno
conda activate samtools

# Desactivar (volver a base)
conda deactivate

# Eliminar un entorno
conda env remove -n nombre_entorno

# ── INSTALAR / ACTUALIZAR / ELIMINAR PAQUETES ────────
conda install -c bioconda bwa        # Instalar en entorno activo
conda update samtools                # Actualizar paquete
conda remove samtools                # Eliminar paquete

# ── MANTENIMIENTO ────────────────────────────────────
conda clean --all                    # Limpiar caché y paquetes viejos
conda update conda                   # Actualizar conda mismo
```

---

### Práctica guiada: Instalar herramientas bioinformáticas

#### Ejercicio 1 — SAMtools (procesamiento de alineamientos)

```bash
# Buscar versiones disponibles
conda search -c bioconda samtools

# Crear entorno dedicado e instalar
conda create -n samtools -c bioconda samtools=1.19.2

# Verificar que se creó
conda env list

# Activar y usar
conda activate samtools
samtools --version

# Probar un comando básico
samtools --help

# Salir del entorno
conda deactivate
```

#### Ejercicio 2 — FastQC (control de calidad de secuencias)

```bash
# Crear entorno para herramientas de QC
conda create -n bio_01 -c bioconda fastqc

conda activate bio_01
fastqc --version

conda deactivate
```

#### Ejercicio 3 — Trimmomatic (filtrado de lecturas)

```bash
# Crear entorno separado
conda create -n bio_02 -c bioconda trimmomatic

conda activate bio_02
trimmomatic -version

conda deactivate
```

---

### ¿Por qué un entorno por herramienta?

```
❌ MAL ENFOQUE: todo en base
(base) conda install samtools fastqc trimmomatic gatk bwa spades
→ Conflictos de dependencias, imposible reproducir el análisis

✅ BUEN ENFOQUE: entornos separados
(samtools_env)   → SAMtools 1.19
(qc_env)         → FastQC 0.12 + Trimmomatic 0.39
(assembly_env)   → SPAdes 3.15 + Python 3.9
(variant_env)    → GATK 4.4 + Picard 3.1
```

**Beneficios:**
- **Reproducibilidad:** puedes exportar y compartir el entorno exacto
- **Sin conflictos:** cada herramienta tiene sus dependencias aisladas
- **Organización:** sabes exactamente qué herramientas usaste en cada análisis

---

## 🔄 Pipeline bioinformático típico con Conda

Este es el flujo que usarás en análisis reales de secuenciación:

```
Datos crudos (.fastq)
        │
        ▼
  [Entorno: bio_01]
    FastQC           ← Control de calidad inicial
        │
        ▼
  [Entorno: bio_02]
    Trimmomatic      ← Filtrado y recorte de adaptadores
        │
        ▼
  [Entorno: mapping_env]
    BWA + SAMtools   ← Mapeo al genoma de referencia
        │
        ▼
  [Entorno: variant_env]
    GATK             ← Llamado de variantes (.vcf)
        │
        ▼
  Resultados finales (variantes, estadísticas, reportes)
```

---

## 📖 Glosario

| Término | Definición |
|---------|-----------|
| **Terminal** | Programa que provee acceso al shell mediante una interfaz de texto |
| **Shell** | Intérprete de comandos (Bash es el más común en GNU/Linux) |
| **CLI** | Command Line Interface — interfaz de línea de comandos |
| **LTS** | Long Term Support — versión con soporte extendido (5 años en Ubuntu) |
| **Dual Boot** | Configuración donde coexisten dos sistemas operativos en el mismo equipo |
| **VM** | Virtual Machine — sistema operativo que corre dentro de otro sistema |
| **WSL2** | Windows Subsystem for Linux 2 — capa de compatibilidad de Linux en Windows |
| **Conda** | Gestor de paquetes y entornos virtuales |
| **Entorno virtual** | Espacio aislado con su propio Python y paquetes, sin afectar al sistema |
| **Canal (Conda)** | Repositorio desde donde Conda descarga paquetes |
| **Bioconda** | Canal de Conda especializado en herramientas bioinformáticas |
| **PATH** | Variable del sistema que lista los directorios donde buscar comandos |
| **FASTA** | Formato de texto para representar secuencias biológicas (ADN, proteínas) |
| **SAMtools** | Suite de herramientas para manipular archivos de alineamiento (SAM/BAM) |
| **FastQC** | Herramienta de control de calidad para datos de secuenciación masiva |
| **Trimmomatic** | Herramienta para filtrado y recorte de lecturas de secuenciación |

---

## 🧠 Autoevaluación

Responde las siguientes preguntas para verificar tu comprensión:

**Conceptuales:**
1. ¿Por qué GNU/Linux es el sistema operativo dominante en bioinformática? Menciona al menos 3 razones.
2. Explica la diferencia entre una ruta absoluta y una relativa. Da un ejemplo de cada una.
3. ¿Qué ventaja tiene Conda frente a instalar programas directamente con `apt-get`?
4. ¿Por qué es mejor práctica crear un entorno Conda por herramienta en lugar de instalar todo en `base`?

**Prácticas:**
5. ¿Qué comando usarías para saber cuántos archivos `.fasta` hay en tu directorio actual?
6. Escribe el comando para crear un entorno Conda llamado `blast_env` con la versión 2.14.0 de BLAST desde el canal bioconda.
7. Tienes dos archivos: `muestra_01.fastq` y `muestra_02.fastq`. ¿Cómo los combinarías en un solo archivo llamado `todas_muestras.fastq`?
8. Describe el significado de cada parte del prompt: `(bio_01) manuel@servidor-upc:~/datos$`

**Reflexión:**
9. ¿Cuál de las tres opciones de instalación de Ubuntu (nativa, VM, WSL2) elegirías para tu flujo de trabajo personal? Justifica tu respuesta.
10. En un servidor de bioinformática compartido con 20 investigadores, ¿por qué es importante usar entornos Conda separados para cada proyecto?

---

## 🎯 Actividad Asincrónica

**Instrucciones:**

1. Instalar **FastQC** con Conda en el entorno `bio_01`
2. Instalar **Trimmomatic** con Conda en el entorno `bio_02`
3. Realizar un documento que incluya:
   - Cada comando ejecutado, en orden
   - Una captura de pantalla por cada paso importante
   - Una breve explicación de qué hace cada comando

**Comandos de referencia:**
```bash
# FastQC en bio_01
conda create -n bio_01 -c bioconda fastqc
conda activate bio_01
fastqc --version
conda deactivate

# Trimmomatic en bio_02
conda create -n bio_02 -c bioconda trimmomatic
conda activate bio_02
trimmomatic -version
conda deactivate

# Verificar ambos entornos
conda env list
```

---

## 📚 Referencias y Recursos

**Bibliografía del curso:**
- Blum, R., & Bresnahan, C. (2021). *Linux command line and Shell scripting bible* (4th ed.). Wiley. Capítulos 1 y 2.

**Recursos en línea:**
- [Documentación oficial de Conda](https://docs.conda.io/)
- [Bioconda — Canal de bioinformática](https://bioconda.github.io/)
- [Tutorial de Conda para bioinformática](https://angus.readthedocs.io/en/2019/conda_tutorial.html)
- [The Linux Command Line (libro libre)](https://linuxcommand.org/tlcl.php)
- [Ubuntu Server Guide](https://ubuntu.com/server/docs)
- [Miniconda instaladores](https://docs.conda.io/en/latest/miniconda.html)

**Para profundizar:**
- [Codecademy — Learn the Command Line](https://www.codecademy.com/learn/learn-the-command-line)
- [Software Carpentry — The Unix Shell](https://swcarpentry.github.io/shell-novice/)

---

## 🔗 Navegación del Curso

| | Sesión | Tema |
|--|--------|------|
| ⬅️ Anterior | [Sesión 01](../session_01/) | Sistemas Operativos |
| 📍 Actual | **Sesión 02** | Ambiente de Trabajo |
| ➡️ Siguiente | [Sesión 03](../session_03/) | Estructura de Directorios y Gestión de Archivos |

---

<div align="center">

**Universidad Peruana de Ciencias Aplicadas — UPC**  
Facultad de Ciencias de la Salud | Programa de Biología  
*Exígete, innova*

</div>
