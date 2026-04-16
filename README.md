# 🧬 1ABL0014 — Principios de Programación en Bioinformática

> **Programa de Biología · Universidad Peruana de Ciencias Aplicadas (UPC)**  
> **Facultad de Ciencias de la Salud · Ciclo Cuarto · 2 créditos · 4 horas prácticas semanales**  
> Docente: Manuel Ramírez Sáenz · Coordinación: Frank Guzman Escudero

---

## 📌 ¿De qué trata este curso?

La bioinformática moderna no puede entenderse sin programación. Este curso te introduce al sistema operativo **GNU/Linux** y al lenguaje de scripting **Shell (Bash)**, que son la base de prácticamente todas las herramientas bioinformáticas: alineadores de secuencias, ensambladores de genomas, pipelines de RNA-seq, análisis de variantes, y mucho más.

> 💡 *Si alguna vez has visto un pipeline de análisis genómico y te preguntaste "¿cómo funciona eso?", este curso te dará las herramientas para entenderlo y construir el tuyo propio.*

---

## 📅 Calendario de sesiones

### Unidad I — Introducción a GNU/Linux *(Semanas 1–8)*

| Semana | Sesión | Tema | Estado | Material |
|--------|--------|------|--------|---------|
| 1 | S00 | Presentación del curso | ✅ Disponible | [→ sesion_00](./sesion_00_introduccion/) |
| 2 | S01 | Sistemas operativos y GNU/Linux. Terminal y comandos básicos | ✅ Disponible | [→ sesion_01](./sesion_01/) |
| 3 | S02 | Ambiente de trabajo | ✅ Disponible | [→ sesion_02](./sesion_02/) |
| 4 | S03 | Sistemas de archivos | ✅ Disponible | [→ sesion_03](./sesion_03/) |
| 5 | S04 | **Flujo de datos** | ✅ Disponible | [→ sesion_04](./sesion_04/) |
| 6 | S05 | Búsqueda de patrones | 🔜 Próximamente | — |
| 7 | S06 | Manipulación de texto | 🔜 Próximamente | — |
| 8 | —   | **LB1 — Laboratorio 1** | 📝 Semana 8 | — |

### Unidad II — Shell Scripting *(Semanas 9–16)*

| Semana | Sesión | Tema | Estado | Material |
|--------|--------|------|--------|---------|
| 9  | S07 | Introducción a Shell scripting | 🔜 Próximamente | — |
| 10 | S08 | **TP — Trabajo Parcial** | 📝 Semana 10 | — |
| 11 | S09 | Variables y estructuras de control | 🔜 Próximamente | — |
| 12 | S10 | Bucles y funciones | 🔜 Próximamente | — |
| 13 | S11 | Scripts para bioinformática I | 🔜 Próximamente | — |
| 14 | S12 | Scripts para bioinformática II | 🔜 Próximamente | — |
| 15 | S13 | Integración y pipelines | 🔜 Próximamente | — |
| 16 | —   | **LB2 + TF — Laboratorio 2 y Trabajo Final** | 📝 Semana 16 | — |

---

## 📊 Evaluación

```
Nota Final = LB1 (25%) + TP (25%) + LB2 (25%) + TF (25%)
```

| Evaluación | Descripción | Peso | Semana |
|------------|-------------|------|--------|
| **LB1** — Laboratorio 1 | Examen práctico individual: comandos Linux y gestión de archivos | 25% | 8 |
| **TP** — Trabajo Parcial | Presentación grupal sobre lenguajes de programación en bioinformática | 25% | 10 |
| **LB2** — Laboratorio 2 | Examen práctico individual: Shell scripting aplicado | 25% | 16 |
| **TF** — Trabajo Final | Script Shell que resuelve un problema biológico real + sustentación oral | 25% | 16 |

> 📋 **Ficha del curso:** 2 créditos · 4 horas prácticas semanales · Ciclo Cuarto · Semestre 2026-1

---

## 🗂️ Estructura del repositorio

```
1ABL0014-Principios-Programacion-Bioinformatica/
│
├── README.md                          ← Estás aquí
│
├── sesion_00_introduccion/            ← Presentación del curso
│   ├── README.md
│   └── slides_resumen.md
│
├── sesion_01/                         ← SO, GNU/Linux, terminal básica
│   ├── README.md
│   └── practica_guiada.sh
│
├── sesion_02/                         ← Ambiente de trabajo
│   ├── README.md
│   ├── practica_guiada.sh
│   └── datos/
│       ├── README.md
│       ├── ecoli_K12.fasta
│       └── salmonella_enterica.fasta
│
├── sesion_03/                         ← Sistemas de archivos
│   ├── README.md
│   ├── practica_guiada.sh
│   └── datos/
│       ├── README.md
│       └── homo_sapiens_COX1.fasta
│
├── sesion_04/                         ← Flujo de datos  ← NUEVO
│   ├── README.md
│   ├── practica_guiada.sh
│   └── datos/
│       ├── README.md
│       ├── ecoli_genes.fasta
│       ├── genes_resistencia.fasta
│       ├── especies_genomicas.tsv
│       └── pipeline_rnaseq.log
│
└── recursos/
    └── links_utiles.md
```

---

## 🛠️ Herramientas del curso

| Herramienta | ¿Para qué? | Cómo acceder |
|-------------|-----------|-------------|
| **Google Cloud Shell** | Terminal Linux en la nube (sin instalar nada) | [shell.cloud.google.com](https://shell.cloud.google.com) |
| **GitHub** | Repositorio de materiales del curso | Este repositorio |
| **NCBI** | Base de datos de secuencias biológicas | [ncbi.nlm.nih.gov](https://www.ncbi.nlm.nih.gov) |

---

## 📖 Bibliografía

| Referencia | Editorial | Uso en el curso |
|------------|-----------|-----------------|
| Hausenblas, M. (2022). *Learning Modern Linux*. O'Reilly | O'Reilly | Semanas 1–4 |
| Shotts, W. (2019). *The Linux Command Line* (2a ed.). No Starch Press | No Starch | Referencia general |
| Kothari et al. (2011). *Linux*. New Age International | New Age | **Semana 4** |
| Parker, S. (2011). *Shell Scripting: Expert Recipes*. Wiley | Wiley | Semanas 13–14 |
| Foster-Johnson et al. (2005). *Beginning Shell Scripting*. Wiley | Wiley | Semana 14 |
| Sobell & Helmke (2017). *A Practical Guide to Linux Commands* (4a ed.). Pearson | Pearson | Referencia general |
| Akalin, A. (2021). *Computational Genomics with R*. CRC | CRC | Semana 1 — contexto |
| Curry, E. R. (2020). *Introduction to Bioinformatics with R*. CRC | CRC | Semana 1 — contexto |

Todos los libros están disponibles en el [catálogo UPC](https://catalogo.upc.edu.pe).

---

## 🚀 Cómo usar este repositorio

```bash
# Primera vez: clonar el repositorio
git clone https://github.com/TU_USUARIO/1ABL0014-Principios-Programacion-Bioinformatica.git
cd 1ABL0014-Principios-Programacion-Bioinformatica

# Semanas siguientes: actualizar
git pull

# Ir a la sesión de la semana
cd sesion_04/
```

---

## 👨‍🏫 Equipo docente

| Docente | Rol | Contacto |
|--------|-----|---------|
| Frank Guzman Escudero | Coordinación del curso | PCBLFGUZ@upc.edu.pe |
| Manuel Ramírez Sáenz | Docente | PCBLMRAM@upc.edu.pe |

---

*Repositorio mantenido por Manuel Ramírez Sáenz · Semestre 2026-1*
