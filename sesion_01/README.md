# 📘 Sesión 01 — Sistema Operativo

> **Curso:** 1ABL0014 · Principios de Programación en Bioinformática
> **Unidad:** I — Introducción a GNU/Linux
> **Duración:** 230 minutos
> **Referencia:** Hausenblas, M. (2022). *Learning Modern Linux*. O'Reilly. Cap. 1 y 2.

---

## Logro de la sesión

Al finalizar la sesión, el estudiante conoce la estructura básica de un sistema operativo, sus principales componentes y sus diferentes distribuciones.

---

## Saberes previos

Antes de comenzar, reflexiona:

1. ¿Qué expectativas tienes con respecto al curso?
2. ¿Qué tipos de sistema operativo conoces?

> La mayoría de estudiantes de biología conoce Windows y quizás macOS. Al terminar este curso, Linux será tu tercer sistema operativo y el más importante para tu carrera bioinformática.

---

## Agenda de la sesión

```
1. Introducción a los Sistemas Operativos
2. Estructura y principales funciones
3. Sistema Operativo clave en Bioinformática
4. Distribuciones del Sistema Operativo GNU/Linux
5. Actividad práctica — Google Cloud Shell + NCBI
```

---

## 1. Introducción a los Sistemas Operativos

### Funciones básicas de un computador

Un computador realiza cuatro funciones básicas (Tanenbaum, 2016):

| Función | Descripción | Ejemplo en bioinformática |
|---------|-------------|--------------------------|
| **Procesamiento** | Ejecuta cálculos y operaciones lógicas | Alinear millones de lecturas de ADN contra un genoma |
| **Almacenamiento** | Guarda datos temporal o permanentemente | Guardar un genoma completo (~3 GB en formato FASTA) |
| **Movimiento de datos** | Transfiere información entre componentes | Descargar datos de NCBI, transferir archivos al servidor |
| **Control de procesos** | Coordina la ejecución de instrucciones | Gestionar varios análisis corriendo simultáneamente |

### Hardware vs. Software

| | Hardware | Software |
|-|----------|----------|
| **Definición** | Componentes físicos que podemos tocar | Programas, instrucciones y datos; no tiene forma física |
| **Ejemplos** | CPU, RAM, disco duro, teclado, pantalla | Sistema operativo, aplicaciones, scripts |
| **Rol** | La maquinaria | Las instrucciones para la maquinaria |

### ¿Qué es un Sistema Operativo?

Un sistema operativo es un tipo especial de software que actúa como intermediario entre el hardware y las aplicaciones que usamos.

**Analogía:** El hardware son los músicos, las aplicaciones son las melodías que se quieren tocar, y el sistema operativo es el director de orquesta que coordina a todos para que la música suene armoniosamente.

### Sistemas operativos más usados en escritorio (2023)

| Sistema Operativo | Cuota de mercado |
|------------------|-----------------|
| Windows | 69.43% |
| macOS (OS X) | 17.2% |
| Linux | 2.86% |
| Chrome OS | 3.24% |

> Aunque Linux tiene ~3% en escritorio, domina en **servidores** (más del 96%), **supercomputadoras** (100% del Top500) y dispositivos embebidos. Para bioinformática, Linux es el sistema por excelencia.

---

## 2. Estructura y principales funciones

### El núcleo (Kernel)

El kernel es el corazón del sistema operativo. Controla tanto el hardware como el software del sistema.

```
        [ HARDWARE ]   CPU, RAM, disco, periféricos
              |
           [ KERNEL ]  <- corazón del sistema
              |
          [ SOFTWARE ] aplicaciones, scripts, Shell
```

Las cuatro funciones del kernel:

| Función | Relevancia bioinformática |
|---------|--------------------------|
| Administración de memoria (RAM) | Al correr BWA o STAR, el kernel gestiona cuánta RAM usa cada proceso |
| Administración de procesos (multitarea) | Correr FastQC, Trimmomatic y BWA simultáneamente |
| Administración de hardware (E/S) | Leer archivos del disco, transferir datos por red |
| Administración del sistema de archivos | Gestionar cientos de archivos FASTQ, BAM, VCF |

> Sin un kernel eficiente, el sistema operativo sería inestable, lento e inusable.

---

### Terminal — La interfaz de línea de comandos (CLI)

La terminal de Linux es una ventana donde los usuarios interactúan con el sistema operativo escribiendo comandos de texto. Es similar al CMD o PowerShell de Windows, pero mucho más potente.

En Linux existen dos tipos de interfaz:

| Interfaz | Nombre | Descripción |
|---------|--------|-------------|
| **CLI** | Command Line Interface | Terminal, texto puro |
| **GUI** | Graphical User Interface | Escritorio con íconos y ventanas |

**Comparación GUI vs CLI:**

| Característica | GUI | CLI |
|---------------|-----|-----|
| Facilidad inicial | Intuitiva para principiantes | Requiere aprender comandos |
| Velocidad de trabajo | Más lenta (usa ratón) | Más rápida (solo teclado) |
| Uso de memoria RAM | Alta | Muy baja |
| Automatización | Difícil | Scripting ilimitado |
| Precisión | Baja | Alta |
| Acceso a servidores HPC | No disponible | Es la única opción |

> En bioinformática, el 90% del trabajo se hace en CLI. Los servidores de cómputo no tienen pantalla ni escritorio; solo terminal.

---

### El Shell — El intérprete de comandos

El Shell actúa como interfaz entre el usuario y el kernel.

```
  Usuario escribe: ls -lh /home/
         |
      [ SHELL ]   <- traduce el lenguaje humano a instrucciones del kernel
         |
      [ KERNEL ]  <- ejecuta la instrucción con el hardware
         |
  Resultado: lista de archivos con detalles
```

> Podemos pensar en el shell como un traductor: el usuario escribe un comando en lenguaje de comandos, y el shell lo traduce a instrucciones que el kernel puede entender.

Cuando ves el símbolo `$` en la terminal, el Shell está esperando un comando.

### Tipos de Shell

| Shell | Nombre completo | Símbolo | Descripción |
|-------|----------------|---------|-------------|
| **sh** | Bourne Shell | `$` | El clásico estándar UNIX/Linux |
| **bash** | Bourne Again Shell | `$` | **El que usaremos en este curso.** Shell GNU, el más común en Linux |
| **ksh** | Korn Shell | `$` | Amplía sh con historial y edición de línea |
| **csh** | C-Shell | `%` | Orientado a programadores en C |
| **jsh** | Job Shell | `$` | Agrega control de trabajos al sh estándar |

Para bioinformática usamos **Bash**. Es el shell por defecto en Ubuntu, Debian y la mayoría de servidores Linux. Los scripts siempre comienzan con `#!/bin/bash`.

---

## 3. Sistema Operativo clave en Bioinformática

### Requerimientos en bioinformática

| Nivel | Conocimiento |
|-------|-------------|
| Necesario | Dogma central de la Biología Molecular |
| Necesario | Biología Molecular (bioquímica, biofísica molecular) |
| Muy necesario | Manejo de sistemas de cómputo |
| Recomendado | Manejo básico de línea de comandos en UNIX/Linux |
| Muy deseable | Experiencia con algún lenguaje de programación |

> Este curso te lleva del nivel "Recomendado" al "Muy deseable". Cuando termines, podrás ejecutar cualquier pipeline bioinformático que encuentres en la literatura.

---

### ¿Por qué GNU/Linux en Bioinformática?

#### El formato FASTA: el estándar de la bioinformática

En bioinformática, el formato FASTA es el estándar casi universal para representar secuencias de nucleótidos o aminoácidos. Los nucleótidos o aminoácidos se representan mediante códigos de una sola letra.

```
>NC_000001.11 Homo sapiens chromosome 1, GRCh38.p14
TAACCCTAACCCTAACCCTAACCCTAACCCTAACCCTAACCCTAACCCTAACCCTAACCCTAACCCTAACC
...
[millones de líneas]
```

#### El problema con Windows

Intentar abrir un archivo FASTA grande o un archivo de expresión génica en el Bloc de Notas de Windows puede resultar imposible por limitaciones en el tamaño de los archivos.

La simplicidad del formato FASTA facilita su manipulación y análisis usando herramientas de procesamiento de texto disponibles en Linux y lenguajes de scripting como R y Python.

#### Lo que Linux te permite hacer con una línea:

```bash
# Contar el numero de secuencias en un FASTA
grep -c "^>" genoma.fna

# Ver los encabezados de las primeras 5 secuencias
grep "^>" genoma.fna | head -5

# Extraer solo las secuencias (sin encabezados)
grep -v "^>" genoma.fna > solo_secuencias.txt
```

---

### Herramientas bioinformáticas que viven en Linux

| Herramienta | Para qué sirve |
|-------------|---------------|
| FastQC | Control de calidad de reads de secuenciación |
| Trimmomatic | Limpieza y recorte de reads |
| BWA / Bowtie2 | Alineamiento de secuencias cortas |
| STAR | Alineamiento de RNA-seq |
| SAMtools | Manipulación de archivos BAM/SAM |
| GATK | Llamado de variantes genómicas |
| SPAdes | Ensamblaje de genomas bacterianos |
| Conda/Bioconda | Gestor de entornos y herramientas bioinformáticas |

---

## 4. Distribuciones de GNU/Linux

### Breve historia

```
1969 Unix creado en AT&T Bell Labs (Ken Thompson, Dennis Ritchie)
1983 Richard Stallman lanza el proyecto GNU (herramientas de codigo libre)
1991 Linus Torvalds escribe el kernel Linux y lo publica en internet
1992 Primeras distribuciones GNU/Linux (kernel + herramientas GNU)
Hoy  Cientos de distribuciones, millones de usuarios
```

### Características clave de GNU/Linux

- Gratuito
- Código libre, abierto e independiente
- Muy estable
- Altamente seguro
- Multitarea y multiusuario

### Familias de distribuciones

```
            LINUX KERNEL
                 |
    ┌────────────┼────────────┐
    |            |            |
  DEBIAN      RED HAT      OTRAS
  --------    --------    --------
  Debian      Red Hat     Slackware
  Ubuntu      CentOS      Gentoo
  Linux Mint  Fedora      OpenSUSE
  Kali Linux  Rocky Linux Arch Linux
  Raspbian
```

### ¿Cuál usar en bioinformática?

| Distribución | Recomendación |
|-------------|--------------|
| **Ubuntu** | La mejor opción para principiantes y bioinformática general. La más documentada, con mayor comunidad |
| Debian | Servidores estables, base de Ubuntu |
| CentOS / Rocky Linux | Servidores institucionales y HPC |

> Para este curso usaremos Ubuntu (vía Google Cloud Shell o WSL2). Es el estándar de facto para bioinformática educativa.

---

## 5. Actividad práctica — Terminal y primeros comandos

### Acceso mediante Google Cloud Shell

1. Ir a [shell.cloud.google.com](https://shell.cloud.google.com) o a la consola de Google Cloud
2. Hacer clic en el ícono de terminal `>_`
3. Hacer clic en **"Activar Cloud Shell"**
4. Hacer clic en **"Autorizar"**
5. Verás el prompt: `usuario@cloudshell:~$`

### Anatomía del prompt de Linux

```
mramirezupc@cloudshell:~$
|            |          |└── simbolo del prompt ($ = usuario normal)
|            |          └─── directorio actual (~ = carpeta home)
|            └──────────── nombre del servidor/maquina
└───────────────────────── nombre de usuario
```

---

### Comandos de esta sesión

#### Estructura general de un comando

```bash
comando  -opcion  argumento
   ls      -lh    /home/usuario/
```

> Regla de oro: Linux distingue mayusculas de minusculas. ls ≠ LS ≠ Ls

---

#### echo $PATH — Ver donde busca el Shell los comandos

```bash
echo $PATH
# Resultado: /usr/local/bin:/usr/bin:/bin:/usr/local/sbin
```

---

#### mkdir — Crear una carpeta

```bash
mkdir human_genome_hg38
mkdir -p analisis/datos/crudos   # con subcarpetas de un solo golpe
```

---

#### wget — Descargar archivos desde internet

```bash
# Descarga basica
wget https://url-del-archivo.gz

# Descargar en una carpeta especifica
wget -P carpeta_destino/ https://url-del-archivo.gz
```

wget muestra: progreso, velocidad, tamaño, fecha y hora.

---

#### cd — Cambiar de directorio

```bash
cd human_genome_hg38/     # entrar a la carpeta
cd ..                      # subir un nivel
cd ~                       # ir a la carpeta home
```

---

#### ls — Listar contenido de un directorio

```bash
ls                    # listar archivos
ls -l                 # con detalles (permisos, tamaño, fecha)
ls -h                 # tamaños legibles (KB, MB, GB)
ls -lh                # combinado: detallado + legible
```

---

#### gzip — Comprimir y descomprimir archivos

```bash
gzip -d archivo.fna.gz    # descomprimir
gzip archivo.fna          # comprimir
```

> Casi todos los archivos bioinformaticos grandes se distribuyen comprimidos con gzip (.gz).

---

#### grep — Buscar patrones en archivos de texto

```bash
grep ">" archivo.fna                    # lineas que contienen ">"
grep -c ">" archivo.fna                 # contar secuencias en FASTA
grep -v ">" archivo.fna | wc -c         # contar bases del genoma
```

---

### Pipeline completo de la practica

```bash
# 1. Crear directorio de trabajo
mkdir human_genome_hg38

# 2. Descargar el genoma humano (GRCh38)
wget -P human_genome_hg38/ \
  https://ftp.ncbi.nlm.nih.gov/refseq/H_sapiens/annotation/GRCh38_latest/refseq_identifiers/GRCh38_latest_genomic.fna.gz

# 3. Entrar al directorio
cd human_genome_hg38/

# 4. Ver el archivo comprimido
ls -lh

# 5. Descomprimir
gzip -d GRCh38_latest_genomic.fna.gz

# 6. Ver el archivo descomprimido
ls -lh

# 7. Contar el numero de bases del genoma
grep -v ">" GRCh38_latest_genomic.fna | wc -c
```

> El genoma humano tiene aproximadamente 3,200 millones de pares de bases. El archivo descomprimido pesa ~3 GB. Esto ilustra por que Linux es imprescindible en bioinformatica.

---

### El recurso NCBI — Human Genome Resources

URL: [https://www.ncbi.nlm.nih.gov/genome/guide/human/](https://www.ncbi.nlm.nih.gov/genome/guide/human/)

| Archivo | Formato | Para que sirve |
|---------|---------|----------------|
| Reference Genome Sequence | FASTA | La secuencia del genoma de referencia |
| RefSeq Genome Annotation | GFF3 | Coordenadas de genes, exones, CDS |
| RefSeq Proteins | FASTA | Secuencias de todas las proteinas |
| ClinVar | VCF | Variantes con significado clinico |
| dbSNP | VCF | Polimorfismos de nucleotido simple |
| dbVar | VCF | Variantes estructurales del genoma |

**Versiones del genoma humano:**
- GRCh38 (hg38): version actual, recomendada para nuevos proyectos
- GRCh37 (hg19): version anterior, aun usada en algunos estudios clinicos

---

## Actividad asincrónica

### Tarea para entregar en Blackboard

**Objetivo:** Practicar descargas de archivos desde NCBI usando `wget`.

**Instrucciones:**
1. Accede a [https://www.ncbi.nlm.nih.gov/genome/guide/human/](https://www.ncbi.nlm.nih.gov/genome/guide/human/)
2. Descarga los siguientes archivos del genoma humano (GRCh38):
   - Anotacion del genoma (GFF3)
   - Proteinas RefSeq (FASTA)
   - Variantes estructurales dbVar (VCF)
3. Usa el comando: `wget -P carpeta/ URL`
4. Al terminar, ejecuta `history` para ver el historial de comandos
5. Toma una captura de pantalla del historial y enviala en Blackboard

**Tip:** Clic derecho sobre el boton del formato (Fasta/gff3/vcf) → "Copiar direccion del enlace".

---

## Glosario de la sesion

| Concepto | Definicion corta |
|---------|-----------------|
| Sistema Operativo | Software intermediario entre hardware y aplicaciones |
| Kernel | Nucleo del SO; gestiona memoria, procesos, hardware y archivos |
| Terminal | Ventana de texto para interactuar con el SO mediante comandos |
| Shell / Bash | Interprete que traduce comandos del usuario al kernel |
| CLI | Interfaz de linea de comandos (text-based) |
| GUI | Interfaz grafica de usuario (iconos y ventanas) |
| Distribucion Linux | Kernel + herramientas GNU + software para un proposito |
| FASTA | Formato estandar en bioinformatica para secuencias |
| GRCh38 | Version actual del genoma humano de referencia |
| PATH | Variable que indica al shell donde buscar los comandos |
| wget | Comando para descargar archivos desde internet |

---

## Preguntas de autoevaluacion

1. Cual es la diferencia entre hardware y software? Da un ejemplo de cada uno en el contexto de bioinformatica.
2. Que funcion cumple el kernel en un sistema operativo?
3. Por que un bioinformatico prefiere la CLI sobre la GUI?
4. Que ventajas tiene Linux frente a Windows para el analisis de grandes archivos bioinformaticos?
5. Cual es la diferencia entre una distribucion Linux basada en Debian y una basada en Red Hat?
6. Explica que hace el siguiente comando: `grep -v ">" genoma.fna | wc -c`

---

## Referencias

- Hausenblas, M. (2022). *Learning Modern Linux*. O'Reilly Media. Capitulos 1 y 2.
- Tanenbaum, A. S., & Bos, H. (2016). *Modern Operating Systems* (4th ed.). Pearson.
- NCBI Human Genome Resources: https://www.ncbi.nlm.nih.gov/genome/guide/human/

---

## Proxima sesion

**Sesion 02 → Ambiente de trabajo en Linux**

Aprenderás a configurar tu propio entorno Linux: instalacion de Ubuntu en maquina virtual o WSL2, estructura de directorios y primeros comandos de navegacion.

---

*Volver a Sesion 00: ../sesion_00_introduccion/README.md | Inicio del curso: ../README.md*


---

*← [Volver a Sesión 00](../sesion_00_introduccion/README.md) · [Inicio del curso](../README.md)*
