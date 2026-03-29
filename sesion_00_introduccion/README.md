# 📘 Sesión 00 — Presentación del Curso

> **Curso:** 1ABL0014 · Principios de Programación en Bioinformática  
> **Tipo de sesión:** Introductoria / Presentación del curso  
> **Duración:** 230 minutos

---

## 🎯 Objetivo de esta sesión

Conocer la estructura del curso, el sistema de evaluación, los recursos disponibles y —lo más importante— entender **por qué un biólogo necesita saber programar**.

---

## 🧬 ¿Por qué un biólogo necesita programar?

Esta es una pregunta que probablemente te hayas hecho. La respuesta es simple: la biología moderna genera datos a una velocidad y escala que es imposible analizar a mano.

### El problema del volumen de datos

Imagina que quieres comparar el genoma de dos cepas de *Mycobacterium tuberculosis* para entender por qué una es resistente a antibióticos. Cada genoma tiene ~4.4 millones de pares de bases. No puedes revisar eso manualmente en una hoja de Excel. Necesitas herramientas computacionales.

> 🔬 **Ejemplo real:** Durante la pandemia de COVID-19, equipos bioinformáticos como GISAID procesaron millones de genomas del virus SARS-CoV-2 para rastrear variantes (Alpha, Delta, Omicron) en tiempo casi real. Esto fue posible gracias a pipelines automatizados escritos en Shell y Python.

### La cadena de análisis bioinformático

```
Muestra biológica
       ↓
Secuenciación (datos crudos: archivos FASTQ)
       ↓
Control de calidad (FastQC, Trimmomatic)
       ↓
Alineamiento / Ensamblaje (BWA, STAR, SPAdes)
       ↓
Análisis específico (variantes, expresión génica, etc.)
       ↓
Visualización e interpretación
```

> **Cada una de estas etapas se ejecuta desde la terminal de Linux.** Por eso este curso empieza desde allí.

---

## 🐧 ¿Qué es GNU/Linux y por qué es el sistema de los bioinformáticos?

GNU/Linux es un sistema operativo de código abierto que domina los servidores, clusters de cómputo y supercomputadoras del mundo. Más del **96% de los servidores de internet** corren Linux.

### ¿Por qué Linux en bioinformática?

| Razón | Explicación |
|-------|-------------|
| **Gratuito y open source** | Las herramientas bioinformáticas son mayormente gratuitas en Linux |
| **Potencia en la línea de comandos** | Puedes procesar miles de archivos con una sola línea |
| **Compatibilidad** | BLAST, BWA, SAMtools, GATK... todas corren nativamente en Linux |
| **Reproducibilidad** | Los scripts documentan exactamente qué se hizo y cómo |
| **Servidores y HPC** | Los clústeres de cómputo usan Linux; necesitas saber operarlo |

> 💡 *Aunque uses Windows o Mac en casa, aprenderás a conectarte a servidores Linux, que es donde se hace la ciencia real de datos genómicos.*

---

## 🖥️ ¿Qué es Shell Scripting?

El **Shell** (también llamado Bash) es el intérprete de comandos de Linux. Es el lenguaje que le hablas a la terminal.

Un **script** es simplemente un archivo de texto con una serie de comandos que se ejecutan en orden, como una receta de cocina automatizada.

### Ejemplo conceptual

Imagina que tienes 100 archivos FASTQ (lecturas de secuenciación) y quieres correr FastQC en todos ellos. Sin scripting, tendrías que ejecutar 100 comandos manualmente. Con un script:

```bash
#!/bin/bash
# Script para correr FastQC en todos los archivos FASTQ de un directorio

for archivo in *.fastq.gz; do
    echo "Procesando: $archivo"
    fastqc "$archivo" --outdir resultados/
done
echo "¡Análisis completo!"
```

> ✅ Con 8 líneas de código automatizas horas de trabajo manual. Este es el poder del Shell scripting.

---

## 📋 Estructura del curso

### Unidad I — Introducción a GNU/Linux
*(Semanas 1–7)*

Aprenderás a moverte dentro del sistema operativo Linux usando únicamente la terminal:
- Navegar directorios, crear y eliminar archivos
- Permisos y usuarios
- Redirección de entradas/salidas
- Comandos esenciales para bioinformática: `grep`, `awk`, `sed`, `sort`, `uniq`

### Unidad II — Shell Scripting
*(Semanas 8–16)*

Construirás tus propios programas en Bash:
- Variables, condicionales y bucles
- Funciones y modularización
- Scripts para automatizar análisis bioinformáticos
- **Trabajo final:** Script Shell que resuelve un problema biológico real

---

## 📊 ¿Cómo me van a evaluar?

### Resumen de evaluaciones

```
Nota Final = 10%(DD1) + 15%(PC1) + 25%(TP) + 10%(DD2) + 15%(PC2) + 25%(TF)
```

| Evaluación | Qué es | Cuánto pesa |
|-----------|--------|------------|
| **DD1 y DD2** (Desempeño) | Actividades semanales + preguntas al final de sesión | 20% total |
| **PC1 y PC2** (Prácticas) | Exámenes virtuales: opción múltiple, V/F y desarrollo | 30% total |
| **TP** (Trabajo Parcial) | Presentación grupal: lenguajes de programación en bioinformática | 25% |
| **TF** (Trabajo Final) | Script Shell que soluciona un problema biológico + presentación oral | 25% |

### Detalle de las evaluaciones de desempeño (DD)

Las DD se acumulan de dos formas:
- **5% por unidad:** entrega semanal de informes de actividades asíncronas (Blackboard)
- **5% por unidad:** preguntas al cierre de cada sesión en el aula virtual

> ⚠️ **Las DD no son recuperables.** Sé constante desde la primera semana.

### Trabajo Final — lo que construirás

Al final del curso presentarás **un script en Bash que resuelva un problema biológico real**. Algunos ejemplos de trabajos anteriores:
- Script para descargar y filtrar secuencias de GenBank según criterios taxonómicos
- Pipeline para comparar calidad de secuencias antes y después de trimming
- Script para buscar motivos regulatorios en secuencias promotoras

---

## 🖥️ Aula virtual (Blackboard Collaborate)

Todos los materiales del curso están en el **aula virtual**. Revísala constantemente.

| Recurso | Qué encontrarás |
|---------|----------------|
| Sílabo | Contenido detallado semana a semana |
| PPTs de clase | Diapositivas de cada sesión |
| Fichas y materiales | Guías prácticas y ejercicios |
| Bibliografía | Libros y artículos de referencia |
| Evaluaciones | Entregas y exámenes |
| Mensajes docentes | ¡Léelos! Contienen instrucciones importantes |

---

## ⏰ Información logística

| Ítem | Detalle |
|------|---------|
| **Duración de sesión** | 230 minutos |
| **Tolerancia de ingreso** | 15 minutos |
| **Máximo de inasistencias** | 3 sesiones (25% del total) |

> ⚠️ Superar el 25% de inasistencias implica desaprobación automática del curso según el Reglamento del Estudiante UPC.

---

## 🌟 Claves para tener éxito en este curso

Para los que se inician en programación, estos cinco pilares marcan la diferencia:

```
🔥 MOTIVACIÓN      → Recuerda por qué estás aquí: la programación abre puertas
🙋 PARTICIPACIÓN   → Pregunta sin miedo, todos comenzamos desde cero
✅ RESPONSABILIDAD → Las DD son semanales; no dejes que se acumulen
🤝 TRABAJO EN EQUIPO → Los trabajos grupales replican la dinámica real de investigación
⏱️ PUNTUALIDAD     → En bioinformática, los tiempos de cómputo importan (y en clase, también)
```

---

## 📚 Recursos recomendados para arrancar

### Para instalar y practicar Linux desde ya

| Opción | Descripción | Enlace |
|--------|-------------|--------|
| **WSL2 (Windows)** | Linux dentro de Windows 10/11 | [Instalar WSL2](https://learn.microsoft.com/es-es/windows/wsl/install) |
| **Ubuntu VM** | VirtualBox + Ubuntu | [Ubuntu Desktop](https://ubuntu.com/download/desktop) |
| **The Odin Project** | Fundamentos de línea de comandos (gratis) | [theodinproject.com](https://www.theodinproject.com) |
| **Linux Journey** | Tutorial interactivo de Linux | [linuxjourney.com](https://linuxjourney.com) |

### Lecturas introductorias

- Pevsner, J. (2015). *Bioinformatics and Functional Genomics*. Wiley-Blackwell.
- Bioinformatics Data Skills — Vince Buffalo (O'Reilly) — *el manual de cabecera de este curso*
- [A Primer for Computational Biology](https://open.oregonstate.education/computationalbiology/) — Open Oregon State (libre y gratuito)

---

## ❓ Preguntas frecuentes

**¿Necesito experiencia previa en programación?**  
No. El curso está diseñado para estudiantes de biología sin conocimientos previos de informática.

**¿Qué sistema operativo necesito en mi computadora?**  
Cualquiera. Aprenderemos a instalar y usar Linux en entornos virtuales o WSL2.

**¿Es difícil Shell scripting?**  
Al principio puede parecer intimidante, pero con práctica constante verás que es muy lógico. La clave está en practicar los comandos todos los días, aunque sea 15 minutos.

**¿Para qué me sirve esto después del curso?**  
Para prácticamente cualquier análisis bioinformático: NGS, metagenómica, proteómica, modelado molecular. Es la base de todo.

---

*Próxima sesión → [Sesión 01](../sesion_01/README.md)*

