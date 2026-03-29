# 🗂️ Cheatsheet — Comandos de la Sesión 01

> Referencia rápida de todos los comandos vistos en esta sesión.  
> Guárdala y consúltala mientras practicas.

---

## Navegación básica

```bash
pwd                    # mostrar directorio actual (Print Working Directory)
ls                     # listar archivos del directorio actual
ls -lh                 # listar con detalles y tamaños legibles
ls -a                  # mostrar archivos ocultos (empiezan con .)
cd nombre_carpeta/     # entrar a una carpeta
cd ..                  # subir un nivel
cd ~                   # ir a la carpeta home del usuario
cd /ruta/absoluta/     # ir a una ruta específica
```

---

## Crear y organizar

```bash
mkdir nombre_carpeta           # crear una carpeta
mkdir -p ruta/con/subcarpetas  # crear carpetas anidadas de una vez
```

---

## Descargar archivos

```bash
wget URL                        # descargar un archivo
wget -P carpeta/ URL            # descargar en una carpeta específica
wget -c URL                     # reanudar descarga interrumpida
wget -q URL                     # modo silencioso (sin progreso)
```

---

## Comprimir y descomprimir

```bash
gzip archivo.txt                # comprimir → genera archivo.txt.gz
gzip -d archivo.txt.gz          # descomprimir
gunzip archivo.txt.gz           # equivalente a gzip -d
zcat archivo.fna.gz             # ver contenido SIN descomprimir
```

---

## Buscar con grep

```bash
grep "patron" archivo           # buscar líneas con el patrón
grep -c "patron" archivo        # contar líneas que contienen el patrón
grep -v "patron" archivo        # mostrar líneas que NO contienen el patrón
grep "^>" secuencias.fna        # líneas que EMPIEZAN con ">"
grep -i "patron" archivo        # búsqueda sin importar mayúsculas/minúsculas
```

---

## Contar con wc

```bash
wc -l archivo          # contar líneas
wc -c archivo          # contar caracteres (bytes)
wc -w archivo          # contar palabras
```

---

## Variables del sistema

```bash
echo $PATH             # ver las rutas donde el Shell busca comandos
echo $HOME             # ver la ruta de la carpeta home
echo $USER             # ver el nombre del usuario actual
history                # ver el historial de comandos ejecutados
```

---

## Tuberías (pipes) — conectar comandos

El símbolo `|` conecta la salida de un comando con la entrada del siguiente:

```bash
# Contar secuencias en un archivo FASTA
grep -c "^>" genoma.fna

# Contar bases totales del genoma (excluir encabezados)
grep -v "^>" genoma.fna | wc -c

# Ver los primeros 5 encabezados de un FASTA
grep "^>" genoma.fna | head -5
```

---

## Pipeline completo de la práctica

```bash
# 1. Crear directorio
mkdir human_genome_hg38

# 2. Descargar genoma humano GRCh38
wget -P human_genome_hg38/ \
  https://ftp.ncbi.nlm.nih.gov/refseq/H_sapiens/annotation/GRCh38_latest/refseq_identifiers/GRCh38_latest_genomic.fna.gz

# 3. Entrar al directorio
cd human_genome_hg38/

# 4. Ver archivo comprimido
ls -lh

# 5. Descomprimir
gzip -d GRCh38_latest_genomic.fna.gz

# 6. Verificar descompresión
ls -lh

# 7. Contar bases del genoma
grep -v "^>" GRCh38_latest_genomic.fna | wc -c
```

---

## Reglas de oro de Linux

```
1. Todo distingue MAYUSCULAS de minusculas:  ls ≠ LS ≠ Ls
2. Los comandos siempre van en MINUSCULAS
3. Los argumentos van separados por espacios
4. El simbolo ~ representa tu carpeta home
5. El simbolo / es la raiz del sistema de archivos
6. Los archivos que empiezan con . estan ocultos
7. El simbolo $ indica que el Shell esta esperando un comando
8. El simbolo # al inicio de una linea es un COMENTARIO (no se ejecuta)
```

---

*Cheatsheet de la Sesión 01 — curso 1ABL0014*
