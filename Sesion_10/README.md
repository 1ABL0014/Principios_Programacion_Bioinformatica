# 🧬 Sesión 10: Elementos de la Sintaxis de Shell Scripting II
## Principios de Programación en Bioinformática - Unidad 2

**Docentes:** Frank Guzmán Escudero, Manuel Ramírez Sáenz  
**Universidad:** UPC - Facultad de Ciencias de la Salud - Programa de Biología  
**Horario:** 1:00 pm - 5:00 pm (Descanso: 2:45 pm - 3:00 pm)

---

## 🎯 Logro de la Sesión

Al finalizar esta sesión práctica, el estudiante:
- Utilizará el comando `read` para crear scripts interactivos que reciben datos del usuario
- Medirá la longitud de cadenas de texto con `${#variable}`
- Extraerá fragmentos de secuencias biológicas usando subcadenas en Bash
- Realizará reemplazos en cadenas para simular conversiones moleculares (ej. ADN → ARN)
- Capturará una secuencia desde un archivo FASTA en una variable para analizarla con precisión

**Palabras clave:** Shell scripting, strings, subcadenas, manipulación de texto, automatización

---

## 📋 Pre-requisitos

- Acceso a Google Cloud Shell o cualquier terminal Linux
- Haber completado la Sesión 9 (creación y ejecución de scripts básicos en Bash)
- Saber usar `nano` o `vim` para editar archivos
- Tener tu carpeta `operacion_KPC/` de la Operación KPC (Sesión 9). Si no la terminaste, en la sección 3 te mostramos cómo crear el archivo de secuencias que necesitas

---

## 🧠 1. Repaso Rápido: ¿Qué aprendimos la sesión pasada?

Antes de continuar, recordemos los tres elementos que todo script necesita:

```bash
#!/bin/bash                        # 1. Shebang: le dice al sistema qué intérprete usar
# Autor: Mi nombre                 # 2. Comentarios: explican qué hace el código
echo "¡Hola desde mi script!"      # 3. Código ejecutable: los comandos que corren
```

Y una herramienta que usamos mucho en la Operación KPC: **guardar el resultado de un comando** con `$(comando)`:

```bash
lugar=$(pwd)                       # guarda la ruta actual en la variable lugar
echo "Estoy en: $lugar"
echo "Hoy es: $(date)"             # también se puede usar directo dentro de echo
```

También vimos cómo crear y ejecutar un script:

```bash
nano mi_script.sh          # Crear/editar el archivo
chmod +x mi_script.sh      # Dar permisos de ejecución
./mi_script.sh             # Ejecutar
```

### Variables: la base de todo

Una variable es como una "caja" donde guardamos un valor para usarlo después.

```bash
# Guardar un valor
organismo="Escherichia coli"
secuencia="ATCGATCG"

# Usar el valor (siempre con $)
echo $organismo
echo "La secuencia es: $secuencia"
```

> ⚠️ **Regla de oro:** Al guardar un valor **nunca** uses espacios alrededor del `=`
> ```bash
> # ❌ INCORRECTO
> secuencia = "ATCG"
> 
> # ✅ CORRECTO
> secuencia="ATCG"
> ```

---

## 🗣️ 2. Comando `read`: Tu Script Habla con el Usuario

Hasta ahora nuestros scripts solo muestran información fija. Con `read`, el script puede **pedir datos al usuario** mientras se ejecuta, como un formulario interactivo.

### ¿Qué hace `read`?

Pausa el script, espera que el usuario escriba algo y presione Enter, y guarda esa respuesta en una variable.

```bash
read nombre_variable
```

### 🔬 Ejemplo básico — pruébalo ahora:

```bash
#!/bin/bash
echo "¿Cuál es tu nombre?"
read nombre
echo "Hola, $nombre. Bienvenido al laboratorio de bioinformática."
```

**¿Qué verás al ejecutarlo?**
```
¿Cuál es tu nombre?
Manuel                        ← escribes esto y presionas Enter
Hola, Manuel. Bienvenido al laboratorio de bioinformática.
```

### Versión mejorada: prompt en la misma línea con `-p`

```bash
read -p "Ingresa tu nombre: " nombre
```

La opción `-p` muestra el mensaje y deja el cursor en la misma línea, que es más limpio visualmente.

### 🧪 Ejercicio 1 — Realízalo en tu terminal:

Crea el archivo `ejercicio1_read.sh` con el siguiente contenido y ejecútalo:

```bash
#!/bin/bash
# ejercicio1_read.sh
# Formulario básico de identificación de muestra

echo "=== REGISTRO DE MUESTRA BIOLÓGICA ==="
echo ""
read -p "Nombre del investigador: " investigador
read -p "Nombre del organismo: " organismo
read -p "Tipo de muestra (sangre/tejido/cultivo): " tipo_muestra

echo ""
echo "--- RESUMEN DEL REGISTRO ---"
echo "Investigador : $investigador"
echo "Organismo    : $organismo"
echo "Tipo         : $tipo_muestra"
echo "Fecha        : $(date)"
echo "----------------------------"
```

**Salida esperada:**
```
=== REGISTRO DE MUESTRA BIOLÓGICA ===

Nombre del investigador: Ana García
Nombre del organismo: Staphylococcus aureus
Tipo de muestra (sangre/tejido/cultivo): cultivo

--- RESUMEN DEL REGISTRO ---
Investigador : Ana García
Organismo    : Staphylococcus aureus
Tipo         : cultivo
Fecha        : Mon Oct 26 13:05:00 -05 2026
----------------------------
```

### Capturar múltiples valores en una sola línea

Si el usuario separa valores con espacios, `read` los puede asignar a diferentes variables al mismo tiempo:

```bash
#!/bin/bash
echo "Ingresa tres bases nitrogenadas separadas por espacios (ej: A T C):"
read base1 base2 base3

echo "Base 1: $base1"
echo "Base 2: $base2"
echo "Base 3: $base3"
echo "Codón formado: $base1$base2$base3"
```

---

## 📏 3. Medir la Longitud de una Cadena: `${#variable}`

En bioinformática, saber cuántos nucleótidos o aminoácidos tiene una secuencia es una operación básica. En Bash, esto se hace con `${#variable}`.

### Sintaxis:

```bash
longitud=${#mi_variable}
```

El símbolo `#` dentro de las llaves significa "dame el número de caracteres".

### 🔬 Pruébalo ahora mismo en tu terminal:

```bash
secuencia="ATCGATCG"
echo ${#secuencia}
```
**Resultado esperado:** `8`

```bash
proteina="MKTLRV"
echo ${#proteina}
```
**Resultado esperado:** `6`

### 🧪 Ejercicio 2 — Comparador de secuencias:

```bash
#!/bin/bash
# ejercicio2_longitud.sh
# Compara la longitud de secuencias de ADN, ARN y proteína

adn="ATCGTACGATCGATCGATCG"
arn="AUGCGAUCGAUCGUACGUA"
proteina="MKTLRVQPSLQPIF"

echo "=== ANÁLISIS DE LONGITUDES ==="
echo ""
echo "Secuencia ADN     : $adn"
echo "Longitud          : ${#adn} nucleótidos"
echo ""
echo "Secuencia ARN     : $arn"
echo "Longitud          : ${#arn} nucleótidos"
echo ""
echo "Secuencia proteína: $proteina"
echo "Longitud          : ${#proteina} aminoácidos"
```

**Salida esperada:**
```
=== ANÁLISIS DE LONGITUDES ===

Secuencia ADN     : ATCGTACGATCGATCGATCG
Longitud          : 20 nucleótidos

Secuencia ARN     : AUGCGAUCGAUCGUACGUA
Longitud          : 19 nucleótidos

Secuencia proteína: MKTLRVQPSLQPIF
Longitud          : 14 aminoácidos
```

### Métodos alternativos (para tu referencia):

```bash
secuencia="ATCGATCG"

# Con wc -c (cuidado: cuenta también el salto de línea)
echo $secuencia | wc -c        # Resultado: 9 (incluye \n al final)

# Con wc -c sin salto de línea
echo -n $secuencia | wc -c     # Resultado: 8 ✓

# Con awk
echo $secuencia | awk '{print length}'   # Resultado: 8 ✓

# ✅ RECOMENDADO: ${#variable} — más simple y directo
echo ${#secuencia}             # Resultado: 8 ✓
```

### 🔗 De la Operación KPC a hoy: la longitud exacta

¿Recuerdas la Fase 3 de la Operación KPC? Para medir cada secuencia usamos `wc -c`, y el resultado salía con **un carácter de más** porque `wc -c` también cuenta el salto de línea. Hoy lo resolvemos combinando dos cosas que ya conoces: `$(comando)` para **guardar la secuencia en una variable** y `${#variable}` para **medirla**.

Si no tienes el archivo de los aislados, créalo en tu carpeta `operacion_KPC/datos_crudos/` (también está en la carpeta [`datos/`](datos/) de esta sesión):

```bash
mkdir -p operacion_KPC/datos_crudos
cat > operacion_KPC/datos_crudos/aislados_uci.fasta << 'EOF'
>KP_UCI_001|Klebsiella_pneumoniae|paciente_01
ATGTACCCGCCGGGGGGTCCTGGCGTGATGCCGTGGCGGGCCCCATCCACCGAAAGATAA
>KP_UCI_002|Klebsiella_pneumoniae|paciente_02
ATGTGCCTTAACATAATAACGAACGGCCGGCCGTCAAATAGGTGCTCAGCTCTCTATTAG
>KP_UCI_003|Klebsiella_pneumoniae|paciente_03
ATGCCCGGGTCGGGGCAAGACCTGGATAGTCCTTTAGCCAGGGAAATGGTATGA
EOF
```

> 🧪 **Nota:** son **fragmentos simulados** con fines didácticos (empiezan en `ATG` y terminan en un codón de parada), no secuencias reales del gen *bla*<sub>KPC</sub>.

### 🔬 Pruébalo en tu terminal:

```bash
cd operacion_KPC/datos_crudos

# 1. Así medíamos en la Sesión 9 (sobra 1 carácter: el salto de línea)
grep -A1 "KP_UCI_001" aislados_uci.fasta | tail -1 | wc -c

# 2. Así medimos hoy: guardamos la secuencia y contamos sus caracteres
secuencia=$(grep -A1 "KP_UCI_001" aislados_uci.fasta | tail -1)
echo "Secuencia: $secuencia"
echo "Longitud exacta: ${#secuencia} nucleótidos"
```

**Resultado esperado:**
```
61
Secuencia: ATGTACCCGCCGGGGGGTCCTGGCGTGATGCCGTGGCGGGCCCCATCCACCGAAAGATAA
Longitud exacta: 60 nucleótidos
```

¿Qué hace cada parte de la línea que guarda la secuencia?

| Parte | Qué hace |
|---|---|
| `grep -A1 "KP_UCI_001" aislados_uci.fasta` | Busca la cabecera del aislado y muestra también **1 línea después** (`-A1` = *After 1*): la secuencia |
| `\| tail -1` | De esas 2 líneas se queda solo con la última: la secuencia, sin la cabecera |
| `secuencia=$( ... )` | Guarda ese resultado en la variable `secuencia` (Bash quita el salto de línea final) |
| `${#secuencia}` | Cuenta los caracteres de la variable: la longitud exacta |

> ⚠️ Este truco funciona porque en nuestro archivo **cada secuencia ocupa una sola línea**. Muchos FASTA reales parten la secuencia en líneas de 60 u 80 caracteres; para esos archivos necesitarás otras herramientas que veremos más adelante en el curso.

---

## ✂️ 4. Extraer Partes de una Cadena (Subcadenas)

Imagina que tienes una secuencia de ARN mensajero y quieres leer los codones de tres en tres. Con Bash puedes extraer cualquier fragmento de una cadena usando esta sintaxis:

```
${cadena:inicio:longitud}
```

Donde:
- `inicio` = posición desde donde empezar **(los índices empiezan en 0, no en 1)**
- `longitud` = cuántos caracteres tomar

### Visualización de índices — muy importante:

```
Secuencia:  A  T  C  G  A  T  C  G
Índice:     0  1  2  3  4  5  6  7
```

### 🔬 Pruébalo en tu terminal:

```bash
secuencia="ATCGATCG"

echo ${secuencia:0:3}   # Desde posición 0, tomar 3 → ATC
echo ${secuencia:3:3}   # Desde posición 3, tomar 3 → GAT
echo ${secuencia:6:2}   # Desde posición 6, tomar 2 → CG
echo ${secuencia:5}     # Desde posición 5 hasta el final → TCG
```

**Resultados esperados:**
```
ATC
GAT
CG
TCG
```

### Índices negativos — para contar desde el final:

```bash
secuencia="ATCGATCG"

echo ${secuencia: -3}    # Últimos 3 caracteres → TCG
echo ${secuencia: -5:3}  # 3 caracteres empezando desde el 5to por el final → GAT
```

> ⚠️ Nota el espacio antes del `-`. En Bash, `${var:-valor}` tiene otro significado, así que se necesita el espacio para usar índices negativos.

### 🧪 Ejercicio 3 — Lector de codones:

Un **codón** es un triplete de nucleótidos en una secuencia de ARN mensajero que codifica para un aminoácido. Vamos a extraerlos:

```bash
#!/bin/bash
# ejercicio3_codones.sh
# Extrae y muestra los codones de una secuencia de ARN

arn="AUGUCGAAACCCUAG"

echo "Secuencia de ARN : $arn"
echo "Longitud total   : ${#arn} nucleótidos"
echo ""
echo "=== LECTURA DE CODONES (Marco de Lectura +1) ==="
echo ""

codon1=${arn:0:3}
codon2=${arn:3:3}
codon3=${arn:6:3}
codon4=${arn:9:3}
codon5=${arn:12:3}

echo "Posición  1-3  → Codón 1: $codon1"
echo "Posición  4-6  → Codón 2: $codon2"
echo "Posición  7-9  → Codón 3: $codon3"
echo "Posición 10-12 → Codón 4: $codon4"
echo "Posición 13-15 → Codón 5: $codon5"
echo ""
echo "AUG = Metionina (inicio de traducción)"
echo "UAG = Codón de parada (STOP)"
```

**Salida esperada:**
```
Secuencia de ARN : AUGUCGAAACCCUAG
Longitud total   : 15 nucleótidos

=== LECTURA DE CODONES (Marco de Lectura +1) ===

Posición  1-3  → Codón 1: AUG
Posición  4-6  → Codón 2: UCG
Posición  7-9  → Codón 3: AAA
Posición 10-12 → Codón 4: CCC
Posición 13-15 → Codón 5: UAG

AUG = Metionina (inicio de traducción)
UAG = Codón de parada (STOP)
```

---

## 🔍 5. Extracción con Patrones (`#`, `##`, `%`, `%%`)

Además de extraer por posición, Bash permite extraer partes de una cadena eliminando fragmentos que coincidan con un patrón. Esto es muy útil para manipular nombres de archivos o listas de genes.

### La lógica: eliminar desde un extremo hasta un patrón

| Operador | Elimina desde... | Hasta la... | Ejemplo visual |
|----------|-----------------|-------------|----------------|
| `${var#*X}` | el **inicio** | **primera** `X` | `BRCA1,BRCA2,TP53` → `BRCA2,TP53` |
| `${var##*X}` | el **inicio** | **última** `X` | `BRCA1,BRCA2,TP53` → `TP53` |
| `${var%X*}` | el **final** | **primera** `X` (por la derecha) | `gen.fasta.txt` → `gen.fasta` |
| `${var%%X*}` | el **final** | **última** `X` (por la derecha) | `gen.fasta.txt` → `gen` |

> 💡 **Truco para recordarlo:** Un `#` = poco eliminado (hasta la primera). Dos `##` = mucho eliminado (hasta la última). Lo mismo con `%`.

### 🔬 Pruébalo en tu terminal:

```bash
genes="BRCA1,BRCA2,TP53,PTEN"

echo ${genes#*,}     # Elimina hasta la primera coma  → BRCA2,TP53,PTEN
echo ${genes##*,}    # Elimina hasta la última coma   → PTEN
echo ${genes%,*}     # Elimina desde la última coma   → BRCA1,BRCA2,TP53
echo ${genes%%,*}    # Elimina desde la primera coma  → BRCA1
```

**Resultados esperados:**
```
BRCA2,TP53,PTEN
PTEN
BRCA1,BRCA2,TP53
BRCA1
```

### Caso de uso muy común: manejo de extensiones de archivos

```bash
archivo="secuencia.fasta"

sin_extension=${archivo%.fasta}    # → secuencia
echo $sin_extension

# Muy útil para obtener el ID de una muestra desde el nombre de su archivo
archivo="KP_UCI_001.fasta"
id_muestra=${archivo%.fasta}       # → KP_UCI_001
echo "Analizando la muestra $id_muestra"
```

### 🧪 Ejercicio 4 — Extracción de genes de cáncer:

```bash
#!/bin/bash
# ejercicio4_patrones.sh
# Trabaja con una lista de genes relacionados con cáncer de mama

genes="BRCA1,BRCA2,TP53,PTEN,CHEK2,PALB2"
echo "Lista completa   : $genes"
echo ""
echo "=== EXTRACCIÓN CON PATRONES ==="
echo ""
echo "Primer gen       : ${genes%%,*}"
echo "Último gen       : ${genes##*,}"
echo "Sin el primero   : ${genes#*,}"
echo "Sin el último    : ${genes%,*}"
```

**Salida esperada:**
```
Lista completa   : BRCA1,BRCA2,TP53,PTEN,CHEK2,PALB2

=== EXTRACCIÓN CON PATRONES ===

Primer gen       : BRCA1
Último gen       : PALB2
Sin el primero   : BRCA2,TP53,PTEN,CHEK2,PALB2
Sin el último    : BRCA1,BRCA2,TP53,PTEN,CHEK2
```

---

## 🔄 6. Reemplazar Texto en Cadenas

Esta operación es una de las más poderosas para bioinformática: buscar un patrón dentro de una cadena y sustituirlo por otro.

```bash
${variable/buscar/reemplazar}    # Reemplaza solo la PRIMERA ocurrencia
${variable//buscar/reemplazar}   # Reemplaza TODAS las ocurrencias
```

> 💡 **Truco para recordarlo:** Una `/` = una sola vez. Dos `//` = todas las veces.

### 🔬 Pruébalo en tu terminal:

```bash
secuencia="ATCGATCGATCG"

# Reemplazar solo la primera T
echo ${secuencia/T/U}    # → AUCGATCGATCG  (solo la primera)

# Reemplazar todas las T
echo ${secuencia//T/U}   # → AUCGAUCGAUCG  (todas)
```

**Resultados esperados:**
```
AUCGATCGATCG
AUCGAUCGAUCG
```

### 🧪 Ejercicio 5 — Conversión ADN → ARN:

La transcripción es el proceso por el que el ADN se convierte en ARN mensajero. La diferencia química es simple: la Timina (T) del ADN es reemplazada por el Uracilo (U) en el ARN.

```bash
#!/bin/bash
# ejercicio5_transcripcion.sh
# Simula la transcripción de ADN a ARN mensajero

echo "=== SIMULACIÓN DE TRANSCRIPCIÓN ==="
echo ""
read -p "Ingresa una secuencia de ADN (solo A, T, C, G): " adn

# Convertir todas las T por U
arn=${adn//T/U}

echo ""
echo "ADN original  : 5'- $adn -3'"
echo "ARN mensajero : 5'- $arn -3'"
echo ""
echo "Proceso: Timina (T) → Uracilo (U)"
echo "Total de bases transcritas: ${#adn}"
```

**Ejemplo de ejecución:**
```
=== SIMULACIÓN DE TRANSCRIPCIÓN ===

Ingresa una secuencia de ADN (solo A, T, C, G): AAACGCGGCCTTTCCAACGGC

ADN original  : 5'- AAACGCGGCCTTTCCAACGGC -3'
ARN mensajero : 5'- AAACGCGGCCUUUCCAACGGC -3'

Proceso: Timina (T) → Uracilo (U)
Total de bases transcritas: 21
```

---

## 🧬 7. Integrando Todo: Script Completo de Análisis

Ahora que conocemos todos los conceptos de la sesión, vamos a crear un script que los use juntos. Este script pide una secuencia al usuario y realiza múltiples análisis:

```bash
#!/bin/bash
# analizador_secuencia.sh
# Análisis integrado de una secuencia de ADN

echo "============================================"
echo "   ANALIZADOR DE SECUENCIAS - BioScript    "
echo "============================================"
echo ""

read -p "Ingresa el nombre del organismo: " organismo
read -p "Ingresa la secuencia de ADN    : " adn

echo ""
echo "============================================"
echo "  RESULTADOS PARA: $organismo"
echo "============================================"
echo ""

# 1. Longitud total
longitud=${#adn}
echo "1. Longitud de la secuencia : $longitud bp"

# 2. Primeros 6 nucleótidos (extremo 5')
extremo_5=${adn:0:6}
echo "2. Extremo 5' (primeros 6nt): $extremo_5"

# 3. Últimos 6 nucleótidos (extremo 3')
extremo_3=${adn: -6}
echo "3. Extremo 3' (últimos 6nt) : $extremo_3"

# 4. Transcripción a ARN mensajero
arn=${adn//T/U}
echo "4. ARN mensajero            : $arn"

echo ""
echo "Análisis completado."
```

**Ejemplo de ejecución:**
```
============================================
   ANALIZADOR DE SECUENCIAS - BioScript    
============================================

Ingresa el nombre del organismo: Mycobacterium tuberculosis
Ingresa la secuencia de ADN    : ATGCTTGCAATCGATCGATTT

============================================
  RESULTADOS PARA: Mycobacterium tuberculosis
============================================

1. Longitud de la secuencia : 21 bp
2. Extremo 5' (primeros 6nt): ATGCTT
3. Extremo 3' (últimos 6nt) : CGATTT
4. ARN mensajero            : AUGCUUGCAAUCGAUCGAUUU

Análisis completado.
```

---

## 📸 8. Actividad Asincrónica

### 🕶️ Misión: Operación KPC — Parte 2: Descifrar las secuencias

```
══════════════════════════════════════════════════════════════
  TRANSMISIÓN CLASIFICADA — FUERZA BIOINFORMÁTICA DE INTERVENCIÓN
  Destinatario : Agente de campo (tú)
  Nivel de acceso: Estudiante de Bioinformática — Semana 10
══════════════════════════════════════════════════════════════
```

> *Buen trabajo, agente.*
>
> *Gracias a ti, el laboratorio ya tiene una base de operaciones ordenada y un primer inventario de los aislados de la UCI. Pero el comité de control de infecciones necesita más que un inventario: quiere saber **qué dicen** esas secuencias.*
>
> *Tu reporte anterior tenía un detalle que no pasó desapercibido en el cuartel general: las longitudes salieron con **un nucleótido de más**. En una investigación de brote, un error así puede hacer que dos aislados parezcan distintos cuando son la misma cepa.*
>
> *Mientras tanto, el laboratorio de microbiología envió su informe: en el aislado del paciente 1 se detectaron varios genes de resistencia, escritos en una sola línea separados por comas. Alguien tiene que ordenarlos.*
>
> ***Tu misión, si decides aceptarla,*** *consiste en tres fases: medir las secuencias con precisión, transcribirlas y decodificar el informe del laboratorio. Esta vez cuentas con nuevas herramientas: `read`, `$(comando)` y la manipulación de cadenas.*
>
> *Como siempre, si un `${variable}` mal escrito te deja con una pantalla vacía, la Fuerza negará cualquier conocimiento de tus acciones.*
>
> *Este mensaje se autodestruirá en 5 segundos.* 💥

**Entrega:** sube tus scripts a tu repositorio de GitHub (`principios-programacion-bioinfo`) antes de la Sesión 11. Guárdalos dentro de `operacion_KPC/scripts/`.

**Antes de empezar:** necesitas el archivo `operacion_KPC/datos_crudos/aislados_uci.fasta`. Si no lo tienes de la Sesión 9, créalo como se muestra en la sección 3 ("De la Operación KPC a hoy").

---

### 📏 Fase 1 — Medición de precisión: `calculadora_secuencia.sh` *(Obligatorio)*

**Contexto de la misión:** el cuartel general necesita la longitud **exacta** de cada aislado y sus dos extremos: el inicio (¿empieza con el codón `ATG`?) y el final (¿termina en un codón de parada?).

**Tu script debe:**
- Pedir al usuario el ID del aislado con `read -p` (por ejemplo, `KP_UCI_002`)
- Guardar la secuencia de ese aislado en una variable con `$(grep -A1 ... | tail -1)`
- Calcular la longitud exacta con `${#variable}`
- Extraer los primeros 3 nucleótidos con subcadenas (`${variable:0:3}`)
- Extraer los últimos 3 nucleótidos con índice negativo (`${variable: -3}`)

**Pistas del cuartel general:** usa la variable dentro de las comillas del `grep`: `grep -A1 "$id" archivo`. Y no olvides el espacio en `${secuencia: -3}`.

**Salida de ejemplo:**
```
ID del aislado: KP_UCI_002

Aislado             : KP_UCI_002
Secuencia           : ATGTGCCTTAACATAATAACGAACGGCCGGCCGTCAAATAGGTGCTCAGCTCTCTATTAG
Longitud exacta     : 60 nucleótidos
Posible inicio 5'   : ATG
Extremo 3'          : TAG
```

> 🔎 **Verificación cruzada:** ejecuta tu script con los tres aislados. Deberías obtener **60, 60 y 54** nucleótidos. Compáralos con las longitudes aproximadas de tu Fase 3 de la Sesión 9: cada una debería ser exactamente 1 menos.

---

### 🔬 Fase 2 — Transcripción: `transcriptor.sh` *(Obligatorio)*

**Contexto de la misión:** para estudiar cómo se expresa un gen, el equipo de biología molecular necesita la versión en ARN mensajero de cada aislado.

**Tu script debe:**
- Pedir el ID del aislado con `read -p` y guardar su secuencia de ADN en una variable (como en la Fase 1)
- Hacer la conversión T→U con `${variable//T/U}`
- Mostrar el ADN original y el ARN resultante
- Mostrar la longitud de ambas (deben ser iguales)

**Salida de ejemplo:**
```
ID del aislado: KP_UCI_003

=== TRANSCRIPCIÓN: ADN → ARNm — KP_UCI_003 ===
ADN (5'→3') : ATGCCCGGGTCGGGGCAAGACCTGGATAGTCCTTTAGCCAGGGAAATGGTATGA
ARN (5'→3') : AUGCCCGGGUCGGGGCAAGACCUGGAUAGUCCUUUAGCCAGGGAAAUGGUAUGA
Longitud    : 54 bases (sin cambios)
```

> 💭 **Pregunta para tu informe:** ¿por qué la longitud no cambia después de la transcripción? Respóndela en una línea de comentario dentro de tu script.

---

### 🧩 Fase 3 — Decodificar el informe del laboratorio: `lector_genes.sh` *(Obligatorio)*

**Contexto de la misión:** el laboratorio envió los genes de resistencia detectados en el aislado del paciente 1 en una sola línea, separados por comas. El comité quiere ver primero el gen principal, luego el último de la lista y finalmente el resto.

**Tu script debe:**
- Pedir con `read -p` el nombre del archivo del aislado (ejemplo: `KP_UCI_001.fasta`) y obtener su ID quitando la extensión con `${variable%.fasta}`
- Pedir con `read -p` la lista de genes (ejemplo: `blaKPC-2,blaSHV-11,blaTEM-1,ompK36`)
- Extraer el primer gen con `${variable%%,*}`
- Extraer el último gen con `${variable##*,}`
- Mostrar la lista sin el primer gen con `${variable#*,}`

**Salida de ejemplo:**
```
Archivo del aislado : KP_UCI_001.fasta
Genes detectados    : blaKPC-2,blaSHV-11,blaTEM-1,ompK36

=== INFORME DE RESISTENCIA — KP_UCI_001 ===
Gen principal       : blaKPC-2
Último gen          : ompK36
Resto de la lista   : blaSHV-11,blaTEM-1,ompK36
```

> 💡 **Dato real para tu informe:** *bla*<sub>KPC-2</sub> codifica la carbapenemasa que destruye a los carbapenémicos. *bla*<sub>SHV</sub> y *bla*<sub>TEM</sub> son β-lactamasas frecuentes en *K. pneumoniae*. *ompK36* codifica una porina de la membrana externa: cuando la bacteria la pierde o la modifica, entra menos antibiótico, y eso puede sumarse a la resistencia.

---

### 🏆 Fase 4 — Informe para el comité de infecciones: `analizador_completo.sh` *(Opcional — para nota extra)*

Combina las tres fases anteriores en un solo script que pida el ID del aislado, la lista de genes y la fecha del análisis, y guarde un informe en `operacion_KPC/resultados/reporte_<ID>.txt` usando redirección:

```bash
reporte="operacion_KPC/resultados/reporte_${id}.txt"
echo "INFORME — Operación KPC" > $reporte
echo "Generado el $(date)" >> $reporte
echo "Aislado: $id" >> $reporte
# ... continúa el informe: longitud, extremos, ARN y genes
```

Al final, muestra el informe en pantalla con `cat $reporte`.

---

### 🕶️ Detalle de agente *(Opcional — solo por estilo)*

El cuartel general envía sus órdenes cifradas: reemplaza los espacios por guiones bajos para que nadie las lea de un vistazo. Descífralas con lo que aprendiste hoy:

```bash
mensaje="LA_CEPA_ES_KPC._AISLAR_A_LOS_TRES_PACIENTES"
echo "Mensaje cifrado   : $mensaje"
echo "Mensaje descifrado: ${mensaje//_/ }"
```

> *(¿Qué pasa si usas una sola `/`? Pruébalo y explica la diferencia en un comentario.)*

---

### ✅ Protocolo de extracción (Checklist de entrega)

Antes de abandonar el terreno, confirma:

- [ ] Los 3 scripts obligatorios están creados en `operacion_KPC/scripts/`
- [ ] Cada script tiene el shebang `#!/bin/bash` en la primera línea
- [ ] Cada script tiene un comentario con mi nombre, la fecha y qué hace
- [ ] Todos tienen permisos de ejecución (`chmod +x nombre_script.sh`)
- [ ] Los 3 scripts ejecutan sin errores
- [ ] Probé la Fase 1 con los tres aislados y obtuve 60, 60 y 54 nucleótidos
- [ ] Incluí capturas de pantalla de la ejecución de cada fase
- [ ] Subí todo a GitHub con un mensaje de commit descriptivo (ej: `git commit -m "Sesion 10: Operacion KPC parte 2"`)

> 🎖️ *Misión cumplida, agente. Ahora el laboratorio tiene longitudes exactas, transcritos y un informe de resistencia ordenado. Pero analizaste los aislados **uno por uno**, escribiendo cada ID a mano. En la Sesión 11 aprenderás a procesarlos todos de una sola vez.*

---

## 🗂️ Resumen de Comandos de la Sesión

| Operación | Sintaxis | Ejemplo | Resultado |
|-----------|----------|---------|-----------|
| Leer entrada del usuario | `read -p "Mensaje: " var` | `read -p "Nombre: " n` | Guarda lo escrito en `n` |
| Guardar la salida de un comando | `var=$(comando)` | `s=$(grep -A1 "KP_UCI_001" a.fasta \| tail -1)` | Guarda la secuencia en `s` |
| Medir longitud | `${#variable}` | `s="ATCG"; echo ${#s}` | `4` |
| Extraer subcadena | `${var:inicio:largo}` | `${s:0:3}` | Primeros 3 caracteres |
| Extraer desde el final | `${var: -n}` | `${s: -3}` | Últimos 3 caracteres |
| Eliminar prefijo (1ra vez) | `${var#*patron}` | `${g#*,}` | Quita hasta la 1ra coma |
| Eliminar prefijo (última vez) | `${var##*patron}` | `${g##*,}` | Quita hasta la última coma |
| Eliminar sufijo (corto, desde la derecha) | `${var%patron*}` | `${g%,*}` | Quita desde la última coma |
| Eliminar sufijo (largo, desde la derecha) | `${var%%patron*}` | `${g%%,*}` | Deja solo el primer elemento |
| Quitar una extensión | `${var%.ext}` | `${f%.fasta}` | `KP_UCI_001.fasta` → `KP_UCI_001` |
| Reemplazar primera ocurrencia | `${var/buscar/nuevo}` | `${s/T/U}` | Cambia la primera T |
| Reemplazar todas las ocurrencias | `${var//buscar/nuevo}` | `${s//T/U}` | Cambia todas las T |

---

## 📚 Referencias Bibliográficas

1. Blum, R., & Bresnahan, C. (2021). *Linux Command Line and Shell Scripting Bible* (4th ed.). Wiley. Capítulo 11.

2. Documentación oficial de Bash — String manipulation:  
   [https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameter-Expansion](https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameter-Expansion)

3. ShellCheck — Verificador de sintaxis online:  
   [https://www.shellcheck.net/](https://www.shellcheck.net/)

---

> 🎓 *"Cada pipeline de análisis genómico que usas hoy fue construido con estas mismas herramientas. Dominar la manipulación de cadenas en Bash es el primer paso para automatizar el procesamiento de miles de secuencias."*

---

*Documento preparado para la Sesión 08 - Semana 10 del curso Principios de Programación en Bioinformática. UPC exígete, innova.*
