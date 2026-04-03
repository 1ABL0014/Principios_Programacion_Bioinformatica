# 🧬 Principios de Programación en Bioinformática

> **Código:** 1ABL0014 | **Créditos:** 2 | **Horas prácticas:** 4 hrs/semana  
> **Programa:** Biología — Facultad de Ciencias de la Salud  
> **Universidad:** Universidad Peruana de Ciencias Aplicadas (UPC)  
> **Semestre:** 2026-1 | **Ciclo:** 4

---

## 👨‍🏫 Docentes

| Nombre | Correo |
|--------|--------|
| Frank Guzman Escudero | PCBLFGUZ@upc.edu.pe |
| Manuel Ramírez Sáenz | PCBLMRAM@upc.edu.pe |

---

## 📌 ¿Qué es este repositorio?

Este repositorio es el **recurso principal del curso**. Aquí encontrarás los materiales de cada sesión, enriquecidos con contexto bioinformático, ejemplos prácticos, pipelines reales y preguntas de autoevaluación.

El objetivo es que este espacio sea tu **referencia de consulta** durante el semestre y más allá de él.

---

## 🧪 Descripción del curso

La bioinformática es el puente entre la biología y la informática. Este curso te entrega las **herramientas computacionales fundamentales** que usan los investigadores para analizar datos genómicos, proteómicos y transcriptómicos.

Al finalizar el curso, podrás:
- Trabajar con fluidez en entornos GNU/Linux
- Gestionar archivos y datos biológicos desde la terminal
- Programar en Python para automatizar análisis biológicos
- Instalar, configurar y ejecutar herramientas bioinformáticas
- Comprender y manipular formatos de datos biológicos estándar (FASTA, FASTQ, SAM/BAM, VCF)

---

## 📊 Evaluación

| Componente | Peso | Descripción |
|---|---|---|
| **LB1** — Laboratorio 1 | 25% | Evaluación práctica semanas 1–8 |
| **TP** — Trabajo Parcial | 25% | Proyecto integrador semanas 1–8 |
| **LB2** — Laboratorio 2 | 25% | Evaluación práctica semanas 9–16 |
| **TF** — Trabajo Final | 25% | Proyecto integrador semanas 9–16 |

> **Nota mínima aprobatoria:** 13 (escala vigesimal peruana)

---

## 🗓️ Contenido del Curso — 16 Semanas

### Unidad 1: Fundamentos del Entorno de Trabajo

| Semana | Sesión | Tema | Estado |
|--------|--------|------|--------|
| 1 | [Sesión 00](session_00/) | Introducción al curso y a la bioinformática | ✅ Disponible |
| 1 | [Sesión 01](session_01/) | Sistemas Operativos — Linux y la terminal | ✅ Disponible |
| 2 | [**Sesión 02**](session_02/) | **Ambiente de Trabajo — CLI y Conda** | ✅ Disponible |
| 3 | [Sesión 03](session_03/) | Estructura de Directorios y Gestión de Archivos | 🔜 Próximamente |
| 4 | [Sesión 04](session_04/) | Editores de Texto y Scripts Bash | 🔜 Próximamente |

### Unidad 2: Programación en Python para Bioinformática

| Semana | Sesión | Tema | Estado |
|--------|--------|------|--------|
| 5 | [Sesión 05](session_05/) | Introducción a Python — Variables y Tipos de Datos | 🔜 Próximamente |
| 6 | [Sesión 06](session_06/) | Estructuras de Control — Condicionales y Bucles | 🔜 Próximamente |
| 7 | [Sesión 07](session_07/) | Funciones y Módulos | 🔜 Próximamente |
| 8 | [Sesión 08](session_08/) | Biopython — Manejo de Secuencias Biológicas | 🔜 Próximamente |

### Unidad 3: Formatos y Bases de Datos Biológicas

| Semana | Sesión | Tema | Estado |
|--------|--------|------|--------|
| 9 | [Sesión 09](session_09/) | Formatos FASTA, FASTQ y Control de Calidad | 🔜 Próximamente |
| 10 | [Sesión 10](session_10/) | Bases de Datos Biológicas — NCBI, UniProt, Ensembl | 🔜 Próximamente |
| 11 | [Sesión 11](session_11/) | Alineamiento de Secuencias — BLAST y Aplicaciones | 🔜 Próximamente |
| 12 | [Sesión 12](session_12/) | Formatos SAM/BAM y Mapeo al Genoma de Referencia | 🔜 Próximamente |

### Unidad 4: Pipelines y Análisis Avanzados

| Semana | Sesión | Tema | Estado |
|--------|--------|------|--------|
| 13 | [Sesión 13](session_13/) | Variantes Genéticas — Formato VCF y Anotación | 🔜 Próximamente |
| 14 | [Sesión 14](session_14/) | Análisis de Expresión Génica — RNA-seq Básico | 🔜 Próximamente |
| 15 | [Sesión 15](session_15/) | Automatización de Pipelines con Bash y Snakemake | 🔜 Próximamente |
| 16 | [Sesión 16](session_16/) | Presentación de Proyectos Finales | 🔜 Próximamente |

---

## 🚀 ¿Cómo empezar?

### 1. Configura tu ambiente de trabajo

Si aún no tienes GNU/Linux, elige una de estas opciones (detalladas en la [Sesión 02](session_02/)):

```bash
# Opción A: WSL2 en Windows (más rápido para empezar)
wsl --install -d Ubuntu-22.04

# Opción B: Ubuntu nativo o VirtualBox
# Ver instrucciones en session_02/README.md
```

### 2. Instala Miniconda

```bash
mkdir -p ~/miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh \
     -O ~/miniconda3/miniconda.sh
bash ~/miniconda3/miniconda.sh -b -u ~/miniconda3
rm -f ~/miniconda3/miniconda.sh
~/miniconda3/bin/conda init bash
source ~/.bashrc
```

### 3. Configura los canales de Conda

```bash
conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge
```

### 4. Clona este repositorio

```bash
git clone https://github.com/[usuario]/principios-bioinformatica-upc.git
cd principios-bioinformatica-upc
```

---

## 📁 Estructura del Repositorio

```
principios-bioinformatica-upc/
│
├── README.md                    ← este archivo
├── .gitignore
├── resources/
│   ├── cheatsheet.md            ← referencia rápida de comandos
│   ├── useful_links.md          ← enlaces recomendados
│   └── github_setup.md          ← guía para configurar GitHub
│
├── session_00/
│   └── README.md                ← Introducción al curso
│
├── session_01/
│   └── README.md                ← Sistemas Operativos
│
├── session_02/
│   └── README.md                ← Ambiente de Trabajo ← ESTÁS AQUÍ
│
└── session_03/ ... session_16/  ← Próximamente
```

---

## 📚 Bibliografía del Curso

| # | Referencia | Semanas |
|---|------------|---------|
| 1 | Blum, R. & Bresnahan, C. (2021). *Linux command line and Shell scripting bible* (4th ed.). Wiley | 1–4 |
| 2 | Kross, S. (2017). *The Unix Workbench*. Leanpub | 1–4 |
| 3 | Griffiths, A. et al. (2015). *Introduction to Genetic Analysis* (11th ed.). W.H. Freeman | 1–4 |
| 4 | Cock, P. et al. (2009). Biopython: freely available Python tools for computational biology. *Bioinformatics* | 5–8 |
| 5 | Lutz, M. (2013). *Learning Python* (5th ed.). O'Reilly | 5–8 |
| 6 | Altschul, S.F. et al. (1990). Basic local alignment search tool. *J. Mol. Biol.* | 9–12 |
| 7 | Li, H. et al. (2009). The Sequence Alignment/Map format and SAMtools. *Bioinformatics* | 9–12 |
| 8 | DePristo, M. et al. (2011). A framework for variation discovery using next-generation DNA sequencing data. *Nature Genetics* | 13–16 |
| 9 | Andrews, S. (2010). FastQC: A quality control tool for high throughput sequence data | 9–12 |
| 10 | Bolger, A.M. et al. (2014). Trimmomatic: a flexible trimmer for Illumina sequence data. *Bioinformatics* | 9–12 |
| 11 | Love, M.I. et al. (2014). Moderated estimation of fold change and dispersion for RNA-seq data. *Genome Biology* | 13–16 |

---

## 🛠️ Recursos de Apoyo

| Recurso | Descripción | Enlace |
|---------|-------------|--------|
| Cheatsheet | Referencia rápida de comandos Linux y Conda | [Ver](resources/cheatsheet.md) |
| GitHub Setup | Cómo crear tu cuenta y trabajar con Git | [Ver](resources/github_setup.md) |
| Useful Links | Bases de datos, tutoriales y herramientas recomendadas | [Ver](resources/useful_links.md) |

---

## 💡 Consejos para el Éxito en el Curso

1. **Practica a diario**: 30 minutos de terminal por día valen más que 3 horas el fin de semana.
2. **No copies y pegues comandos sin leerlos**: entiende qué hace cada parte antes de ejecutar.
3. **Usa `--help` y `man`**: casi todo programa tiene documentación integrada.
4. **Mantén un diario de comandos**: anota los que uses frecuentemente.
5. **Los errores son normales**: aprende a leer los mensajes de error, son tus mejores maestros.
6. **Organiza tus proyectos desde el inicio**: una buena estructura de carpetas te ahorra horas.

---

<div align="center">

**Universidad Peruana de Ciencias Aplicadas — UPC**  
Facultad de Ciencias de la Salud | Programa de Biología  
*Exígete, innova*

</div>
