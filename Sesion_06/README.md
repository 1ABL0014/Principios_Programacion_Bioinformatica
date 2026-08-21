# Sesión 06 — Comandos Básicos II

> 🔗 **Continuidad:** Continúa de **Sesión 05 — Comandos Básicos I**. Cierra la Unidad I; **Sesión 07** inicia Shell Scripting usando estos mismos comandos dentro de scripts.

> **Curso:** Principios de Programación en Bioinformática  
> **Programa:** Biología · UPC · Facultad de Ciencias de la Salud  
> **Docentes:** Frank Guzmán Escudero · Manuel Ramírez Sáenz  
> **Semana:** 6 de 16 · **Unidad I:** Introducción a GNU/Linux

---

## 🎯 Logro de la sesión

Al finalizar la sesión, el estudiante utiliza la sintaxis básica de los comandos para **gestionar y manipular archivos y directorios** en la terminal Linux, aplicando herramientas de procesamiento de texto con expresiones regulares.

---

## 📋 Agenda

1. Comando `grep` — Búsqueda con expresiones regulares
2. Comando `sort` — Ordenamiento de líneas
3. Comando `uniq` — Eliminación de duplicados
4. Comando `tr` — Traducción de caracteres
5. Comando `wc` — Conteo de palabras, líneas y caracteres
6. Comando `rev` — Reversión de texto
7. Comando `fold` — División de líneas
8. Comando `sed` — Editor de flujo
9. Comando `awk` — Procesador de texto avanzado

---

## 🔍 1. Comando `grep`

`grep` (**g**lobally search for a **r**egular **e**xpression and **p**rint matching lines) es una poderosa herramienta de búsqueda de patrones en archivos de texto.

### Sintaxis básica

```bash
grep "PATRÓN" archivo
```

> Los patrones se ponen entre comillas dobles.

### Opciones principales

| Opción | Función |
|--------|---------|
| `-v` | Invierte la coincidencia (líneas que NO contienen el patrón) |
| `--color` | Colorea el texto que coincide |
| `-F` | Interpreta el patrón como cadena literal |
| `-H`, `-h` | Imprime o no el nombre del archivo |
| `-i` | Ignora mayúsculas/minúsculas |
| `-l` | Lista solo los nombres de archivo que contienen el patrón |
| `-n` | Imprime el número de línea |
| `-c` | Cuenta el número de coincidencias |
| `-o` | Solo imprime el patrón que coincide |
| `-w` | Fuerza coincidencia con palabra entera |
| `-x` | Fuerza coincidencia con toda la línea |
| `-f` | Obtiene patrones desde un archivo |
| `-E` | Interpreta el patrón como expresión regular extendida (ERE) |

### Actividad 1 — Búsqueda básica con `grep`

```bash
# Crear archivo de referencias
nano references.txt
```

Contenido de `references.txt`:
```
seq1 chr1 exp-AC02
seq1 CHR1 exp-CC33
seq2 chr1 exp-HT33
seq3 chr 2exp-FG90
seq3 chr2 exp-FG90
seq3 chr2 exp-FG90
seq3 chr2 exp-FG90
seq5 chr12 exp-0011
seq5 chr12 exp-0011
seq5 chr12 exp-0011
seq7 chr8 exp-0TT1
seq7 chr8 exp-0TT1
seq7 chr8 exp-0TT1
```

```bash
# Buscar líneas que contengan "seq1"
grep "seq1" references.txt

# Buscar con número de línea
grep -n "seq1" references.txt

# Solo mostrar las coincidencias (no la línea completa)
grep -no "seq1" references.txt

# Mostrar contexto (líneas alrededor de la coincidencia)
grep -C 2 "seq1" references.txt

# Buscar "chr1" con contexto
grep -C 2 "chr1" references.txt

# Buscar el número "1" (coincidencias parciales)
grep "1" references.txt

# Contar coincidencias de líneas que empiecen con "1"
grep -c "^1" references.txt

# Mostrar líneas que NO contengan "seq1"
grep -v "seq1" references.txt
```

### Actividad 2 — Comparación de listas con `grep`

```bash
# Crear lista1.txt
nano lista1.txt
```

Contenido:
```
SBP1
SIX5
PRDM1
SOX13
BAF1
TCF4
PAX5
CTCF
SOX133
```

```bash
# Crear lista2.txt
nano lista2.txt
```

Contenido:
```
SOX13
BAF1
TCF4
PAX5
```

```bash
# Buscar patrones de lista2 en lista1
grep -f lista2.txt lista1.txt

# Coincidencia de palabras completas
grep -wf lista2.txt lista1.txt
```

### Actividad 3 — Expresiones regulares con `grep -E`

```bash
# Crear archivo palabras.txt
nano palabras.txt
```

Contenido:
```
Esta es una prueba
para practicar expresiones regulares en Linux
Algunos ejemplos
aaaaaaaabbc
caabc
abc
abbc
abbcc
1abc
abcde
2abc
```

```bash
# Líneas que empiezan con 'a'
grep -E '^a' palabras.txt

# Una o más 'b' entre 'a' y 'c'
grep -E 'ab+c' palabras.txt

# Cero o una 'b' entre 'a' y 'c'
grep -E 'ab?c' palabras.txt

# Cualquier carácter seguido de 'r'
grep -E '.r' palabras.txt

# Una o más repeticiones de 'bb' entre 'a' y 'c'
grep -E 'a(bb)+c' palabras.txt

# Entre 2 y 3 'b' entre 'a' y 'c'
grep -E 'ab{2,3}c' palabras.txt

# Entre 2 y 3 'a' seguidos de 'bc'
grep -E 'a{2,3}bc' palabras.txt

# Líneas con mayúsculas
grep -E '[[:upper:]]' palabras.txt
```

### Actividad 4 — Búsqueda de sitios de restricción enzimática

La enzima **HincII** presenta una secuencia de reconocimiento "degenerada":
- **Y** puede ser **C** o **T**
- **R** puede ser **G** o **A**

Secuencia: `GTYRAC` → Posibilidades: `GTCGAC`, `GTCAAC`, `GTTGAC`, `GTTAAC`

```bash
# Opción 1: Listar todas las combinaciones posibles
grep -E "GTCAAC|GTCGAC|GTTAAC|GTTGAC" *.fasta

# Opción 2: Usar clases de caracteres (más elegante)
grep -E "GT[CT][AG]AC" *.fasta
```

> 💡 **Tip bioinformático:** Las expresiones regulares son fundamentales para buscar motivos de secuencia, sitios de unión de factores de transcripción, y patrones degenerados en genómica.

---

## 📊 2. Comando `sort`

Permite ordenar líneas de archivos utilizando diferentes criterios.

### Sintaxis

```bash
sort <opciones> <fichero>
```

### Opciones principales

| Opción | Función |
|--------|---------|
| `-c` | Verificar si los datos están ordenados |
| `-r` | Orden inverso (descendente) |
| `-n` | Ordenar numéricamente |
| `-u` | Eliminar duplicados (únicos) |
| `-k` | Ordenar por campo específico |

### Actividad 5 — Ordenamiento básico

```bash
# Crear archivo genes.txt
nano genes.txt
```

Contenido:
```
pax4
sox13
sox13
Tcf4
azz2
```

```bash
# Verificar si está ordenado
sort -c genes.txt

# Eliminar duplicados y ordenar
sort -u genes.txt

# Guardar resultado en archivo
sort -u genes.txt -o genes_unicos.txt

# Ver contenido
cat genes_unicos.txt

# Orden inverso
sort -r genes.txt
```

### Actividad 6 — Ordenamiento numérico y por campo

```bash
# Generar números aleatorios y ordenar
shuf -i 1-10 -n 10 > numeros.txt
sort -n numeros.txt

# Ordenar por tamaño de archivos (segundo campo)
ls -lh | head -n 5 > archivos.txt
sort -n -k 2 archivos.txt
```

---

## 🔄 3. Comando `uniq`

Informa u omite líneas repetidas. **Nota:** requiere que el archivo esté ordenado primero.

### Sintaxis

```bash
uniq <opciones> <fichero>
```

### Opciones principales

| Opción | Función |
|--------|---------|
| `-c` | Cuenta repeticiones de cada línea |
| `-d` | Muestra solo líneas duplicadas |
| `-u` | Muestra solo líneas únicas (no repetidas) |
| `-i` | Ignora mayúsculas/minúsculas |

### Actividad 7 — Uso de `uniq`

```bash
# Crear archivo uniq.txt
nano uniq.txt
```

Contenido:
```
prueba1
prueba1
prueba1
Prueba1
Prueba2
prueba2
test1
test1
Test1
```

```bash
# Ver contenido
cat uniq.txt

# Eliminar duplicados adyacentes
uniq uniq.txt

# Ignorar mayúsculas/minúsculas
uniq -i uniq.txt

# Contar repeticiones
uniq -c uniq.txt

# Mostrar solo líneas no repetidas
uniq -u uniq.txt

# Mostrar solo líneas repetidas
uniq -d uniq.txt
```

---

## 🔤 4. Comando `tr` (translate)

Se usa para:
1. **Cambiar caracteres** (mayúsculas ↔ minúsculas, reemplazo)
2. **Borrar caracteres**

### Sintaxis

```bash
tr <opciones> <conjunto_1> <conjunto_2>
```

### Actividad 8 — Traducción de caracteres

```bash
# Reemplazar 'a' por 'A'
echo "Esto es un ejemplo de tr para la clase de hoy" | tr 'a' 'A'

# Reemplazar vocales minúsculas por mayúsculas
echo "Esto es un ejemplo de tr para la clase de hoy" | tr 'aeiou' 'AEIOU'

# Aplicar a /etc/passwd (primeras líneas)
cat /etc/passwd | tr "aeiou" "AEIOU" | head

# Equivalente con redirección
tr "aeiou" "AEIOU" < /etc/passwd | head

# Convertir todo a mayúsculas
echo "Esto es un ejemplo de tr para la clase de hoy" | tr 'a-z' 'A-Z'

# Borrar el carácter 'e'
echo "Esto es un ejemplo de tr para la clase de hoy" | tr -d "e"

# Borrar 'E' y 'e'
echo "Esto es un ejemplo de tr para la clase de hoy" | tr -d "Ee"
```

### Actividad 9 — Complemento y borrado en bioinformática

```bash
# Secuencia de ADN
echo "AAA TTTTT GGGG AAA TTTT NNN"

# Borrar espacios
echo "AAA TTTTT GGGG AAA TTTT NNN" | tr -d " "

# Complemento: reemplazar todo lo que NO sea ATGN por '-'
echo "AAA TTTTT GGGG AAA TTTT NNN" | tr -c "ATGN" "-"
```

---

## #️⃣ 5. Comando `wc` (word count)

Cuenta líneas, palabras y caracteres.

### Sintaxis

```bash
wc <opciones> <fichero(s)>
```

### Opciones

| Opción | Función |
|--------|---------|
| `-c` | Cuenta bytes |
| `-m` | Cuenta caracteres |
| `-l` | Cuenta líneas |
| `-w` | Cuenta palabras |
| `-L` | Longitud de la línea más larga |

### Actividad 10 — Conteo en archivos

```bash
# Crear archivo secuencias.txt
nano secuencias.txt
```

Contenido:
```
1 ACTG
2 ACTG
3 TTTGACA
```

```bash
# Sin opciones: líneas, palabras, bytes
wc secuencias.txt

# Solo bytes
wc -c secuencias.txt

# Solo caracteres
wc -m secuencias.txt

# Solo palabras
wc -w secuencias.txt
```

---

## 🔄 6. Comando `rev`

Invierte las líneas de texto carácter por carácter.

### Sintaxis

```bash
rev <opciones> <fichero>
```

### Actividad 11 — Reversión de secuencias

```bash
# Crear archivo secuencias2.txt
nano secuencias2.txt
```

Contenido:
```
AAATTT
GGGCC
CATG
```

```bash
# Reversión de una cadena directamente
echo "ATGC" | rev

# Reversión de archivo
rev secuencias2.txt
```

> 💡 **Aplicación bioinformática:** `rev` se combina con `tr` para obtener la **hebra complementaria inversa** de una secuencia de ADN.

---

## 📏 7. Comando `fold`

Divide líneas en un ancho especificado.

### Sintaxis

```bash
fold <opciones> <fichero>
```

### Actividad 12 — Formato FASTA

```bash
# Descargar genoma del Ébola (ejemplo)
curl -s "https://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?id=AF086833.2&db=nuccore&rettype=fasta" > Ebola_genome.fasta

# Formatear a 50 caracteres por línea (estándar FASTA)
grep -v ">" Ebola_genome.fasta | fold -w 50

# Formatear a 30 caracteres por línea
grep -v ">" Ebola_genome.fasta | fold -w 30
```

---

## ✏️ 8. Comando `sed` (stream editor)

Editor de flujo para transformaciones de texto.

### Características
- No realiza cambios directamente en el archivo (a menos que use `-i`)
- Opera línea a línea
- Soporta búsqueda y sustitución con expresiones regulares

### Sintaxis

```bash
sed [opciones] ['órdenes'] [archivo(s)]
```

### Opciones principales

| Opción | Función |
|--------|---------|
| `-n` | Suprime impresión automática |
| `-i` | Edita el archivo en lugar (in-place) |
| `-e` | Permite múltiples órdenes |
| `-E` | Usa expresiones regulares extendidas |

### Órdenes principales

| Orden | Función |
|-------|---------|
| `p` | Imprime línea |
| `d` | Elimina línea |
| `s` | Sustituye texto |
| `i` | Inserta antes de la línea |
| `a` | Inserta después de la línea |
| `c` | Cambia (reemplaza) la línea |

### Actividad 13 — Impresión duplicada

```bash
# Crear archivo dias.txt
nano dias.txt
```

Contenido:
```
Lunes
Martes
Miércoles
Jueves
Viernes
Sábado
Domingo
```

```bash
# Imprime cada línea dos veces (por defecto sed imprime + orden p imprime)
sed 'p' dias.txt
```

### Actividad 14 — Impresión controlada con `-n`

```bash
# -n suprime impresión automática; 'p' imprime solo las seleccionadas
sed -n 'p' dias.txt
```

> **Anatomía del comando:** `sed` → comando principal | `-n` → suprimir impresión automática | `'p'` → imprimir líneas seleccionadas | `dias.txt` → archivo editable

### Actividad 15 — Selección de líneas específicas

```bash
# Imprimir solo la primera línea
sed -n '1p' dias.txt

# Imprimir las primeras 5 líneas
sed -n '1,5p' dias.txt

# Imprimir desde línea 1 y 4 más adelante
sed -n '1,+4p' dias.txt

# Imprimir cada 2 líneas (líneas impares)
sed -n '1~2p' dias.txt
```

### Actividad 16 — Eliminación de líneas

```bash
# Eliminar la primera línea
sed '1d' dias.txt

# Eliminar las primeras 5 líneas
sed '1,5d' dias.txt

# Eliminar desde línea 1 y 4 más adelante
sed '1,+4d' dias.txt

# Eliminar cada 2 líneas (líneas impares)
sed '1~2d' dias.txt
```

### Actividad 17 — Inserción y modificación

```bash
# Insertar antes de la línea 7
sed '7i\Sábado_again' dias.txt

# Insertar después de la línea 7
sed '7a\Sábado_again' dias.txt

# Cambiar (reemplazar) la línea 7
sed '7c\Sábado_again' dias.txt
```

### Actividad 18 — Sustitución básica

• `s`
• sed permite la sustitución de texto
• Busca patrones de texto usando expresiones regulares y reemplaza el texto encontrado
• En su forma más básica, puede cambiar una palabra por otra usando la siguiente sintaxis:

`$ sed 's/texto_a_buscar/texto_a_modificar/' <fichero_a_reemplazar > fichero_nuevo`

```bash
# Reemplazar primera ocurrencia de "Lunes" por "Inicio de semana"
sed 's/Lunes/Inicio de semana/' dias.txt

# Suprimir impresión y mostrar solo si hubo sustitución
sed -n 's/Lunes/Inicio de semana/' dias.txt

# Mostrar solo líneas donde se realizó sustitución
sed -n 's/Lunes/Inicio de semana/p' dias.txt

# Reemplazar "Domingo" por "Fin de semana"
sed -n 's/Domingo/Fin de semana/p' dias.txt
```

### Actividad 19 — Sustitución global

- sed reemplaza patrones, no palabras
- Por defecto, la orden s opera en la primera coincidencia de una línea y luego pasa a la siguiente línea.
- Para que sed reemplace cada instancia de un patrón en lugar de solo la primera instancia en cada línea, debe añadir la orden opcional g al comando `s`

`$ sed 's/Lunes/Inicio de semana/g' dias2.txt`

```bash
# Crear archivo dias2.txt
nano dias2.txt
```

Contenido:
```
Lunes Lunes
Lunes
Martes
Miércoles
Jueves
Viernes
Sábado
Domingo
```

```bash
# Reemplazar solo primera ocurrencia por línea
sed 's/Lunes/Inicio de semana/' dias2.txt

# Reemplazar TODAS las ocurrencias (global)
sed 's/Lunes/Inicio de semana/g' dias2.txt
```

### Actividad 20 — Sustitución global en texto

```bash
# Crear archivo song.txt
nano song.txt
```

Contenido:
```
this is the song that never ends
yes, it goes on and on, my friend
some people started saying it
not knowing what it was
and they'll continue saying it forever just
```

```bash
# Reemplazar primera ocurrencia de "on" por "ON" por línea
sed 's/on/ON/' song.txt

# Reemplazar TODAS las ocurrencias
sed 's/on/ON/g' song.txt
```

### Actividad 21 — Sustitución de la n-ésima ocurrencia

```bash
# Reemplazar la SEGUNDA ocurrencia de "on" en cada línea
sed 's/on/forward/2' song.txt
```

### Actividad 22 — Edición in-place con backup

- Cuando usamos sed es importante tener en cuenta que nuestro archivo fuente no se ve afectado.
- Las ediciones que se realizan con los comandos de sed se envían a la salida estándar.
- Si queremos guardar nuestras ediciones, podemos redirigir la salida estándar a un archivo usando el metacarácter > o usar la opción –i que alterará el archivo fuente.

`$ sed -i '1~2d' diasSemana.txt # elimina cada dos líneas y modifica diasSemana.txt`

```bash
# Modificar archivo directamente creando backup (.back)
sed -i.back '1~2d' dias.txt

# Ver archivos
cat dias.txt
cat dias.txt.back
```

### Actividad 23 — Expresiones regulares extendidas

```bash
# Usar -E para regex extendidas
sed -E 's/(that|what) (never|it)/REPLACED \2/' song.txt
```

### Actividad 24 — Sustitución en rango de líneas

```bash
# Reemplazar "it" por "IT" solo en líneas 3 a 5
sed -E '3,5s/it/IT/' song.txt
```

### Actividad 25 — Ejercicio integrador

```bash
# Crear archivo data.txt
nano data.txt
```

Contenido:
```
seq1 chr1 19
seq3 chr1 34
seq2 chr2 182
seq1 chr1 055
seq2 chr1 133
seq4 chr3 22
```

```bash
# 1. Reemplazar cada ocurrencia de 'chr' por 'CHR'
sed 's/chr/CHR/g' data.txt

# 2. Imprimir líneas 3 y 5
sed -n -e '3p' -e '5p' data.txt
# o equivalente:
sed -n '3p;5p' data.txt

# 3. Insertar "seq5 chr5 33" antes de la línea 3
sed '3i\seq5 chr5 33' data.txt

# 4. Eliminar líneas vacías
sed -E '/^$/d' data.txt
```

---

## 🧮 9. Comando `awk`

`awk` es un **lenguaje de programación** y procesador de texto para manipular datos estructurados.

### Características
- Excelente para archivos de datos tabulares
- Opera línea por línea
- Procesa campos (columnas) automáticamente

### Sintaxis

```bash
awk '/patrón_búsqueda/ { acción_a_realizar; otra_acción }' archivo
```

- La búsqueda se especifica entre barras `/ /`
- La acción se indica entre llaves `{ }`
- Cada acción se separa con punto y coma `;`

### Actividad 27 — Imprimir todo el archivo

```bash
# Sin patrón: ejecuta acción en todas las líneas
awk '{print}' song.txt
```

### Actividad 28 — Filtrar por patrón

```bash
# Sin acción: imprime líneas que coinciden con el patrón
awk '/people/' song.txt
```

### Actividad 29 — Imprimir campos específicos

```bash
# Líneas que terminan en 's', imprimir primer campo
awk '/s$/ {print $1}' song.txt

# Imprimir segundo campo
awk '/s$/ {print $2}' song.txt

# Imprimir tercer campo
awk '/s$/ {print $3}' song.txt

# Imprimir línea completa ($0)
awk '/s$/ {print $0}' song.txt
```

### Actividad 30 — Separador de campos personalizado

```bash
# Crear archivo word_guion.txt
nano word_guion.txt
```

Contenido:
```
amarillo-3
azul-7
verde-4
negro-6
```

```bash
# Por defecto usa espacios como separador (no funciona bien aquí)
awk '/^a/ {print $1}' word_guion.txt

# Definir '-' como separador de campos
awk -F '-' '/^a/ {print $1}' word_guion.txt

# Imprimir segundo campo (número)
awk -F '-' '/^a/ {print $2}' word_guion.txt
```

### Actividad 31 — Variables internas de `awk`

```bash
# Usando -F
awk -F '-' '/^a/ {print $1}' word_guion.txt

# Usando variable interna FS (Field Separator)
awk -v FS='-' '/^a/ {print $2}' word_guion.txt
```

### Variables internas importantes

| Variable | Descripción |
|----------|-------------|
| `FS` | Separador de campos de entrada |
| `OFS` | Separador de campos de salida |
| `RS` | Separador de registros (líneas) de entrada |
| `ORS` | Separador de registros de salida |
| `NF` | Número de campos en la línea actual |
| `NR` | Número de registro (línea) actual |
| `FILENAME` | Nombre del archivo en proceso |
| `ARGC` / `ARGV` | Argumentos de línea de comandos |

### Actividad 32 — Variables internas NF y NR

```bash
# Crear archivo references2.txt
nano references2.txt
```

Contenido:
```
seq1 ref2 K562 10
seq2 ref800 K562 20
seq2 ref800 GM1787 50
seq3 ref201 GM1787 100
seq4 ref500 GM6789 500
```

```bash
# Imprimir línea completa
awk '{print $0}' references2.txt

# Imprimir número de campos (NF = Number of Fields) por línea
awk '{print NF}' references2.txt

# Imprimir número de registro (NR = Number of Record) por línea
awk '{print NR}' references2.txt

# Filtrar líneas con más de 4 campos
awk 'NF>4 {print $0}' references2.txt

# Filtrar líneas con menos de 5 campos
awk 'NF<5 {print $0}' references2.txt
```

> 💡 **NF** = Número de campos (columnas) en la línea actual  
> 💡 **NR** = Número de registro (línea) que se está procesando

---

### Actividad 33 — Estructuras de control en awk

`awk` soporta estructuras de control similares a otros lenguajes de programación:

| Estructura | Sintaxis |
|-----------|----------|
| Condicional | `if (expr) statement` |
| Condicional con else | `if (expr) statement else statement` |
| Bucle while | `while (expr) statement` |
| Bucle do-while | `do statement while (expr)` |
| Bucle for | `for (opt_expr; opt_expr; opt_expr) statement` |
| Bucle for en array | `for (var in array) statement` |

```bash
# Ver tamaños de archivos en directorio actual
ls -lh | head

# Extraer solo el tamaño (campo 6)
ls -lh | awk '{print $6}' | head

# Imprimir líneas donde el campo 4 sea mayor a 20
awk '{if ($4 > 20) print $0}' references2.txt
```

---

### Actividad 34 — Bloques BEGIN y END

`awk` permite definir bloques especiales que se ejecutan:
- **BEGIN**: Antes de procesar el primer registro (inicialización)
- **END**: Después de procesar el último registro (resultados finales)

```bash
# Sumar todos los valores del campo 4
awk '{print $0}' references2.txt

# Calcular suma total usando BEGIN y END
awk 'BEGIN{suma=0} {suma += $4} END{print suma}' references2.txt
```

> 💡 **BEGIN** se usa para inicializar variables (contadores, sumas, etc.)  
> 💡 **END** se usa para imprimir resultados finales (promedios, totales, etc.)

**Anatomía del comando:**
```
awk 'BEGIN{inicialización} {procesamiento_por_línea} END{resultados_finales}' archivo
```

---

### Actividad 35 — Ejercicios integradores con awk

```bash
# Crear archivo data.txt
nano data.txt
```

Contenido:
```
seq1 chr1 19
seq3 chr1 34
seq2 chr2 182
seq1 chr10 55
seq2 chr11 33
seq4 chr3 22
```

```bash
# 1. Imprimir líneas que NO contengan 33 en el campo 3
awk '{if($3!=33) print $0}' data.txt

# 2. Imprimir líneas que contengan 182 en el campo 3
awk '{if($3==182) print $0}' data.txt

# 3. Imprimir líneas con valor >= 50 en el campo 3
awk '{if($3>=50) print $0}' data.txt

# 4. Calcular promedio del campo 3
sed '/^$/d' data.txt | awk 'BEGIN{avg=0} {avg +=$3} END{print avg/NR}'
```

> 💡 **Nota en el ejercicio 4:** `sed '/^$/d'` elimina líneas vacías antes de procesar con awk, asegurando que NR cuente solo líneas con datos.

---

## 🔗 Resumen de variables y estructuras de awk

### Variables internas

| Variable | Descripción | Ejemplo de uso |
|----------|-------------|----------------|
| `$0` | Línea completa | `'{print $0}'` |
| `$1, $2, ...` | Campo 1, 2, etc. | `'{print $1, $3}'` |
| `$NF` | Último campo | `'{print $NF}'` |
| `NF` | Número de campos | `'{print NF}'` |
| `NR` | Número de registro (línea) | `'{print NR}'` |
| `FS` | Separador de campos de entrada | `-F ','` o `-v FS=','` |
| `OFS` | Separador de campos de salida | `'{OFS="\t"; print $1, $2}'` |
| `RS` | Separador de registros de entrada | `-v RS=''` |
| `ORS` | Separador de registros de salida | `'{ORS=""; print}'` |
| `FILENAME` | Nombre del archivo en proceso | `'{print FILENAME}'` |
| `ARGC` | Número de argumentos | `BEGIN{print ARGC}'` |
| `ARGV` | Array de argumentos | `BEGIN{print ARGV[1]}'` |

### Estructuras de control

| Estructura | Ejemplo |
|-----------|---------|
| `if` | `'{if ($4 > 20) print $0}'` |
| `if-else` | `'{if ($4 > 20) print "alto"; else print "bajo"}'` |
| `while` | `'{i=1; while (i<=NF) {print $i; i++}}'` |
| `for` clásico | `'{for (i=1; i<=NF; i++) print $i}'` |
| `for` en array | `'{for (gen in genes) print gen}'` |

### Bloques especiales

| Bloque | Cuándo se ejecuta | Uso típico |
|--------|-------------------|-----------|
| `BEGIN { }` | Antes del primer registro | Inicializar variables, imprimir headers |
| `{ }` | En cada registro | Procesamiento principal |
| `END { }` | Después del último registro | Imprimir totales, promedios, resúmenes |

---

## 🧬 Aplicaciones bioinformáticas de awk

### Calcular longitud promedio de genes
```bash
awk 'BEGIN{sum=0; count=0} {sum+=$3; count++} END{print "Promedio:", sum/count}' genes_lengths.txt
```

### Filtrar genes por cromosoma y expresión
```bash
awk '$2=="chr1" && $4>50 {print $1, $4}' expression_data.txt
```

### Contar reads por muestra (formato SAM simplificado)
```bash
awk '{counts[$1]++} END{for (sample in counts) print sample, counts[sample]}' reads.txt
```

### Extraer coordenadas de features GFF
```bash
awk '$3=="gene" {print $1, $4, $5, $7}' annotations.gff
```
---

## 🔗 Comandos relacionados entre sí

```bash
┌─────────────────────────────────────────────────────────────┐
│                    PIPELINE TÍPICO EN BIOINFORMÁTICA         │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│   cat archivo.fasta                                         │
│       │                                                     │
│       ▼                                                     │
│   grep ">"        →  Filtra headers                         │
│       │                                                     │
│       ▼                                                     │
│   grep -v ">"     →  Filtra secuencia (sin headers)          │
│       │                                                     │
│       ▼                                                     │
│   tr -d "\n"     →  Elimina saltos de línea                 │
│       │                                                     │
│       ▼                                                     │
│   grep -E "PATRÓN" →  Busca motivos de secuencia             │
│       │                                                     │
│       ▼                                                     │
│   sed 's/ATG/START/g' →  Sustituye codón de inicio           │
│       │                                                     │
│       ▼                                                     │
│   awk -F ',' '{print $2}' →  Extrae columnas                 │
│       │                                                     │
│       ▼                                                     │
│   sort | uniq -c  →  Ordena y cuenta duplicados            │
│       │                                                     │
│       ▼                                                     │
│   wc -l           →  Cuenta líneas finales                  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

### 📋 Actividad Asíncrona — Sesión 06

```bash
- Crear tu directorio de trabajo
- Descarga los datos desde SGD
  - http://downloads.yeastgenome.org/curation/chromosomal_feature/SGD_features.tab
  - http://downloads.yeastgenome.org/curation/chromosomal_feature/SGD_features.README
- Comprobación rápida. ¿Dónde estás y qué tienes?
- ¿Cómo puedo ver los datos página por página?
- ¿Cuántas líneas tiene el archivo SGD_features.tab?
- ¿Cómo empieza el archivo?
- ¿Qué líneas coinciden con el patrón YAL060W?
- ¿Cómo guardo los resultados en un nuevo archivo?
- ¿Cómo puedo colorear el patrón identificado?
- ¿Cómo podemos saber cuántas líneas NO coinciden con el patrón Dubious?
```

---

## 📚 Referencias de la sesión

**Obligatoria** (se envía una semana antes; base de las 5 preguntas de la evaluación inicial)
- Sobell, M., & Helmke, M. (2017). *A Practical Guide to Linux Commands, Editors, and Shell Programming* (4.ª ed.). Pearson. Capítulos 4–5 (~35 pp. — recortar rango exacto al confirmar en catálogo).

**Refuerzo** (opcional, no evaluable)
- Shotts, W. (2019). *The Linux Command Line* (2.ª ed.). No Starch Press. Capítulos 19–20 — expresiones regulares y procesamiento de texto.
- Blum, R., & Bresnahan, C. (2021). *Linux Command Line and Shell Scripting Bible* (4.ª ed.). Wiley. Parte II, Capítulo 11. [Catálogo UPC](https://catalogo.upc.edu.pe/permalink/51UPC_INST/logil2/cdi_askewsholts_vlebooks_9781119700944)
- Hausenblas, M. (2022). *Learning Modern Linux*. O'Reilly Media. Capítulo 3.

**Artículo** (opcional, aporta el "por qué biológico" — cierre de la Unidad I)
- Ziemann, M., Eren, Y., & El-Osta, A. (2016). Gene name errors are widespread in the scientific literature. *Genome Biology*, 17, 177. DOI [10.1186/s13059-016-1044-7](https://doi.org/10.1186/s13059-016-1044-7) — acceso abierto.
- Cock, P. J. A., Fields, C. J., Goto, N. et al. (2010). The Sanger FASTQ file format for sequences with quality scores, and the Solexa/Illumina FASTQ variants. *Nucleic Acids Research*, 38(6), 1767–1771. DOI [10.1093/nar/gkp1137](https://doi.org/10.1093/nar/gkp1137) — acceso abierto.

---

> **Siguiente sesión:** [Sesión 07 — Introducción a Shell Scripting](../sesion_07/)

---

_Repositorio del curso 1ABL0014 · UPC · Semestre 2026-2_
