# 🧬 1ABL0014 — Principios de Programación en Bioinformática

> **Programa de Biología · Facultad de Ciencias de la Salud**  
> **Universidad Peruana de Ciencias Aplicadas (UPC) · Semestre 2026-1**  
> Docentes: Frank Guzman Escudero · Manuel Ramírez Sáenz

---

## 📌 ¿De qué trata este curso?

La bioinformática moderna no puede entenderse sin programación. Este curso te introduce al sistema operativo **GNU/Linux** y al lenguaje de scripting **Shell (Bash)**, que son la base de prácticamente todas las herramientas bioinformáticas: alineadores de secuencias, ensambladores de genomas, pipelines de RNA-seq, análisis de variantes, y mucho más.

> 💡 Si alguna vez viste un pipeline de análisis genómico y te preguntaste *"¿cómo funciona eso?"*, este curso te dará las herramientas para entenderlo y construir el tuyo propio.

---

## 🚀 Cómo usar este repositorio

```bash
# Clona el repositorio en Google Cloud Shell o tu terminal local
git clone https://github.com/[usuario]/1ABL0014-Principios-Programacion-Bioinformatica.git
cd 1ABL0014-Principios-Programacion-Bioinformatica

# Para actualizar antes de cada sesión
git pull
```

> 🖥️ **Entorno de trabajo del curso:** [Google Cloud Shell](https://shell.cloud.google.com) — no requiere instalación, funciona desde el navegador.

---

## 📅 Calendario de sesiones

### Unidad I — Introducción a GNU/Linux *(Semanas 1–8)*

| Semana | Sesión | Tema | Estado | Material |
|--------|--------|------|--------|---------|
| 1 | S00 | Presentación del curso | ✅ Disponible | [→ sesion_00](./sesion_00_introduccion/) |
| 2 | S01 | Sistemas operativos y GNU/Linux. Terminal y comandos básicos | ✅ Disponible | [→ sesion_01](./sesion_01/) |
| 3 | S02 | Ambiente de trabajo | ✅ Disponible | [→ sesion_02](./sesion_02/) |
| 4 | S03 | Sistemas de archivos | ✅ Disponible | [→ sesion_03](./sesion_03/) |
| 5 | S04 | Flujo de datos | 🔜 Próximamente | — |
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

> 📋 **Ficha del curso:** 2 créditos · 4 horas prácticas semanales · Ciclo Cuarto

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
│       ├── salmonella_enterica.fasta
│       └── [otros archivos FASTA]
│
├── sesion_03/                         ← Sistemas de archivos
│   ├── README.md
│   ├── practica_guiada.sh
│   └── datos/
│       ├── README.md
│       └── homo_sapiens_COX1.fasta
│
└── recursos/
    └── links_utiles.md
```

---

## 🛠️ Herramientas del curso

| Herramienta | ¿Para qué? | Acceso |
|-------------|-----------|--------|
| **Google Cloud Shell** | Entorno Linux en la nube, sin instalación | [shell.cloud.google.com](https://shell.cloud.google.com) |
| **GNU/Linux (Ubuntu)** | Sistema operativo base de la bioinformática | Cloud Shell o instalación local |
| **Bash / Shell** | Automatización y scripting | Incluido en Linux |
| **Git & GitHub** | Control de versiones y acceso a materiales | Este repositorio |
| **NCBI** | Descarga de secuencias biológicas | [ncbi.nlm.nih.gov](https://www.ncbi.nlm.nih.gov) |

---

## 📚 Bibliografía principal

| Libro | Autores | Uso en el curso |
|-------|---------|----------------|
| *Bioinformatics Data Skills* | Vince Buffalo | Semanas 1–8 (Unidad I) |
| *Linux Command Line and Shell Scripting Bible* (4ª ed.) | Blum & Bresnahan | Semanas 1–16 (ambas unidades) |
| *Bioinformatics and Functional Genomics* (3ª ed.) | Jonathan Pevsner | Referencia general |
| *A Primer for Computational Biology* | Shawn T. O'Neil | Complementario, acceso libre |
| *The Unix Workbench* | Sean Kross | Complementario, acceso libre |

---

## 👨‍🏫 Equipo docente

| Docente | Rol |
|---------|-----|
| Frank Guzman Escudero | Coordinador del curso |
| Manuel Ramírez Sáenz | Docente |

---

## 🔗 Recursos rápidos

- 📖 [Recursos y enlaces útiles](./recursos/links_utiles.md)
- 🐚 [Linux Journey](https://linuxjourney.com) — tutorial interactivo gratuito
- 🧩 [Rosalind](http://rosalind.info) — problemas de bioinformática para resolver con código
- 📘 [Bash Guide for Beginners](https://tldp.org/LDP/Bash-Beginners-Guide/html/) — guía oficial

---

*Repositorio mantenido por el equipo docente · Semestre 2026-1 · UPC*
