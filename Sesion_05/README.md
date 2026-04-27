# Sesión 05 — Comandos básicos I

> **Curso:** Principios de Programación en Bioinformática (1ABL0014)  
> **Programa:** Biología · Facultad de Ciencias de la Salud · UPC  
> **Docentes:** Frank Guzman Escudero · Manuel Ramírez Sáenz  
> **Semestre:** 2026-1 · Semana 5

---

## 🎯 Logro de la sesión

> *Al finalizar la sesión, el estudiante utiliza la sintaxis básica de los comandos para gestionar y manipular archivos y directorios en el sistema.*

---

## 📋 Agenda

1. [Reglas de sintaxis](#1-reglas-de-sintaxis)
2. [Comandos para gestionar archivos y directorios](#2-comandos-para-gestionar-archivos-y-directorios)
3. [Instalación de software y descarga de datos](#3-instalación-de-software-y-descarga-de-datos)
4. [Práctica guiada](#4-práctica-guiada)
5. [Actividad asincrónica](#5-actividad-asincrónica)

---

## 1. Reglas de sintaxis

Antes de memorizar comandos, es fundamental entender las tres reglas que gobiernan cómo el shell interpreta todo lo que escribes. Si algo falla, revisa estas reglas primero.

### Regla 1 — Capitalización

Linux distingue entre mayúsculas y minúsculas en **todo**: nombres de comandos, opciones y archivos.

```bash
# ✅ Correcto
ls -l

# ❌ Error — el comando no existe en mayúsculas
Ls -l

# ⚠️ Cuidado — -R y -r son opciones DISTINTAS
ls -R    # lista recursiva de subdirectorios
ls -r    # lista en orden inverso
```

> 💡 **Regla de oro:** los nombres de comandos siempre van en **minúsculas**.

---

### Regla 2 — Separación por espacios

El shell interpreta la primera palabra como el **nombre del comando**. Todo lo que sigue, separado por espacios, son **parámetros**.

```
$ cp   ecoli.fasta   genomas/
  ↑         ↑            ↑
comando   origen       destino
```

> ⚠️ Si un nombre de archivo tiene espacios, usa comillas: `cat "mi archivo.fasta"`

---

### Regla 3 — Opciones con guion

| Formato | Uso | Ejemplo |
|---------|-----|---------|
| `-letra` | Opción de una sola letra | `ls -l` |
| `--palabra` | Opción como palabra completa | `ls --help` |
| `-abc` | Varias letras juntas (equivalente) | `ls -alR` = `ls -a -l -R` |

```bash
ls -a -l -R    # forma separada
ls -alR        # forma contraída — mismo resultado
ls --help      # muestra todas las opciones disponibles
```

> ⚠️ La contracción no funciona cuando una opción necesita su propio argumento.  
> Ejemplo: `head -n 5 archivo.fasta` → `-n` recibe `5` y debe ir por separado.

---

## 2. Comandos para gestionar archivos y directorios

### 2.1 Comandos de ayuda

Antes de usar cualquier comando nuevo, consulta su manual. Es una habilidad esencial en bioinformática.

| Sintaxis | Descripción |
|----------|-------------|
| `man comando` | Manual completo (navega con flechas, sale con `q`) |
| `info comando` | Información detallada organizada por utilidad |
| `comando --help` | Ayuda rápida con las opciones principales |
| `whatis comando` | Descripción resumida en una línea |

```bash
man ls
info cp
grep --help
whatis find
```

---

### 2.2 Directorio de trabajo

| Sintaxis | Descripción |
|----------|-------------|
| `pwd` | Muestra la ruta absoluta del directorio actual |

```bash
$ pwd
/home/usuario/Sesion_05
```

> 🧬 **Contexto bioinformático:** siempre saber desde dónde ejecutas tus scripts garantiza que las rutas relativas funcionen correctamente.

---

### 2.3 Listar contenido de un directorio

| Sintaxis | Descripción |
|----------|-------------|
| `ls` | Lista archivos con colores |
| `ls -a` | Incluye archivos ocultos (empiezan con `.`) |
| `ls -l` | Listado largo: permisos, propietario, tamaño, fecha |
| `ls -lh` | Listado largo con tamaños legibles (KB, MB) |
| `ls -R` | Lista recursiva (incluye subdirectorios) |
| `ls -r` | Orden inverso |
| `dir <ruta>` | Similar a `ls`, sin colores |

```bash
ls -lh datos/
```

**Interpretación de `ls -l`:**

```
-rw-r--r--  1  usuario  grupo  4096  abr 27 10:00  ecoli.fasta
│            │     │       │     │         │              │
│            │     │       │     │         │              └─ nombre
│            │     │       │     │         └─ fecha de modificación
│            │     │       │     └─ tamaño (bytes)
│            │     │       └─ grupo
│            │     └─ propietario
│            └─ número de enlaces
└─ tipo + permisos  (- = archivo, d = directorio, l = enlace)
```

---

### 2.4 Moverse entre directorios

| Sintaxis | Descripción |
|----------|-------------|
| `cd` o `cd ~` | Va al directorio home |
| `cd -` | Vuelve al directorio anterior |
| `cd ..` | Sube un nivel (directorio padre) |
| `cd <ruta>` | Cambia al directorio indicado |

```bash
cd Sesion_05/datos    # ruta relativa
cd /home/usuario/     # ruta absoluta (desde /)
cd ..                 # subir un nivel
cd -                  # volver al directorio anterior
```

---

### 2.5 Crear y eliminar directorios

| Sintaxis | Descripción |
|----------|-------------|
| `mkdir <nombre>` | Crea un directorio |
| `mkdir -p ruta/subruta` | Crea toda la cadena de directorios |
| `rmdir <nombre>` | Elimina un directorio **vacío** |
| `rmdir -p ruta/subruta` | Elimina el directorio y sus ancestros vacíos |

```bash
mkdir resultados
mkdir -p analisis/rna_seq/salidas
rmdir resultados
```

---

### 2.6 Visualizar estructura en árbol

| Sintaxis | Opciones útiles |
|----------|-----------------|
| `tree` | `-a` todos · `-d` solo dirs · `-p` permisos · `-s` tamaños |

```bash
tree Sesion_05/
# Sesion_05/
# ├── README.md
# ├── practica_guiada.sh
# └── datos/
#     ├── README.md
#     ├── genes.txt
#     ├── samples.txt
#     ├── expression.txt
#     ├── seqs_1.fasta
#     └── seqs_2.fasta

# Si no está instalado:
sudo apt-get install tree
```

---

### 2.7 Copiar, mover y renombrar

| Sintaxis | Descripción |
|----------|-------------|
| `cp origen destino` | Copia un archivo |
| `cp -r origen destino` | Copia un directorio completo |
| `cp -i origen destino` | Pregunta antes de sobrescribir |
| `mv origen destino` | Mueve o renombra |

```bash
cp ecoli.fasta ecoli_backup.fasta
cp -r datos/ datos_respaldo/
mv nombre_viejo.fasta nombre_nuevo.fasta
```

---

### 2.8 Crear archivos y eliminar

| Sintaxis | Descripción |
|----------|-------------|
| `touch <archivo>` | Crea un archivo vacío o actualiza su marca de tiempo |
| `rm <archivo>` | Elimina un archivo (definitivo, sin papelera) |
| `rm -i <archivo>` | Pide confirmación antes de borrar |
| `rm -r <directorio>` | Elimina un directorio y su contenido |

```bash
touch log_analisis.txt
rm -i ecoli_backup.fasta     # pide confirmación
rm -ri resultados_viejos/    # elimina directorio preguntando
```

> 🚨 **Advertencia:** `rm` es permanente. Usa siempre `-i` cuando tengas dudas.

---

### 2.9 Buscar archivos

| Sintaxis | Descripción |
|----------|-------------|
| `find . -name "*.fasta"` | Busca todos los FASTA en el directorio actual |
| `find . -type d` | Busca solo directorios |
| `find . -size +1M` | Archivos mayores de 1 MB |

```bash
find . -name "*.fasta"
find /home -name "ecoli*" -type f
find . -size +100k -name "*.txt"
```

---

### 2.10 Visualizar contenido de archivos

| Sintaxis | Descripción |
|----------|-------------|
| `cat <archivo>` | Muestra el contenido completo |
| `cat -n <archivo>` | Muestra el contenido con números de línea |
| `more <archivo>` | Paginado hacia adelante (espacio = avanzar, `q` = salir) |
| `less <archivo>` | Paginado con flechas para ir en ambas direcciones |
| `head <archivo>` | Primeras 10 líneas |
| `head -n N <archivo>` | Primeras N líneas |
| `tail <archivo>` | Últimas 10 líneas |
| `tail -n N <archivo>` | Últimas N líneas |
| `file <archivo>` | Determina el tipo (text, binary, data) |

```bash
cat datos/genes.txt
head -n 4 datos/seqs_1.fasta     # ver la primera secuencia completa de un FASTA
tail -n 20 pipeline.log           # revisar el final de un log
file datos/seqs_1.fasta
```

> 🧬 **Uso en bioinformática:** `head -n 8` en un FASTA muestra las primeras dos secuencias (una cabecera + una secuencia = 2 líneas). Es la forma más rápida de verificar el formato de un archivo sin abrirlo completo.

---

### 2.11 Procesamiento de archivos de texto

| Sintaxis | Descripción |
|----------|-------------|
| `paste archivo1 archivo2` | Une archivos línea por línea (sep: tabulador) |
| `paste -d ":" archivo1 archivo2` | Une con separador personalizado |
| `paste -s archivo` | Transpone las líneas en una sola fila |
| `diff archivo1 archivo2` | Compara dos archivos línea a línea |
| `diff -q archivo1 archivo2` | Solo reporta si son diferentes |
| `diff -s archivo1 archivo2` | Reporta si son idénticos |
| `sort archivo` | Ordena líneas alfabéticamente |
| `sort -r archivo` | Orden inverso |
| `sort -u archivo` | Ordena y elimina duplicados |
| `sort -g archivo` | Ordena numéricamente |
| `cut -f1 archivo.tsv` | Extrae la columna 1 (separador: tabulador) |
| `cut -d"," -f2 archivo.csv` | Extrae la columna 2 (separador: coma) |

---

### 2.12 Permisos y usuarios

#### Notación de permisos

```
-rwxr-xr-- 1 manuel bioinf 1024 abr 27 script.sh
 │└──┴──┴──
 │  │  │  └─ otros: r--
 │  │  └──── grupo: r-x
 │  └─────── propietario: rwx
 └─────────── tipo (- archivo, d directorio, l enlace)
```

#### `chmod` — cambiar permisos

```bash
chmod +x script.sh              # dar permiso de ejecución a todos
chmod -x script.sh              # quitar permiso de ejecución
chmod u+w,g-w archivo.txt       # propietario: +escritura; grupo: -escritura
chmod 764 script.sh             # octal: propietario=rwx, grupo=rw, otros=r
chmod a=rwx script.sh           # todos los permisos para todos
```

| Octal | Permisos |
|-------|----------|
| 7 | rwx |
| 6 | rw- |
| 5 | r-x |
| 4 | r-- |
| 0 | --- |

#### `sudo`, `su`, `chown`

```bash
sudo apt install samtools       # ejecutar como superusuario
su otro_usuario                 # cambiar de usuario
chown usuario:grupo archivo     # cambiar propietario y grupo
```

---

### 2.13 Compresión de archivos

| Sintaxis | Descripción |
|----------|-------------|
| `gzip archivo` | Comprime → `archivo.gz` |
| `gunzip archivo.gz` | Descomprime |
| `bzip2 archivo` | Comprime con mejor ratio → `archivo.bz2` |
| `tar -czf salida.tar.gz dir/` | Empaqueta y comprime |
| `tar -xzf archivo.tar.gz` | Desempaqueta y descomprime |
| `tar -tf archivo.tar.gz` | Lista el contenido sin extraer |

```bash
gzip ecoli_genome.fasta              # → ecoli_genome.fasta.gz
tar -czf sesion_05_datos.tar.gz datos/
tar -xzf sesion_05_datos.tar.gz -C /tmp/
```

> 🧬 **Contexto:** los archivos FASTQ de secuenciación suelen ocupar varios GB. En formato `.fastq.gz` se reducen hasta 4 veces. Herramientas como `STAR` o `bowtie2` los leen directamente sin descomprimir.

---

### 2.14 Información del sistema

| Sintaxis | Descripción |
|----------|-------------|
| `uname -a` | Información completa del kernel y arquitectura |
| `uptime` | Tiempo activo del sistema |
| `du -sh <ruta>` | Tamaño en disco de una ruta |
| `df -h` | Espacio libre en todos los volúmenes |
| `free -h` | Memoria RAM libre y usada |
| `top` | Monitor de procesos en tiempo real (`q` para salir) |
| `date` | Fecha y hora actual |

```bash
du -sh datos/    # ¿cuánto pesa mi carpeta de datos?
df -h            # ¿cuánto espacio libre tengo en disco?
free -h          # ¿cuánta RAM disponible tengo?
```

---

## 3. Instalación de software y descarga de datos

### Gestión de paquetes con `apt`

```bash
sudo apt install nombre-del-paquete          # instalar
sudo apt install fastqc samtools bcftools    # instalar varios a la vez
sudo apt remove nombre-del-paquete           # desinstalar
sudo apt remove --purge nombre-del-paquete   # desinstalar + configuración
sudo apt update                              # actualizar lista de paquetes
sudo apt upgrade                             # actualizar todos los paquetes
```

### Descarga con `wget`

```bash
wget URL                          # descarga básica
wget -O mi_archivo.fasta URL      # descarga con nombre personalizado
wget -c URL                       # continuar descarga interrumpida

# Ejemplo con un FASTA de práctica
wget https://www.dropbox.com/s/jvuh9ot5808niuz/Myrtales_1.fasta
```

---

## 4. Práctica guiada

```bash
# Obtener los materiales
git clone https://github.com/1ABL0014/Principios_Programacion_Bioinformatica.git
cd Principios_Programacion_Bioinformatica/Sesion_05

# O actualizar si ya tienes el repositorio
git pull
cd Sesion_05

# Ejecutar la práctica paso a paso
bash practica_guiada.sh
```

Consulta [`datos/README.md`](datos/README.md) para ver la descripción de cada archivo y los resultados esperados.

---

### 4.1 `cat` — crear, ver y concatenar

```bash
cat datos/genes.txt                                    # ver contenido
cat -n datos/genes.txt                                 # con números de línea
cat datos/seqs_1.fasta datos/seqs_2.fasta > todas.fasta  # concatenar
cat > nuevo_gen.txt                                    # crear (Ctrl+D para terminar)
```

### 4.2 `paste` — combinar columnas

```bash
paste datos/samples.txt datos/genes.txt datos/expression.txt
paste -d ":" datos/samples.txt datos/genes.txt datos/expression.txt
paste -d ":," datos/samples.txt datos/genes.txt datos/expression.txt
paste -s datos/samples.txt
```

> 🧬 Muy útil para construir tablas de metadatos de experimentos de expresión génica.

### 4.3 `diff` — comparar archivos

```bash
diff datos/seqs_1.fasta datos/seqs_2.fasta
diff -q datos/seqs_1.fasta datos/seqs_2.fasta
diff -s datos/seqs_1.fasta datos/seqs_2.fasta
```

### 4.4 `sort` — ordenar

```bash
cat datos/genes.txt
sort datos/genes.txt
sort -r datos/genes.txt
sort -u datos/genes.txt
sort -u datos/genes.txt -o genes_unicos.txt
cat genes_unicos.txt
```

### 4.5 `grep` con archivos FASTA

```bash
# Descargar el archivo de ejemplo
wget https://www.dropbox.com/s/jvuh9ot5808niuz/Myrtales_1.fasta

# Extraer cabeceras
grep ">" Myrtales_1.fasta

# Contar secuencias
grep -c ">" Myrtales_1.fasta

# Guardar cabeceras y limpiar el símbolo >
grep ">" Myrtales_1.fasta > cabeceras_raw.txt
tr -d ">" < cabeceras_raw.txt > nombres.txt

# Ordenar
sort nombres.txt
```

> 🧬 `grep -c ">"` es el método más rápido para contar secuencias en un FASTA: cada secuencia tiene exactamente una línea de cabecera que empieza con `>`.

---

## 5. Actividad asincrónica

Trabaja con `datos/seqs_1.fasta` y `datos/seqs_2.fasta` y responde usando comandos de la terminal:

1. ¿Cuántas secuencias hay en cada archivo?
2. ¿Los archivos son idénticos?
3. Extrae y ordena los nombres de las secuencias de cada archivo.
4. ¿Hay algún nombre que aparezca en ambos archivos?

**Pista para la pregunta 4:** investiga el comando `comm` (compara dos archivos ordenados).

Sube tu solución como un script `.sh` al campus virtual.

---

## 📖 Referencia bibliográfica

Ward, B. (2021). *How Linux Works* (3rd ed., Cap. 2). No Starch Press.  
Disponible en el catálogo UPC: [acceso aquí](https://catalogo.upc.edu.pe/permalink/51UPC_INST/logil2/cdi_safari_books_v2_9781098128913)

---

## 🔜 Próxima sesión

**Sesión 06 — Comandos básicos II:** redirección, tuberías (`|`) y expresiones regulares con `grep`, `sed` y `awk`.

---

*Material preparado por Manuel Ramírez Sáenz · Semestre 2026-1*
