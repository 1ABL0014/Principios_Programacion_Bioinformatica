# 🧬 Sesión 12: Elementos de la Sintaxis de Shell Scripting III
## Computadoras, PATH permanente, expresiones regulares y grep

**Docentes:** Frank Guzmán Escudero, Manuel Ramírez Sáenz
**Universidad:** UPC - Facultad de Ciencias de la Salud - Programa de Biología
**Horario:** 1:00 pm - 5:00 pm (Descanso: 2:45 pm - 3:00 pm)

---

## 🎯 Logro de la Sesión

Al finalizar esta sesión, el estudiante:
- Describe cómo la computadora almacena y procesa datos (memoria, CPU, almacenamiento, codificación binaria y ASCII)
- Agrega una herramienta bioinformática al `PATH` de forma permanente mediante `~/.bashrc`
- Usa metacaracteres, escapes, anclas, rangos, clases y cuantificadores para describir patrones de texto
- Identifica y corrige los problemas de fin de línea entre Windows y Linux (`\r\n` frente a `\n`)
- Aplica `grep` con sus opciones principales para buscar, filtrar y contar datos
- Usa variables especiales (`$0`, `$1`, `$#`, `$$`, `$?`) y `grep` dentro de scripts

**Palabras clave:** Memoria, CPU, codificación, ASCII, PATH permanente, `.bashrc`, expresión regular, metacarácter, escape, ancla, rango, clase de caracteres, cuantificador, retorno de línea, `grep`, variables especiales

---

## 📋 Pre-requisitos

- Haber completado las Sesiones 9, 10 y 11
- Saber crear scripts con shebang y ejecutarlos (`chmod +x`, `bash script.sh`)
- Manejar variables, comillas, `export` y `cat` con `EOF` (Sesión 11)

---

## 🧠 1. Repaso Rápido

Antes de avanzar, recuerda tres reglas de la sesión anterior:

```bash
variable="Hola"
echo "$variable mundo"    # Hola mundo
echo '$variable mundo'    # $variable mundo (comillas simples: texto literal)
echo `$variable mundo`    # error: intenta ejecutar "Hola" como comando
```

Las comillas dobles permiten la expansión, las simples la impiden y los acentos invertidos (backticks) ejecutan lo que está dentro. Por eso usamos `$( )` en lugar de backticks.

---

## 💻 2. Cómo trabaja una computadora

Según el diccionario de la Real Academia, un computador electrónico es una máquina dotada de memoria de gran capacidad y de métodos de tratamiento de la información, capaz de resolver problemas matemáticos y lógicos mediante programas.

Tiene dos elementos básicos:
- **La memoria:** almacena cualquier tipo de datos: valores numéricos, texto, imágenes.
- **La unidad central de proceso (CPU):** realiza los cálculos matemáticos y lógicos.

### Arquitectura

| Componente | Función | Característica |
|------------|---------|----------------|
| **CPU** | Ejecuta operaciones matemáticas y lógicas | Dividida en unidad de control y unidad aritmético-lógica |
| **Memoria (RAM)** | Guarda datos para la CPU mientras trabaja | Acceso rápido, pero no permanente (4 a 32 GB en equipos comunes) |
| **Almacenamiento (storage)** | Guarda archivos de forma permanente | Acceso más lento, gran capacidad (cientos o miles de GB) |
| **Entrada/salida (I/O)** | Teclado, monitor, mouse, tarjeta de red | Comunicación con el usuario y con otras máquinas |

Cada celda de memoria tiene una **dirección**, y la CPU accede a ella para leer o escribir el valor. Cuando escribes `variable="Hola"` en tu script, el sistema reserva una celda de memoria, guarda el valor y asocia la celda con el nombre `variable`.

---

## 🔢 3. Codificación de la información

Todo lo que la computadora guarda está en binario: solo dos valores, `0` y `1`.

- **Bit:** la unidad más pequeña, puede valer 0 o 1.
- **Byte:** grupo de 8 bits. Con un byte se representan 256 valores distintos.
- **Código ASCII:** tabla que asocia cada carácter con un número. La letra `H` es el número 72, que en binario es `01001000`.

```
  Carácter:  H    o    l    a
  Decimal:  72  111  108   97
  Binario:  01001000 01101111 01101100 01100001
```

### 🔬 Pruébalo en tu terminal

```bash
printf '%d\n' "'H"               # → 72  (valor ASCII de H)
echo -n H | od -An -t x1         # → 48  (el mismo valor en hexadecimal)
man ascii                        # Tabla completa de caracteres
```

> 💡 La tabla ASCII original tiene 128 caracteres, con códigos de control (como el salto de línea) y caracteres imprimibles. Las variantes extendidas llegan a 256.

---

## ⚙️ 4. Programas y lenguajes de programación

La CPU solo sabe ejecutar **instrucciones simples** codificadas en binario, llamadas **código máquina**. Un **programa** es una secuencia de esas instrucciones que resuelve un problema complejo.

Por ejemplo, para calcular la media de tres números guardados en las posiciones de memoria 10, 11 y 12 y dejar el resultado en la posición 13, un programa en código máquina necesita instrucciones como:

```
1. Sumar contenido de direcciones 10 y 11 y dejar resultado en dirección 13
2. Sumar contenido de direcciones 13 y 12 y dejar resultado en dirección 13
3. Dividir contenido de dirección 13 entre 3 y dejar resultado en dirección 13
4. Detener
```

Escribir en binario es difícil, por eso existen los **lenguajes de programación**. Bash es un lenguaje de este tipo: el shell lee tus líneas y las traduce en acciones que el sistema ejecuta.

---

## 🛤️ 5. El PATH permanente

### ¿Qué pasa cuando cerramos la terminal?

Cuando agregas una ruta con `export PATH=...`, el cambio existe solo en esa sesión. Al reiniciar la sesión o abrir otra terminal, las variables de entorno se vuelven a construir, y el `PATH` regresa a su valor original.

La forma de hacerlo permanente depende del shell. En Bash, la línea se escribe en un archivo que se lee cada vez que se inicia el shell.

### Archivos de inicio de Bash

| Archivo | Cuándo se lee | Uso habitual |
|---------|---------------|--------------|
| `~/.bash_profile` | En inicios de sesión (login) | Configuración de inicio |
| `~/.bashrc` | En cada terminal interactiva nueva | Alias, funciones y `PATH` |
| `~/.profile` | En inicios de sesión, si no existe `~/.bash_profile` | Configuración general |

> 💡 En Cloud Shell y en la mayoría de distribuciones, el `PATH` se agrega en `~/.bashrc`. Si `~/.bash_profile` no existe, conviene verificar que cargue `~/.bashrc`.

### Dónde está el `.bashrc`

```bash
ls -a ~                 # El punto al inicio indica archivo oculto
head ~/.bashrc          # Muestra las primeras líneas
```

### 🔬 Pruébalo: instalar FastQC de forma temporal y luego permanente

Vamos a simular la instalación de FastQC. El ejecutable real se llama `fastqc`, pero aquí usamos un script de prueba.

```bash
# 1. Crear la carpeta y un "fastqc" de prueba
mkdir -p "$HOME/biotools/FastQC"
cat > "$HOME/biotools/FastQC/fastqc" << 'EOF'
#!/bin/bash
echo "FastQC (simulado): analizando $1"
EOF
chmod +x "$HOME/biotools/FastQC/fastqc"

# 2. Intentar ejecutarlo sin PATH
fastqc lecturas.fastq                  # → command not found

# 3. Agregarlo al PATH solo en esta sesión
export PATH="$PATH:$HOME/biotools/FastQC"
fastqc lecturas.fastq                  # → funciona
```

**Salida esperada:**
```
bash: fastqc: command not found
FastQC (simulado): analizando lecturas.fastq
```

Ahora lo hacemos permanente. Antes de editar `~/.bashrc`, **haz una copia de respaldo**:

```bash
cp ~/.bashrc ~/.bashrc.bak                  # Respaldo: si algo sale mal, lo restauras
echo 'export PATH="$PATH:$HOME/biotools/FastQC"' >> ~/.bashrc
tail -n 3 ~/.bashrc                         # Verifica que la línea quedó al final
source ~/.bashrc                            # Recarga el archivo en esta sesión
```

Ahora abre una **nueva terminal** y ejecuta `fastqc lecturas.fastq`. Debe funcionar sin haber escrito `export` de nuevo.

> ⚠️ Si editas `~/.bashrc` y el shell deja de iniciar correctamente, restaura el respaldo con `cp ~/.bashrc.bak ~/.bashrc`.

### 🧪 Ejercicio 1: agregar samtools al PATH de forma permanente

1. Crea la carpeta `$HOME/biotools/samtools/bin` y dentro un script llamado `samtools` que imprima `samtools (simulado)`.
2. Verifica que no funciona escribiendo `samtools` en la terminal.
3. Respalda `~/.bashrc` y agrega la línea `export PATH="$PATH:$HOME/biotools/samtools/bin"`.
4. Recarga con `source` y prueba `samtools`.
5. Abre una nueva terminal y confirma que sigue funcionando.

**Salida esperada en el paso 4:**
```
samtools (simulado)
```

**Pregunta de control:** si agregas la misma línea dos veces a `~/.bashrc`, ¿qué pasa con el `PATH`? Revísalo con `echo $PATH | tr ':' '\n'` y responde en un comentario.

---

## 🔤 6. Expresiones regulares I

### 6.1 ¿Qué es una expresión regular?

Una **expresión regular** (regex) es un conjunto de caracteres especiales que permite encontrar patrones en un texto.

- Buscar la palabra `linux` es sencillo: escribes `linux`.
- Buscar **todos los números** de un texto, o **todas las líneas que empiezan con mayúscula**, requiere describir un patrón, no escribir una palabra. Eso es lo que hace una regex.

### 6.2 Caracteres y metacaracteres

Un **metacarácter** es un carácter que tiene un significado especial. No se representa a sí mismo.

```
Patrón: aba*    →   la * no busca un asterisco: significa "cero o más veces la letra anterior"
```

Los metacaracteres más usados son:

```
.  *  ?  +  [  ]  (  )  {  }  ^  $  |  \
```

### 🔬 Pruébalo en tu terminal

```bash
echo "abaaa" | grep -o 'aba*'     # → abaaa
echo "ba"    | grep -o 'aba*'     # → ba   (la coincidencia es "a" tras "b"... ver nota)
```

> 💡 En la segunda línea `grep` no encuentra "aba" porque no existe. La regex `aba*` coincide con "ab" seguido de cero o más "a". Pruébalo con otras entradas hasta que entiendas el patrón.

### 6.3 Escape con la barra invertida `\`

A veces necesitamos buscar un metacarácter como símbolo literal. Para eso usamos `\` antes del metacarácter.

| Expresión | Coincide con el texto |
|-----------|----------------------|
| `\$12` | `El precio del menú es de $12,50` |
| `\.fasta` | `genoma.fasta` (el punto literal, no el comodín) |

### 🔬 Pruébalo en tu terminal

```bash
echo 'El precio del menú es de $12,50' | grep '\$12'
echo 'genoma.fasta' | grep '\.fasta'
echo 'genomaXfasta' | grep '\.fasta'      # → sin salida: la X no es un punto
```

### 6.4 Anclas: `^` y `$`

Las anclas indican **dónde** debe estar el patrón dentro de la línea.

- `^` indica que el patrón debe estar al **inicio** de la línea.
- `$` indica que el patrón debe estar al **final** de la línea.

| Expresión | Coincidencia |
|-----------|--------------|
| `^El` | "El" solo si aparece al inicio de la línea |
| `fila$` | "fila" solo si es la última palabra de la línea |
| `^$` | líneas vacías |

### 🔬 Pruébalo en tu terminal

Crea un archivo de prueba:

```bash
cat > frases.txt << 'EOF'
El gen mecA confiere resistencia
La muestra fue secuenciada
Resistencia a vancomicina

EOF

grep '^El' frases.txt          # → El gen mecA confiere resistencia
grep 'secuenciada$' frases.txt # → La muestra fue secuenciada
grep -n '^$' frases.txt        # → 4:  (línea vacía número 4)
```

### 6.5 Comodín `.`

El punto `.` representa **cualquier carácter**, una sola vez.

```bash
echo "el precio del menú" | grep -o 'd.l'   # → del
```

### 6.6 Rangos y clases de caracteres

Los **corchetes** `[ ]` definen una clase: el shell encuentra cualquiera de los caracteres dentro del grupo.

```bash
echo "niño"  | grep 'ni[ñn]o'     # → niño
echo "nino"  | grep 'ni[ñn]o'     # → nino
echo "gato"  | grep 'c[aeo]sa'    # → sin salida
echo "casa"  | grep 'c[aeo]sa'    # → casa
```

Rangos con guion `-`:

```bash
echo "ATGC123" | grep -o '[0-9]'        # → 1 2 3 (un dígito por línea)
echo "ATGCgt"  | grep -o '[a-z]'        # → g t
```

Negación con `^` dentro de corchetes:

```bash
echo "ABC123" | grep -o '[^0-9]'        # → A B C (todo lo que NO es dígito)
```

Algunos metacaracteres pierden su significado dentro de corchetes. Por ejemplo, `[a.]` busca la letra `a` o un punto literal:

```bash
echo "a.b" | grep -o '[a.]'             # → a .
```

**Clases POSIX:** atajos para grupos comunes.

| Clase | Equivale a | Significado |
|-------|-----------|-------------|
| `[:alnum:]` | `[A-Za-z0-9]` | alfanumérico |
| `[:alpha:]` | `[A-Za-z]` | letras |
| `[:digit:]` | `[0-9]` | dígitos |
| `[:lower:]` | `[a-z]` | minúsculas |
| `[:upper:]` | `[A-Z]` | mayúsculas |
| `[:space:]` | espacios, tabulador, saltos | espacios en blanco |
| `[:punct:]` | signos de puntuación | puntuación |

```bash
echo "Muestra 42 de E. coli" | grep -o '[[:digit:]]*'   # → 42 (y líneas vacías)
```

> ⚠️ Los corchetes externos son de la expresión y los internos de la clase: `[[:digit:]]` **sí** es correcto.

### 6.7 Cuantificadores

Indican **cuántas veces** debe aparecer el carácter anterior. Por defecto, aparece una vez.

| Cuantificador | Significado |
|---------------|-------------|
| `?` | cero o una vez |
| `*` | cero, una o varias veces |
| `+` | al menos una vez |
| `{n}` | exactamente n veces |
| `{n,m}` | entre n y m veces |

```bash
echo "color colour" | grep -o -E 'colou?r'     # → color y colour
echo "abbbc"        | grep -o -E 'ab+'          # → abbb
echo "ATGGGC"       | grep -o -E 'G{3}'         # → GGG
echo "aaaa"         | grep -o -E 'a{2,3}'       # → aaa
```

> ⚠️ Con `grep` básico, los caracteres `?`, `+`, `{ }` son literales. Para usarlos como cuantificadores escribe `\?`, `\+`, `\{n\}`, o usa `grep -E`. En esta sesión usaremos `-E` para no complicar la lectura.

### 6.8 Retorno de línea: `\n` y `\r\n`

No todos los sistemas terminan una línea del mismo modo.

| Sistema | Fin de línea | Caracteres |
|---------|--------------|------------|
| Linux / macOS moderno | salto de línea | `\n` (LF) |
| Windows | retorno de carro + salto | `\r\n` (CRLF) |

Un archivo creado en Windows puede traer `\r` al final de cada línea. El efecto es que `grep` no encuentra patrones con `$`, porque el `$` queda antes del `\r`.

### 🔬 Pruébalo: detectar y corregir CRLF

```bash
printf 'ATGC\r\nGGCC\r\n' > crlf.txt       # Archivo con finales de línea de Windows
cat -A crlf.txt                             # → ATGC^M$  (el ^M es el \r)
grep 'ATGC$' crlf.txt                       # → sin salida: el $ no encuentra el \r
```

Instala y usa `dos2unix`:

```bash
sudo apt install -y dos2unix
dos2unix crlf.txt
cat -A crlf.txt                             # → ATGC$ (ahora solo \n)
grep 'ATGC$' crlf.txt                       # → ATGC
```

### 6.9 Adelanto: expresiones regulares II

Lo que sigue es un adelanto. Lo desarrollaremos en la siguiente sesión.

- **Grupos `( )`:** agrupan partes de un patrón para aplicarles un cuantificador.
- **Alternancia `|`:** permite elegir entre opciones.
- **Referencias `\1`:** reutilizan un grupo ya capturado.

```bash
echo "ATG GTG CCC" | grep -o -E '(ATG|GTG)'      # → ATG y GTG
echo "abab xyxy" | grep -o -E '(..)\1'            # → abab y xyxy
```

---

## 🔍 7. El comando `grep`

`grep` (*global regular expression print*) busca un patrón en un archivo y muestra las líneas donde aparece.

### Sintaxis

```bash
grep [opciones] 'PATRÓN' archivo
```

> 💡 Usa comillas **simples** alrededor del patrón. Las comillas dobles dejan que el shell expanda `$` antes de que `grep` lo reciba.

### Opciones principales

| Opción | Función |
|--------|---------|
| `-i` | ignora mayúsculas y minúsculas |
| `-v` | muestra las líneas que **no** coinciden |
| `-c` | cuenta las líneas que coinciden |
| `-o` | muestra solo la parte que coincide |
| `-n` | muestra el número de línea de cada coincidencia |
| `-l` | lista solo los nombres de archivo que coinciden |
| `-w` | exige que el patrón sea una palabra completa |
| `-x` | exige que el patrón coincida con toda la línea |
| `-E` | usa expresiones regulares extendidas (cuantificadores sin escape) |
| `-F` | interpreta el patrón como texto literal, sin metacaracteres |
| `-H` / `-h` | muestra u oculta el nombre del archivo |
| `-f` | toma los patrones desde un archivo |
| `-A n` | muestra n líneas después de cada coincidencia |

### 🔬 Pruébalo en tu terminal

Crea un archivo FASTA de prueba:

```bash
cat > secuencias.fasta << 'EOF'
>seq1 Escherichia coli
ATGCGTAA
>seq2 Salmonella enterica
GGCCTAAT
>seq3 Staphylococcus aureus
TTAGCAGT
EOF

grep -c '^>' secuencias.fasta            # → 3   (cuántas cabeceras hay)
grep -o '^>[^ ]*' secuencias.fasta       # → >seq1  >seq2  >seq3
grep -v '^>' secuencias.fasta            # → solo las secuencias
grep -n 'Salmonella' secuencias.fasta    # → 3:>seq2 Salmonella enterica
grep -i 'salmonella' secuencias.fasta    # → la misma línea (sin importar mayúsculas)
grep -l 'aureus' *.fasta                 # → secuencias.fasta
grep -w 'seq1' secuencias.fasta          # → >seq1 Escherichia coli
```

### 🧪 Ejercicio 2: contar secuencias de un archivo

Crea `ejercicio2_conteo.sh`:

```bash
#!/bin/bash
# ejercicio2_conteo.sh
# Cuenta secuencias y bases de un archivo FASTA

ARCHIVO="secuencias.fasta"

SECUENCIAS=$(grep -c '^>' "$ARCHIVO")
echo "Archivo analizado : $ARCHIVO"
echo "Secuencias        : $SECUENCIAS"
echo "Nombres           :"
grep -o '^>[^ ]*' "$ARCHIVO" | sed 's/>//'
```

**Salida esperada:**
```
Archivo analizado : secuencias.fasta
Secuencias        : 3
Nombres           :
seq1
seq2
seq3
```

> 💡 `sed 's/>//'` elimina el símbolo `>`. La herramienta `sed` se verá en la siguiente sesión; por ahora basta con saber que quita el `>`.

---

## 🧰 8. Variables especiales

Bash define variables predefinidas que describen el script y su entorno. Algunas se usan en casi todos los scripts.

| Variable | Contenido |
|----------|-----------|
| `$0` | nombre del script |
| `$1`, `$2`, ... `$9` | argumentos posicionales |
| `${10}`, `${11}` | argumentos a partir del décimo (las llaves son obligatorias) |
| `$#` | número total de argumentos |
| `$$` | PID del proceso actual |
| `$?` | código de salida del último comando (0 = éxito) |
| `$SECONDS` | segundos desde que inició el shell |
| `$RANDOM` | número aleatorio entre 0 y 32767 |
| `$LINENO` | número de la línea que se está ejecutando |

### 🔬 Pruébalo: script con variables especiales

Crea `variables_especiales.sh`:

```bash
#!/bin/bash
# variables_especiales.sh
echo "Nombre del script : $0"
echo "Primer argumento  : $1"
echo "Segundo argumento : $2"
echo "Total de argumentos: $#"
echo "PID del shell     : $$"
echo "Segundos activo   : $SECONDS"
echo "Número aleatorio  : $RANDOM"
echo "Línea actual      : $LINENO"
```

Ejecútalo de tres formas:

```bash
bash variables_especiales.sh
bash variables_especiales.sh Programacion 15
bash variables_especiales.sh "E. coli" genoma.fasta
```

**Salida esperada (segunda ejecución):**
```
Nombre del script : variables_especiales.sh
Primer argumento  : Programacion
Segundo argumento : 15
Total de argumentos: 2
PID del shell     : 4788
Segundos activo   : 17
Número aleatorio  : 27638
Línea actual      : 11
```

> 💡 Los valores de PID, `$SECONDS`, `$RANDOM` y `$LINENO` cambian en cada ejecución. Lo que debe ser constante es `$0`, `$1`, `$2` y `$#`.

### 🧪 Ejercicio 3: `$?` y el resultado de `grep`

`grep` devuelve un código de salida: `0` si encontró el patrón, `1` si no lo encontró, `2` si hubo error (por ejemplo, el archivo no existe).

```bash
grep -q 'Salmonella' secuencias.fasta
echo "Código: $?"              # → Código: 0

grep -q 'Klebsiella' secuencias.fasta
echo "Código: $?"              # → Código: 1

grep -q 'Klebsiella' archivo_inexistente.fasta
echo "Código: $?"              # → Código: 2
```

> 💡 La opción `-q` suprime la salida. Solo nos interesa el código.

---

## 🧪 9. `grep` dentro de scripts

Un script puede recibir un archivo FASTA como argumento y buscar un patrón dentro de él. Usamos `$1` y `$2` para recibir los datos, comillas dobles para que la variable se expanda dentro del patrón y `$?` para leer el resultado. Las decisiones con `if` y las validaciones se verán en la siguiente sesión.

### 🔬 Pruébalo: buscar un patrón en un FASTA

Crea `buscar_fasta.sh`:

```bash
#!/bin/bash
# buscar_fasta.sh
# Uso: bash buscar_fasta.sh <archivo.fasta> <patrón>

ARCHIVO="$1"
PATRON="$2"

echo "Archivo analizado : $ARCHIVO"
echo "Patrón buscado    : $PATRON"
echo ""
echo "Cabeceras que coinciden: $(grep -c "^>.*$PATRON" "$ARCHIVO")"
echo ""
echo "Registros completos (cabecera + secuencia):"
grep -A 1 "^>.*$PATRON" "$ARCHIVO"
CODIGO=$?
echo "Código de salida de grep: $CODIGO"
```

Ejecútalo con dos patrones distintos:

```bash
bash buscar_fasta.sh secuencias.fasta Escherichia
bash buscar_fasta.sh secuencias.fasta Klebsiella
```

**Salida esperada (primera ejecución):**
```
Archivo analizado : secuencias.fasta
Patrón buscado    : Escherichia

Cabeceras que coinciden: 1

Registros completos (cabecera + secuencia):
>seq1 Escherichia coli
ATGCGTAA
Código de salida de grep: 0
```

**Salida esperada (segunda ejecución):**
```
Archivo analizado : secuencias.fasta
Patrón buscado    : Klebsiella

Cabeceras que coinciden: 0

Registros completos (cabecera + secuencia):
Código de salida de grep: 1
```

> 💡 Un código `1` no significa que el script falló. Significa que `grep` no encontró el patrón. Lo que ocurre dentro del script es lo mismo en ambas ejecuciones.

**Pregunta de control:** la línea `grep -A 1 "^>.*$PATRON"` usa comillas dobles. Cambia las comillas por simples y ejecuta de nuevo con `Escherichia`. ¿Qué pasa con la variable y por qué?

> 💡 Este script usa tres conceptos ya vistos: `$1` y `$2` para recibir datos, comillas dobles para expandir variables y `$?` para leer el código de salida. La validación de argumentos se verá en la siguiente sesión.

---

## 📸 10. Actividad Asincrónica

### 🕵️ Misión 4: Filtrar el expediente

> *Agente: en la Misión 1 reconstruiste la identidad de las muestras. Ahora llegó un expediente de pacientes que el equipo de campo envió sin ordenar. Necesitamos filtrar tres grupos antes de la próxima reunión. Si decides aceptar la misión, tu script debe encontrarlos con `grep` y mostrarlos con claridad.*

### Requisitos

Crea la carpeta `Sesion_12/` y dentro un script `expediente_pacientes.sh` que:

1. Crea el archivo `pacientes.txt` con `cat > pacientes.txt << 'EOF'` y estos datos:

```
Hospital Paciente Biobanco Tipo_Usher
Barcelona Pepe Barcelona Usher2A
Mallorca Juan Barcelona usher1b
Albacete Alfonso Madrid usher2
madrid Alcia Madrid usher1a
Valencia Kevin Valencia usher1B
Castellón Didac valencia usher2B
castellón Joan Barcelona usher3
```

2. Muestra los pacientes **enviados al hospital de Castellón**, sin importar mayúsculas ni tildes en el nombre (sugerencia: busca `^castell` con `-i`).
3. Muestra los pacientes **procedentes del Biobanco de Barcelona** (la palabra debe aparecer en la columna del biobanco, no en el hospital).
4. Muestra los pacientes **que no tienen Usher3**, sin incluir la línea de encabezado.
5. Guarda en una variable el código de salida de `grep` del paso 2 con `CODIGO=$?` y muéstralo con `echo`.

**Salida esperada (resumen):**
```
=== ENVIADOS A CASTELLÓN ===
Castellón Didac valencia usher2B
castellón Joan Barcelona usher3

=== BIOBANCO DE BARCELONA ===
Barcelona Pepe Barcelona Usher2A
Mallorca Juan Barcelona usher1b
castellón Joan Barcelona usher3

=== SIN USHER3 ===
Barcelona Pepe Barcelona Usher2A
Mallorca Juan Barcelona usher1b
Albacete Alfonso Madrid usher2
madrid Alcia Madrid usher1a
Valencia Kevin Valencia usher1B
Castellón Didac valencia usher2B
```

**Pista:** en el paso 3, `grep 'Barcelona'` devolvería también las líneas donde Barcelona es el hospital. ¿Qué espacio o ancla te permite restringirlo a la columna del biobanco?

### 🏆 Bonus: Usher1 o Usher2 *(Opcional, nota extra)*

Usa `grep -E` con alternancia para mostrar todos los pacientes con `usher1` o `usher2`, sin importar mayúsculas. Debe mostrar 6 líneas.

Pista: el patrón es `usher[12]` con `-i`, pero prueba también `usher(1|2)`.

---

### ✅ Checklist de entrega

- [ ] `expediente_pacientes.sh` en `Sesion_12/`
- [ ] Shebang `#!/bin/bash` y comentario con tu nombre y clave de agente
- [ ] Permiso de ejecución (`chmod +x`)
- [ ] Revisión de sintaxis con `bash -n`
- [ ] Ejercicio 1 entregado: samtools en `~/.bashrc` y prueba en nueva terminal
- [ ] Respondida la pregunta de control del ejercicio 1
- [ ] Capturas de cada ejecución
- [ ] Bonus entregado (opcional)
- [ ] Commit: `git commit -m "Sesion 12: PATH permanente, regex y grep"`

---

## 🗂️ Resumen de Comandos de la Sesión

### Expresiones regulares

| Patrón | Significado | Ejemplo |
|--------|-------------|---------|
| `.` | cualquier carácter | `d.l` |
| `\` | escape de metacarácter | `\$12`, `\.fasta` |
| `^` | inicio de línea | `^El` |
| `$` | final de línea | `fila$` |
| `[ ]` | clase de caracteres | `ni[ñn]o` |
| `[^ ]` | negación | `[^0-9]` |
| `[[:digit:]]` | clase POSIX | dígitos |
| `?`, `*`, `+` | cero o una, cero o más, una o más | `colou?r` |
| `{n}`, `{n,m}` | cantidad exacta o rango | `G{3}`, `a{2,3}` |

### `grep`

| Operación | Comando |
|-----------|---------|
| Buscar patrón | `grep 'PATRÓN' archivo` |
| Ignorar mayúsculas | `grep -i 'PATRÓN' archivo` |
| Invertir coincidencia | `grep -v 'PATRÓN' archivo` |
| Contar | `grep -c 'PATRÓN' archivo` |
| Solo la parte que coincide | `grep -o 'PATRÓN' archivo` |
| Número de línea | `grep -n 'PATRÓN' archivo` |
| Líneas después de la coincidencia | `grep -A 1 'PATRÓN' archivo` |
| Palabra completa | `grep -w 'PATRÓN' archivo` |
| Regex extendida | `grep -E 'PATRÓN' archivo` |
| Sin salida, solo código | `grep -q 'PATRÓN' archivo` |

### Fin de línea y PATH

| Operación | Comando |
|-----------|---------|
| Ver fin de línea | `cat -A archivo` |
| Convertir CRLF a LF | `dos2unix archivo` |
| Agregar al PATH permanente | `echo 'export PATH="$PATH:/ruta"' >> ~/.bashrc` |
| Respaldo de `.bashrc` | `cp ~/.bashrc ~/.bashrc.bak` |
| Recargar `.bashrc` | `source ~/.bashrc` |

### Variables especiales

| Variable | Contenido |
|----------|-----------|
| `$0` | nombre del script |
| `$1`, `$2`, `${10}` | argumentos |
| `$#` | número de argumentos |
| `$$` | PID del proceso |
| `$?` | código de salida del último comando |

---

## 📚 Referencias Bibliográficas

1. Blum, R., & Bresnahan, C. (2021). *Linux Command Line and Shell Scripting Bible* (4th ed.). Wiley. Capítulo 11.
2. Documentación oficial de GNU Grep.
   [https://www.gnu.org/software/grep/manual/grep.html](https://www.gnu.org/software/grep/manual/grep.html)
3. Documentación oficial de GNU Bash: *Shell Variables*.
   [https://www.gnu.org/software/bash/manual/bash.html](https://www.gnu.org/software/bash/manual/bash.html)
4. ShellCheck: validador de sintaxis Bash.
   [https://www.shellcheck.net/](https://www.shellcheck.net/)

---

> 🎓 *"Una expresión regular bien escrita es como un protocolo que dice exactamente qué muestras buscar y dónde están: si el patrón es vago, el resultado también lo será."*

---

*Documento preparado para la Sesión 12 del curso Principios de Programación en Bioinformática. UPC exígete, innova.*
