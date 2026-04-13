# Sesión 03 — Sistemas de Archivos

**Curso:** Principios de Programación en Bioinformática (1ABL0014)  
**Programa:** Biología — Facultad de Ciencias de la Salud, UPC  
**Docentes:** Frank Guzman Escudero · Manuel Ramírez Sáenz  
**Semestre:** 2026-1

---

## 🎯 Logro de la sesión

> Al finalizar la sesión, el estudiante conoce la **estructura de directorios** y la **gestión de archivos** en Linux, y es capaz de navegar el sistema de archivos usando rutas absolutas y relativas.

---

## 📋 Agenda

1. [Sistema de archivos y estructura de directorios](#1-sistema-de-archivos)
2. [Rutas absolutas y relativas (paths)](#2-rutas-o-paths)
3. [Tipos de archivos y códigos de colores](#3-tipos-de-archivos)
4. [Práctica guiada](#4-práctica-guiada)
5. [Ejercicios de consolidación](#5-ejercicios-de-consolidación)
6. [Actividad asincrónica](#6-actividad-asincrónica)

---

## Saberes previos

Antes de comenzar, reflexiona:

- ¿Qué experiencia tienes con el uso de comandos en la terminal?
- ¿Cuál crees que es la utilidad de los "accesos directos" o "shortcuts" en tu computadora? ¿Cómo se relacionan con el concepto de enlace simbólico?

---

## 1. Sistema de Archivos

### ¿Qué es un sistema de archivos?

Un **sistema de archivos** (*filesystem*) es la manera en que el sistema operativo organiza y almacena datos en el disco. Su función principal es garantizar que los datos estén estructurados, accesibles y sin errores.

En Linux, el sistema de archivos tiene una estructura **jerárquica en forma de árbol**, cuyo origen es el **directorio raíz**, representado por la barra `/`. Todos los demás directorios y archivos se encuentran por debajo de este punto de partida.

```
/                        ← Directorio raíz (root)
├── bin/                 ← Ejecutables esenciales
├── boot/                ← Archivos de arranque
├── dev/                 ← Dispositivos de hardware
├── etc/                 ← Configuraciones del sistema
├── home/                ← Carpetas personales de usuarios
│   ├── genomics/        ← Ejemplo: usuario "genomics"
│   ├── master/
│   └── ubuntu/
├── lib/                 ← Librerías del sistema
├── media/               ← Unidades externas montadas
├── mnt/                 ← Montajes manuales
├── opt/                 ← Software adicional/opcional
├── proc/                ← Información de procesos activos
├── sbin/                ← Ejecutables del superusuario
├── sys/                 ← Archivos del sistema kernel
├── tmp/                 ← Archivos temporales
├── usr/                 ← Utilidades y programas de usuario
└── var/                 ← Logs y datos variables
```

> 💡 **Analogía:** Piensa en el sistema de archivos como una biblioteca. El directorio raíz `/` es el edificio entero; los subdirectorios (`/home`, `/bin`, etc.) son las salas; y los archivos son los libros dentro de cada sala.

### Directorios clave del sistema

| Directorio | Descripción |
|------------|-------------|
| `/bin`     | Comandos ejecutables disponibles para todos los usuarios (`ls`, `cat`, `cp`, etc.) |
| `/boot`    | Archivos necesarios para iniciar el sistema |
| `/dev`     | Representación de dispositivos de hardware como archivos |
| `/etc`     | Archivos de configuración del sistema |
| `/home`    | Directorio personal de cada usuario (`/home/tu_usuario`) |
| `/lib`     | Librerías necesarias para los programas de `/bin` y `/sbin` |
| `/media`   | Puntos de montaje automáticos (USB, CD/DVD) |
| `/mnt`     | Puntos de montaje manuales |
| `/opt`     | Aplicaciones de software adicional instaladas por el usuario |
| `/proc`    | Información dinámica del estado del sistema y procesos en ejecución |
| `/sbin`    | Ejecutables de administración (solo para el superusuario `root`) |
| `/sys`     | Interfaz al kernel del sistema |
| `/tmp`     | Archivos temporales; se borran al reiniciar |
| `/usr`     | Programas y utilidades de usuario |
| `/var`     | Datos variables: logs, bases de datos, correos del servidor |

### La carpeta home `~`

Cuando abres la terminal, automáticamente te encuentras en tu **carpeta home**: `/home/tu_usuario`. El símbolo `~` (tilde) es un **alias** de esta ruta. Es el espacio de trabajo personal de cada usuario y donde crearás la mayoría de tus proyectos.

```bash
# Estos tres comandos te llevan al mismo lugar:
$ cd /home/genomics
$ cd ~
$ cd          # sin argumentos también va a home
```

---

## 2. Rutas o Paths

### ¿Por qué necesitamos rutas?

Imagina que tienes dos archivos llamados `secuencias.fasta`, uno en `/home/genomics/proyecto_A/` y otro en `/home/genomics/proyecto_B/`. El nombre solo no es suficiente para distinguirlos. La **ruta** (*path*) es la dirección completa y única de un archivo en el sistema.

Los nombres de directorios y archivos se separan con `/` en la ruta.

### Ruta absoluta

Una **ruta absoluta** siempre empieza desde el directorio raíz `/` y especifica la dirección completa hasta el archivo o directorio deseado. No importa dónde estés en el sistema: una ruta absoluta siempre funciona.

```
Formato:  /directorio1/directorio2/.../archivo

Ejemplos:
  /home/genomics/Data/Bacteria/ecoli.fasta
  /usr/local/bin/blast
  /etc/hosts
```

> 📌 **Regla de oro:** Si la ruta empieza con `/`, es **absoluta**.

### Ruta relativa

Una **ruta relativa** se construye a partir de la **posición actual** en el sistema de archivos. Es más corta de escribir, pero cambia según dónde estés.

Para construir rutas relativas se usan dos alias especiales:

| Símbolo | Significado |
|---------|-------------|
| `.`     | El directorio **actual** (donde estás ahora) |
| `..`    | El directorio **padre** (un nivel arriba) |

```bash
# Situación: estás en /home/genomics/Data/

# Acceder a un archivo en el directorio actual:
$ cat ./ecoli.fasta          # equivalente a cat ecoli.fasta

# Subir un nivel (ir a /home/genomics/):
$ cd ..

# Subir dos niveles (ir a /home/):
$ cd ../..

# Ir a un directorio hermano (More_Data está al mismo nivel que Data):
$ cd ../More_Data

# Acceder a un archivo dentro de un subdirectorio:
$ cat ./Bacteria/salmonella.fasta
```

### Comparación rápida

| Situación | Ruta absoluta | Ruta relativa (desde `/home/genomics/Data/`) |
|-----------|--------------|----------------------------------------------|
| Ir a More_Data | `cd /home/genomics/More_Data` | `cd ../More_Data` |
| Ir a /home | `cd /home` | `cd ../..` |
| Ir a home del usuario | `cd /home/genomics` | `cd ~` o `cd` |

---

## 3. Tipos de Archivos

### En Linux, todo es un archivo

A diferencia de otros sistemas operativos, Linux trata casi todo como un archivo: directorios, dispositivos, procesos. Existen cinco tipos principales:

#### 1. Archivos ordinarios
Contienen datos: texto plano, secuencias biológicas (FASTA, FASTQ), scripts, imágenes, etc.

```bash
$ ls -lh ecoli.fasta
-rw-r--r-- 1 genomics users 4.2K Apr 10 10:30 ecoli.fasta
# El primer carácter '-' indica archivo ordinario
```

#### 2. Directorios
Son archivos especiales que contienen referencias a otros archivos y directorios.

```bash
$ ls -lh
drwxr-xr-x 2 genomics users 4.0K Apr 10 10:30 Bacteria/
# El primer carácter 'd' indica directorio
```

#### 3. Archivos especiales (dispositivos)
Representan hardware: discos, terminales, etc. Se encuentran en `/dev/`.

#### 4. Enlaces físicos (hard links)
Un segundo nombre que apunta al **mismo bloque de datos** en disco (mismo inodo). Si se elimina el archivo original, los datos persisten mientras exista al menos un enlace físico.

```bash
$ ln archivo_original.fasta enlace_fisico.fasta
$ ls -lhi    # el número de inodo será idéntico en ambos archivos
```

#### 5. Enlaces simbólicos (soft links / symlinks)
Apuntan al **nombre** del archivo original (no al inodo). Son como los "accesos directos" de Windows. Si se elimina el archivo original, el enlace simbólico queda "roto".

```bash
$ ln -s archivo_original.fasta enlace_simbolico.fasta
$ ls -lhi    # aparece con -> indicando el destino
```

### Diferencias clave: hard link vs. symlink

| Característica | Enlace físico (hard link) | Enlace simbólico (soft link) |
|----------------|--------------------------|------------------------------|
| Comparte inodo | ✅ Sí | ❌ No (tiene su propio inodo) |
| Funciona entre sistemas de archivos | ❌ No | ✅ Sí |
| Puede enlazar directorios | ❌ No | ✅ Sí |
| Sobrevive si se borra el original | ✅ Sí | ❌ No (enlace roto) |
| Visible con `ls -l` | Sin indicador especial | Muestra `->` |
| Uso en bioinformática | Datos compartidos en misma partición | Accesos a bases de datos, versiones de software |

> 🧬 **Uso real en bioinformática:** Los enlaces simbólicos son muy frecuentes para apuntar a bases de datos genómicas grandes (NCBI, Ensembl) sin duplicar archivos. Por ejemplo: `~/db/nt -> /mnt/datos_compartidos/ncbi/nt_2025/`.

### Códigos de color en la terminal

Cuando ejecutas `ls --color` (activado por defecto en la mayoría de distribuciones), los archivos se muestran con colores:

```
Blanco / gris    →  Archivo ordinario (texto, FASTA, etc.)
Azul             →  Directorio
Verde brillante  →  Archivo ejecutable (scripts, programas)
Rojo brillante   →  Archivo comprimido (.tar.gz, .zip)
Magenta / rosa   →  Archivo de imagen (.png, .jpg)
Azul cielo / cian→  Enlace simbólico
Amarillo sobre rojo →  Enlace simbólico roto
```

---

## 4. Práctica Guiada

Para seguir la práctica guiada paso a paso, ejecuta el script incluido:

```bash
# Clona o actualiza el repositorio del curso:
$ git clone https://github.com/[tu-usuario]/[repositorio-curso].git
$ cd [repositorio-curso]/sesion_03/

# Ejecuta el script de práctica:
$ bash practica_guiada.sh
```

O sigue los comandos manualmente en la sección del script [`practica_guiada.sh`](practica_guiada.sh).

### Comandos esenciales de esta sesión

| Comando | Descripción | Ejemplo |
|---------|-------------|---------|
| `pwd` | Muestra el directorio actual | `$ pwd` |
| `ls` | Lista archivos del directorio | `$ ls -lh` |
| `ls -a` | Lista incluyendo ocultos (`.` y `..`) | `$ ls -a` |
| `ls -lhi` | Lista con inodo, permisos y tamaño legible | `$ ls -lhi` |
| `mkdir` | Crea un directorio | `$ mkdir Bacteria` |
| `mkdir -p` | Crea directorios anidados | `$ mkdir -p Mammalia/Primates/Homo` |
| `cd` | Cambia de directorio | `$ cd Data` |
| `touch` | Crea un archivo vacío | `$ touch secuencia.fasta` |
| `cat` | Muestra / crea contenido de archivo | `$ cat secuencia.fasta` |
| `head` | Muestra las primeras líneas | `$ head -n 5 secuencia.fasta` |
| `tail` | Muestra las últimas líneas | `$ tail -n 5 secuencia.fasta` |
| `tree` | Muestra la estructura de directorios | `$ tree Bacteria/` |
| `ln` | Crea enlace físico | `$ ln origen.fasta enlace.fasta` |
| `ln -s` | Crea enlace simbólico | `$ ln -s origen.fasta enlace.fasta` |
| `cp` | Copia archivos | `$ cp origen.fasta destino/` |
| `mv` | Mueve / renombra archivos | `$ mv viejo.fasta nuevo.fasta` |
| `rm` | Elimina archivos | `$ rm archivo.fasta` |
| `rm -rf` | Elimina directorios y su contenido | `$ rm -rf carpeta_vacia/` |

---

## 5. Ejercicios de Consolidación

### Ejercicio A — Navegación básica ⭐

Completa los siguientes pasos en orden y anota los outputs:

```bash
# 1. Ve a tu carpeta home y confirma tu ubicación:
$ cd && pwd

# 2. Crea la siguiente estructura en un solo comando:
$ mkdir -p proyecto_s03/genomas/bacterias

# 3. Entra a la carpeta más profunda y confirma tu ruta:
$ cd proyecto_s03/genomas/bacterias && pwd

# 4. Regresa a home EN UN SOLO COMANDO sin escribir la ruta completa:
$ ____________________    # ¿cuál comando usarías?
```

> **Respuesta esperada del paso 4:** `cd` o `cd ~` o `cd $HOME`

---

### Ejercicio B — Rutas absolutas vs. relativas ⭐⭐

Dado este árbol de directorios:

```
/home/estudiante/
├── genomica/
│   ├── datos/
│   │   ├── ecoli.fasta
│   │   └── salmonella.fasta
│   └── resultados/
│       └── alineamiento.txt
└── scripts/
    └── analisis.sh
```

Si estás ubicado en `/home/estudiante/genomica/datos/`, completa:

| Objetivo | Ruta absoluta | Ruta relativa |
|----------|--------------|---------------|
| Ir a `resultados/` | `/home/estudiante/genomica/resultados` | `../resultados` |
| Ir a `scripts/` | `/home/estudiante/scripts` | `_____________` |
| Ver `analisis.sh` | `cat /home/estudiante/scripts/analisis.sh` | `_____________` |
| Volver a home | `cd /home/estudiante` | `_____________` |

---

### Ejercicio C — Explorar el sistema ⭐⭐

```bash
# 1. Instala tree si no está disponible:
$ sudo apt-get install -y tree

# 2. Observa la estructura de /etc (muestra solo 2 niveles):
$ tree -L 2 /etc

# 3. Lista los archivos de /bin con colores y tamaños legibles:
$ ls -lh /bin | head -20

# 4. ¿Qué color tienen los archivos en /bin? ¿Por qué?
# Respuesta: ___________________

# 5. Observa el contenido de /dev:
$ ls -lh /dev | head -20

# 6. ¿Qué tipo de archivos ves en /dev? ¿Cómo los identifica Linux?
# Pista: observa el primer carácter de los permisos (c = char, b = block)
```

---

### Ejercicio D — Taxonomía con enlaces ⭐⭐⭐

Este ejercicio integra biología con comandos de Linux. Usarás el archivo `datos/homo_sapiens_COX1.fasta` incluido en esta sesión.

```bash
# Situación: estás en sesion_03/

# 1. Crear la jerarquía taxonómica de Homo sapiens:
$ mkdir -p taxonomia/Mammalia/Primates/Hominidae/Homo

# 2. Copiar la secuencia al nivel de especie:
$ cp datos/homo_sapiens_COX1.fasta taxonomia/Mammalia/Primates/Hominidae/Homo/

# 3. Crear un enlace simbólico en el nivel de Clase (Mammalia)
#    usando RUTA ABSOLUTA en el origen:
$ ln -s $(pwd)/taxonomia/Mammalia/Primates/Hominidae/Homo/homo_sapiens_COX1.fasta \
        taxonomia/Mammalia/homo_sapiens_COX1.fasta

# 4. Verificar la estructura:
$ tree taxonomia/

# 5. Verificar los detalles del enlace:
$ ls -lhi taxonomia/Mammalia/

# 6. ¿Qué pasaría si eliminas el archivo original?
#    Primero predice el resultado, luego prueba y restaura:
$ rm taxonomia/Mammalia/Primates/Hominidae/Homo/homo_sapiens_COX1.fasta
$ cat taxonomia/Mammalia/homo_sapiens_COX1.fasta
# → ¿Qué observas? ¿Qué color tiene el enlace ahora?

# 7. Restaura el archivo:
$ cp datos/homo_sapiens_COX1.fasta \
     taxonomia/Mammalia/Primates/Hominidae/Homo/
```

---

### Ejercicio E — Hard link vs. Symlink en acción ⭐⭐⭐

```bash
# 1. Preparación:
$ mkdir -p enlaces_test && cd enlaces_test
$ cat > original.fasta << 'EOF'
>NC_000913.3 Escherichia coli K-12 substr. MG1655
ATGAAACGCATTAGCACCACCATTACCACCACCATCACCATTACCACAGGTAACGGTGCGGGCTGA
EOF

# 2. Crear ambos tipos de enlace:
$ ln original.fasta hard_link.fasta
$ ln -s original.fasta soft_link.fasta

# 3. Observar inodos:
$ ls -lhi
# Pregunta: ¿hard_link.fasta y original.fasta comparten inodo?

# 4. Modificar el original y verificar en ambos enlaces:
$ echo ">secuencia_extra" >> original.fasta
$ wc -l original.fasta hard_link.fasta soft_link.fasta
# Pregunta: ¿cuántas líneas muestra cada archivo?

# 5. El experimento crítico: eliminar el original:
$ rm original.fasta
$ cat hard_link.fasta   # ¿funciona?
$ cat soft_link.fasta   # ¿funciona?

# 6. Conclusión: completa la tabla del ejercicio B en tu cuaderno.
```

---

## 6. Actividad Asincrónica

Escoge una especie animal de tu interés (diferente a *Homo sapiens*) y construye en Linux su jerarquía taxonómica completa desde **Clase hasta Especie**.

### Pasos a seguir:

1. Consulta la taxonomía de tu especie en [NCBI Taxonomy](https://www.ncbi.nlm.nih.gov/taxonomy).
2. En tu carpeta home, crea la estructura de carpetas con los niveles: `Clase/Orden/Familia/Género/Especie`.
3. Descarga desde NCBI una secuencia en formato FASTA de tu especie (gen COX1 o 16S) y guárdala en la carpeta del nivel Especie.
4. Crea un enlace simbólico del archivo FASTA usando **ruta absoluta** y colócalo en la carpeta de **Clase**.
5. Muestra la estructura con `tree` y los detalles con `ls -lhi`.
6. En tu informe incluye:
   - La especie elegida y su clasificación taxonómica
   - Los comandos utilizados (copia el output de tu terminal)
   - El output del comando `tree` mostrando la jerarquía completa
   - La captura de `ls -lhi` de las carpetas Especie y Clase
   - Una reflexión breve: ¿cuándo usarías un hard link y cuándo un symlink en un proyecto bioinformático real?

> 💡 **Tip:** Para completar rutas largas rápidamente, usa la tecla `Tab` para autocompletar. Escribe las primeras letras del directorio y presiona `Tab`.

---

## Próxima sesión

**Sesión 04 — Flujo de datos:** aprenderás cómo los programas reciben datos de entrada (*input*), los procesan y generan salidas (*output*), y cómo redirigir y encadenar estos flujos con `>`, `>>`, `|` y otros operadores.

---

## Referencias bibliográficas

- Blum, R., & Bresnahan, C. (2021). *Linux command line and Shell scripting bible* (4th ed.). Wiley. **Capítulo 3.**  
  [Acceso en catálogo UPC](https://catalogo.upc.edu.pe/permalink/51UPC_INST/logil2/cdi_askewsholts_vlebooks_9781119700944)

- Pevsner, J. (2015). *Bioinformatics and Functional Genomics* (3rd ed.). Wiley-Blackwell. Capítulo 1.

- Buffalo, V. (2015). *Bioinformatics Data Skills*. O'Reilly Media. Capítulos 3-4.

---

*Sesión 03 | 1ABL0014 | UPC — Facultad de Ciencias de la Salud*
