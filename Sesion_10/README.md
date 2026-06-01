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

**Palabras clave:** Shell scripting, strings, subcadenas, manipulación de texto, automatización

---

## 📋 Pre-requisitos

- Acceso a Google Cloud Shell o cualquier terminal Linux
- Haber completado la Sesión 9 (creación y ejecución de scripts básicos en Bash)
- Saber usar `nano` o `vim` para editar archivos

---

## 🧠 1. Repaso Rápido: ¿Qué aprendimos la sesión pasada?

Antes de continuar, recordemos los tres elementos que todo script necesita:

```bash
#!/bin/bash                        # 1. Shebang: le dice al sistema qué intérprete usar
# Autor: Mi nombre                 # 2. Comentarios: explican qué hace el código
echo "¡Hola desde mi script!"      # 3. Código ejecutable: los comandos que corren
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
Fecha        : Mon Jun  2 13:05:00 UTC 2025
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
3. Extremo 3' (últimos 6nt) : GATTT
4. ARN mensajero            : AUGCUUGCAAUCGAUCGAUUU

Análisis completado.
```

---

## 📸 8. Actividad Asincrónica

### 🎯 Misión: Construir tu propio kit de herramientas de secuencias

Vas a crear **3 scripts** que simulan herramientas básicas de un laboratorio de bioinformática. Cada script aplica lo aprendido hoy.

---

### 🧬 Script 1: `calculadora_secuencia.sh` *(Obligatorio)*

**Objetivo:** Pedir al usuario una secuencia de ADN e informar su longitud, los primeros 3 nucleótidos (posible codón de inicio) y el extremo 3'.

**Requisitos:**
- Usar `read -p` para pedir la secuencia
- Calcular la longitud con `${#variable}`
- Extraer los primeros 3 nucleótidos con subcadenas
- Extraer los últimos 3 nucleótidos con índice negativo

**Salida de ejemplo:**
```
Secuencia ingresada : ATGCCCGTATTTAAGCCC
Longitud            : 18 nucleótidos
Posibles inicio 5'  : ATG
Extremo 3'          : CCC
```

---

### 🔬 Script 2: `transcriptor.sh` *(Obligatorio)*

**Objetivo:** Pedir al usuario una secuencia de ADN, convertirla a ARN mensajero y mostrar ambas secuencias con el número de bases modificadas.

**Requisitos:**
- Usar `read -p` para pedir la secuencia de ADN
- Hacer la conversión T→U con `${variable//T/U}`
- Mostrar el ADN original y el ARN resultante
- Mostrar la longitud de ambas (deben ser iguales)

**Salida de ejemplo:**
```
=== TRANSCRIPCIÓN: ADN → ARNm ===
ADN (5'→3') : ATGCTTGCAATCGATCGATTT
ARN (5'→3') : AUGCUUGCAAUCGAUCGAUUU
Longitud    : 21 bases (sin cambios)
```

---

### 🧩 Script 3: `lector_genes.sh` *(Obligatorio)*

**Objetivo:** Dado una lista de genes separados por comas, extraer el primer gen, el último gen, y la lista sin el primer gen.

**Requisitos:**
- Usar `read -p` para pedir la lista de genes (ej: `BRCA1,TP53,PTEN,ATM`)
- Extraer el primer gen con `${variable%%,*}`
- Extraer el último gen con `${variable##*,}`
- Mostrar la lista sin el primer gen con `${variable#*,}`

**Salida de ejemplo:**
```
Lista ingresada  : BRCA1,TP53,PTEN,ATM
Primer gen       : BRCA1
Último gen       : ATM
Resto de la lista: TP53,PTEN,ATM
```

---

### 🏆 Script Bonus: `analizador_completo.sh` *(Opcional — para nota extra)*

Combina los 3 scripts anteriores en uno solo, más un paso adicional: que el usuario pueda ingresar también el nombre del organismo y la fecha del análisis, generando un reporte de texto con todo.

El reporte debe guardarse en un archivo llamado `reporte_analisis.txt` usando redirección:

```bash
echo "Reporte generado el $(date)" > reporte_analisis.txt
echo "Organismo: $organismo" >> reporte_analisis.txt
# ... continúa el reporte
```

---

### ✅ Checklist de entrega

Antes de subir a GitHub, verifica:

- [ ] Los 3 scripts obligatorios están creados
- [ ] Cada script tiene el shebang `#!/bin/bash` en la primera línea
- [ ] Cada script tiene al menos un comentario con tu nombre y la fecha
- [ ] Todos tienen permisos de ejecución (`chmod +x nombre_script.sh`)
- [ ] Los 3 scripts ejecutan sin errores
- [ ] Incluiste capturas de pantalla de la ejecución de cada script
- [ ] Subiste todo a tu repositorio GitHub con un mensaje de commit descriptivo (ej: `git commit -m "Sesion 10: scripts de manipulacion de cadenas"`)

---

## 🗂️ Resumen de Comandos de la Sesión

| Operación | Sintaxis | Ejemplo | Resultado |
|-----------|----------|---------|-----------|
| Leer entrada del usuario | `read -p "Mensaje: " var` | `read -p "Nombre: " n` | Guarda lo escrito en `n` |
| Medir longitud | `${#variable}` | `${#"ATCG"}` | `4` |
| Extraer subcadena | `${var:inicio:largo}` | `${s:0:3}` | Primeros 3 caracteres |
| Extraer desde el final | `${var: -n}` | `${s: -3}` | Últimos 3 caracteres |
| Eliminar prefijo (1ra vez) | `${var#*patron}` | `${g#*,}` | Quita hasta la 1ra coma |
| Eliminar prefijo (última vez) | `${var##*patron}` | `${g##*,}` | Quita hasta la última coma |
| Eliminar sufijo (1ra vez) | `${var%patron*}` | `${f%.txt}` | Quita extensión `.txt` |
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
