# 📘 Sesión 04 — Flujo de Datos

> **Curso:** 1ABL0014 · Principios de Programación en Bioinformática  
> **Unidad:** I — Introducción a GNU/Linux  
> **Referencia:** Kothari, D., Shriram, K., & Sundaram, R. (2011). *Linux*. New Age International. Cap. 3.

---

## 🎯 Logro de la sesión

> *Al finalizar la sesión, el estudiante conoce el manejo de flujos de datos a través de redirecciones de entrada y salida.*

---

## 🧠 Saberes previos — Activa lo que ya sabes

Antes de comenzar, reflexiona:

1. **¿Qué entiendes por "rutas" en el sistema de archivos?**  
   *(Pista: ¿cuál es la diferencia entre `/home/usuario/datos` y `./datos`?)*

2. **¿Qué entiendes como permisos de archivos?**  
   *(Pista: cuando ejecutas `ls -l`, ¿qué significa esa primera columna como `-rw-r--r--`?)*

---

## 📋 Agenda

```
1. Metacaracteres del shell (comodines)
        ↓
2. Flujos de datos: stdin, stdout y stderr
        ↓
3. Redirección de salida estándar  ( > y >> )
        ↓
4. Redirección de entrada estándar ( < )
        ↓
5. Comunicación entre comandos: tuberías ( | )
        ↓
6. Ejecución secuencial ( ; ) y condicional ( && , || )
        ↓
7. Gestión de permisos de archivos ( chmod )
```

---

## 1. Metacaracteres del Shell

Un **metacarácter** es un símbolo con significado especial para el shell. No representan datos — representan instrucciones de comportamiento.

### Comodines (wildcards) para nombres de archivos

| Símbolo | Significado | Ejemplo |
|---------|-------------|---------|
| `*` | Cero o más caracteres | `ls *.fasta` → todos los FASTA |
| `?` | Exactamente un carácter | `ls gen?.sh` → gen1.sh, genA.sh |
| `[AC]` | Cualquier carácter en la lista | `ls file[AC].txt` → fileA.txt, fileC.txt |
| `[A-Z]` | Cualquier carácter en el rango | `ls secuencia[A-Z].fasta` |

### Metacaracteres de flujo y control

| Símbolo | Función |
|---------|---------|
| `>` | Redirige stdout a un archivo (sobrescribe) |
| `>>` | Redirige stdout a un archivo (agrega) |
| `<` | Lee stdin desde un archivo |
| `\|` | Tubería: conecta stdout de un comando con stdin del siguiente |
| `;` | Ejecución secuencial (siempre) |
| `&&` | Ejecución condicional AND (si el anterior tuvo éxito) |
| `\|\|` | Ejecución condicional OR (si el anterior falló) |
| `2>` | Redirige stderr a un archivo |
| `&` | Ejecuta en segundo plano |
| `#` | Comentario (el shell ignora el resto de la línea) |
| `$` | Lee el valor de una variable |

### 🔬 Ejercicio — Tabla de comodines

Crea estos archivos en un directorio de prueba y completa la tabla:

```bash
mkdir practica_comodines && cd practica_comodines
touch file1.txt file2.txt file33.txt fileA.txt fileC.zip fileB.txt Output.pdf
```

| Comando | file1.txt | file2.txt | file33.txt | fileA.txt | fileC.zip | fileB.txt | Output.pdf |
|---------|:---------:|:---------:|:----------:|:---------:|:---------:|:---------:|:----------:|
| `ls file*` | | | | | | | |
| `ls file?.txt` | | | | | | | |
| `ls file[AC].???` | | | | | | | |
| `ls file[A-C].???` | | | | | | | |
| `ls *.txt` | | | | | | | |

> ✏️ Marca con ✓ los archivos que aparecen con cada comando.

---

## 2. Flujos de Datos (Streams)

Cuando un programa en Linux se ejecuta, tiene tres canales de comunicación abiertos automáticamente:

```
              ┌─────────────┐
 TECLADO ─────►             ├──────► PANTALLA
  (stdin)     │   PROGRAMA  │ (stdout)
              │             │
              └──────┬──────┘
                     │
                     ▼ PANTALLA
                  (stderr)
```

| Flujo | Nombre | Descriptor | Destino por defecto |
|-------|--------|-----------|---------------------|
| **stdin** | Entrada estándar | `0` | Teclado |
| **stdout** | Salida estándar | `1` | Pantalla |
| **stderr** | Error estándar | `2` | Pantalla |

### ¿Por qué hay dos canales de salida?

Porque los **resultados** y los **mensajes de error** tienen naturaleza diferente y queremos tratarlos de forma independiente.

> **Ejemplo bioinformático:** Cuando ejecutas un alineador como STAR o BWA, el programa imprime estadísticas de progreso por **stderr** (para que las veas en pantalla), mientras que el archivo de resultados (BAM) se escribe directamente en disco. De esta manera puedes redirigir los logs sin perder los resultados.

```bash
# Redirigir stdout y stderr a archivos separados:
bwa mem referencia.fa muestra_R1.fq muestra_R2.fq > alineamiento.sam 2> bwa.log
```

---

## 3. Redirección de Salida Estándar

### Operador `>` — Sobrescribir

```bash
ls > listado.txt        # Guarda la lista de archivos; si listado.txt existe, lo borra primero
```

### Operador `>>` — Agregar (append)

```bash
ls >> listado.txt       # Agrega al final de listado.txt sin borrar su contenido
```

### Redirigir errores con `2>`

```bash
ls /ruta_que_no_existe 2> errores.log    # El mensaje de error va al archivo
```

### Redirigir stdout y stderr simultáneamente

```bash
grep ">" ecoli_genes.fasta > cabeceras.txt 2> errores.log
```

### Crear un archivo vacío

```bash
> nuevo_archivo.txt     # Crea el archivo vacío (o lo vacía si ya existe)
```

### 🔬 Práctica con datos FASTA

```bash
# Guardar las cabeceras del FASTA de E. coli
grep ">" ecoli_genes.fasta > cabeceras_ecoli.txt
cat cabeceras_ecoli.txt   # Verifica: deben aparecer 5 líneas

# Agregar cabeceras del segundo FASTA
grep ">" genes_resistencia.fasta >> cabeceras_ecoli.txt
wc -l cabeceras_ecoli.txt   # Ahora deben ser 10 líneas
```

---

## 4. Redirección de Entrada Estándar

### Operador `<` — Leer desde archivo

```bash
sort < especies_genomicas.tsv           # Ordena el archivo
sort < especies_genomicas.tsv > ordenado.tsv   # Ordena y guarda
```

Algunos comandos **requieren** `<` porque solo leen de stdin (no aceptan argumentos de archivo):

```bash
tr -d ">" < cabeceras_ecoli.txt    # Elimina el carácter ">" de cada línea
```

---

## 5. Tuberías (Pipes)

### Concepto fundamental

El operador `|` conecta el **stdout** de un comando con el **stdin** del siguiente, sin crear archivos intermedios.

```
COMANDO_1 ──(stdout)──►  | ──(stdin)──► COMANDO_2 ──(stdout)──►  | ...
```

> **Filosofía Unix:** *"Haz una cosa y hazla bien."* Las herramientas Unix son pequeñas y especializadas. Las tuberías permiten combinarlas para resolver problemas complejos.

### Comandos frecuentes en pipelines bioinformáticos

| Comando | Función |
|---------|---------|
| `grep patrón` | Filtra líneas que contienen un patrón |
| `sort` | Ordena líneas |
| `sort -k3 -n` | Ordena por columna 3, numéricamente |
| `wc -l` | Cuenta líneas |
| `head -n N` | Muestra las primeras N líneas |
| `tail -n N` | Muestra las últimas N líneas |
| `cut -f1,3` | Extrae columnas 1 y 3 |
| `uniq -c` | Cuenta ocurrencias de líneas repetidas |
| `tee archivo` | Muestra en pantalla Y guarda en archivo |

### 🔬 Práctica con pipelines

```bash
# Contar genes en archivo FASTA
grep ">" ecoli_genes.fasta | wc -l             # → 5

# Filtrar solo errores del log de pipeline
cat pipeline_rnaseq.log | grep "ERROR"
cat pipeline_rnaseq.log | grep -E "ERROR|WARNING"

# Ordenar genomas por tamaño (columna 3, numérico)
sort -t$'\t' -k3 -n especies_genomicas.tsv

# Obtener solo el nombre del organismo (columna 1) ordenado
cut -f1 especies_genomicas.tsv | sort | tail -n 5

# Ver y guardar al mismo tiempo con tee
grep ">" ecoli_genes.fasta | tee cabeceras_backup.txt | wc -l
```

### Pipeline bioinformático real

```bash
# Ejemplo típico: contar lecturas alineadas a un cromosoma específico
# samtools view muestra.bam | grep "^chr1" | wc -l

# Ejemplo con nuestros datos: extraer solo el nombre del gen del FASTA
grep ">" ecoli_genes.fasta | cut -d'[' -f2 | cut -d'=' -f2 | cut -d']' -f1
```

---

## 6. Ejecución de Comandos: Secuencial y Condicional

### Ejecución secuencial con `;`

Los comandos se ejecutan uno tras otro, sin importar si el anterior falló.

```bash
pwd ; date ; echo "Aprendiendo bioinformática"
```

### Ejecución condicional AND con `&&`

El segundo comando solo se ejecuta si el primero **tuvo éxito** (código de retorno = 0).

```bash
# Solo procesa si el archivo existe y es legible
cat ecoli_genes.fasta > /dev/null && echo "Archivo FASTA válido, procesando..."

# Pipeline con verificación
grep ">" ecoli_genes.fasta > cabeceras.txt && sort cabeceras.txt > cabeceras_sort.txt
```

### Ejecución condicional OR con `||`

El segundo comando solo se ejecuta si el primero **falló** (código de retorno ≠ 0).

```bash
# Si el archivo no existe, crearlo
cat datos_paciente.vcf 2>/dev/null || touch datos_paciente.vcf

# Si falla la descarga, mostrar mensaje de error
wget http://servidor/genoma.fasta || echo "Descarga fallida. Verifica la conexión."
```

### Combinando `&&` y `||` (patrón try/catch)

```bash
cat ecoli_genes.fasta > /dev/null && echo "✓ Archivo FASTA accesible" || echo "✗ Archivo no encontrado"
```

### 🔬 Práctica con el log del pipeline

```bash
# Verificar si hay errores en el log
grep "ERROR" pipeline_rnaseq.log && echo "⚠ Pipeline con errores" || echo "✓ Pipeline limpio"

# Ejecución secuencial de análisis
grep ">" ecoli_genes.fasta > tmp_ecoli.txt ; wc -l tmp_ecoli.txt ; cat tmp_ecoli.txt
```

---

## 7. Permisos de Archivos

### El sistema multiusuario de Linux

Linux es un sistema multiusuario. Cada archivo y directorio tiene permisos que determinan quién puede hacer qué con él. Esto es especialmente relevante en bioinformática cuando trabajas en servidores compartidos con datos de pacientes o proyectos colaborativos.

### Los tres niveles de permisos

```
-rwxrw-r--  1  adiserio  bioinf  4096  jun 30 19:30  prueba.fasta
 │││ ││││     │          │
 │││ ││││     │          └─ Grupo al que pertenece el archivo
 │││ ││││     └─ Propietario (usuario que lo creó)
 │││ │││└─ Permisos para "otros" (resto del sistema)
 │││ └──── Permisos para el "grupo"
 └──────── Permisos para el "propietario"
```

| Nivel | Descripción |
|-------|-------------|
| **Propietario (u)** | El usuario que creó el archivo |
| **Grupo (g)** | Todos los usuarios del mismo grupo (ej: equipo de bioinformática) |
| **Otros (o)** | El resto del sistema |

### Los tres tipos de permiso

| Símbolo | Nombre | Valor octal | Para archivos | Para directorios |
|---------|--------|-------------|---------------|------------------|
| `r` | Lectura | 4 | Visualizar contenido | Ver qué archivos contiene |
| `w` | Escritura | 2 | Modificar contenido | Crear/borrar archivos dentro |
| `x` | Ejecución | 1 | Ejecutar como programa | Entrar al directorio (`cd`) |
| `-` | Sin permiso | 0 | — | — |

### Notación octal

El valor de cada nivel es la **suma** de los permisos activos:

```
rwx = 4+2+1 = 7    (lectura + escritura + ejecución)
rw- = 4+2+0 = 6    (lectura + escritura)
r-x = 4+0+1 = 5    (lectura + ejecución)
r-- = 4+0+0 = 4    (solo lectura)
--- = 0+0+0 = 0    (sin permisos)
```

**Ejemplo:** `chmod 754 analisis.sh`  
→ Propietario: `rwx`(7) | Grupo: `r-x`(5) | Otros: `r--`(4)

### Permisos más comunes en bioinformática

| Código | Permisos | Uso típico |
|--------|----------|-----------|
| `755` | `rwxr-xr-x` | Scripts ejecutables compartidos |
| `644` | `rw-r--r--` | Archivos de datos (FASTA, VCF, etc.) |
| `600` | `rw-------` | Datos sensibles (VCF de pacientes) |
| `700` | `rwx------` | Directorio de trabajo personal |
| `777` | `rwxrwxrwx` | Acceso total (usar con cautela) |

### El comando `chmod`

```bash
# Notación octal
chmod 755 mi_script.sh      # rwxr-xr-x
chmod 644 datos.fasta       # rw-r--r--
chmod 600 paciente.vcf      # rw------- (solo el propietario)

# Notación simbólica
chmod +x mi_script.sh       # Agregar ejecución a todos
chmod u+x mi_script.sh      # Agregar ejecución solo al propietario
chmod o-r datos.fasta       # Quitar lectura a "otros"
chmod g+w proyecto/         # Dar escritura al grupo
```

### 🔬 Práctica de permisos

```bash
# Ver permisos de los archivos de datos
ls -l datos/

# Crear un script y darle permisos de ejecución
echo '#!/bin/bash
echo "Contando secuencias FASTA..."
grep -c ">" ecoli_genes.fasta' > contar_secuencias.sh

ls -l contar_secuencias.sh     # Permisos por defecto: -rw-r--r-- (644)
chmod 755 contar_secuencias.sh # Hacerlo ejecutable
ls -l contar_secuencias.sh     # Ahora: -rwxr-xr-x (755)
./contar_secuencias.sh         # ¡Ejecutarlo!

# Proteger datos sensibles
chmod 600 datos_paciente.vcf
ls -l datos_paciente.vcf
```

---

## 📁 Archivos de esta sesión

```
sesion_04/
├── README.md                    ← Estás aquí
├── practica_guiada.sh           ← Script con todos los ejercicios comentados
└── datos/
    ├── README.md                ← Descripción de los archivos de datos
    ├── ecoli_genes.fasta        ← 5 genes de E. coli K-12
    ├── genes_resistencia.fasta  ← Genes de resistencia antibiótica
    ├── especies_genomicas.tsv   ← Tabla de 10 organismos modelo
    └── pipeline_rnaseq.log      ← Log simulado de pipeline RNA-seq
```

---

## 🚀 Cómo usar estos materiales

```bash
# 1. Clona el repositorio (solo la primera vez)
git clone https://github.com/TU_USUARIO/1ABL0014-Principios-Programacion-Bioinformatica.git

# 2. Actualiza si ya lo tienes
cd 1ABL0014-Principios-Programacion-Bioinformatica
git pull

# 3. Ve a la carpeta de esta sesión
cd sesion_04/datos/

# 4. Verifica que tienes los archivos
ls -lh

# 5. Abre el script de práctica como guía
cat ../practica_guiada.sh | less
```

---

## ✅ Actividad asincrónica

Realiza los siguientes ejercicios en Google Cloud Shell y guarda los comandos usados en un archivo `tarea_s04.sh`:

1. **Redirección doble:** Guarda `pwd` en un archivo, navega a `/bin` y **agrega** (sin sobrescribir) la nueva ruta al mismo archivo.
2. **Captura de errores:** Genera un error con `mkdir` y guarda el mensaje en un archivo de log.
3. **Filtrado de log:** Extrae solo las líneas `ERROR` del archivo `pipeline_rnaseq.log` a un nuevo archivo `solo_errores.log`.
4. **Ordenar tabla genómica:** Ordena `especies_genomicas.tsv` por tamaño de genoma (columna 3) de mayor a menor y guarda el resultado.
5. **Directorio protegido:** Crea `~/mi_proyecto/`, verifica sus permisos y cámbialos a `700`.
6. **Script ejecutable:** Crea `mi_pipeline.sh` que imprima `"Pipeline iniciado"` y dale permisos `755`.

---

## 📖 Referencias

- Kothari, D., Shriram, K., & Sundaram, R. (2011). *Linux*. New Age International. Capítulo 3. [Acceso UPC](https://catalogo.upc.edu.pe/permalink/51UPC_INST/logil2/cdi_proquest_ebookcentral_EBC5490883)
- Shotts, W. (2019). *The Linux Command Line* (2a ed.). No Starch Press. Capítulos 6–7.
- Perez-Riverol, Y. et al. (2019). Ten Simple Rules for Taking Advantage of Git and GitHub. *PLOS Computational Biology*.

---

*Próxima sesión: **Sesión 05 — Búsqueda de Patrones** (`grep`, expresiones regulares aplicadas a secuencias biológicas)*

---

> 📬 ¿Tienes dudas? Abre un *Issue* en este repositorio o escribe al aula virtual UPC.
