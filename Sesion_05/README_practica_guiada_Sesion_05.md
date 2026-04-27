# Datos — Sesión 05

Archivos de práctica para la sesión de Comandos básicos I.

---

## Archivos disponibles

### `genes.txt`
Lista de 20 nombres de genes humanos relacionados con cáncer (con duplicados intencionales para practicar `sort -u`).

```bash
cat genes.txt
# Salida: lista de 20 genes (TP53, BRCA1, EGFR, PTEN, KRAS, MYC...)

sort genes.txt
# Salida: lista ordenada alfabéticamente

sort -u genes.txt
# Salida: 11 genes únicos sin duplicados
```

---

### `samples.txt`
Identificadores de 6 muestras biológicas. Úsalo junto con `genes.txt` y `expression.txt` para practicar `paste`.

```bash
cat samples.txt
# muestra_01
# muestra_02
# ...
# muestra_06
```

---

### `expression.txt`
Valores de expresión génica (log2 fold-change) para 6 muestras. Corresponde línea a línea con `samples.txt`.

```bash
cat expression.txt
# 12.5
# 8.3
# ...
```

**Práctica con `paste`:**

```bash
paste samples.txt genes.txt expression.txt
# Salida esperada:
# muestra_01   TP53    12.5
# muestra_02   BRCA1   8.3
# muestra_03   EGFR    20.1
# muestra_04   PTEN    5.7
# muestra_05   KRAS    15.9
# muestra_06   MYC     3.2

paste -d ":" samples.txt genes.txt expression.txt
# muestra_01:TP53:12.5
# muestra_02:BRCA1:8.3
# ...
```

---

### `seqs_1.fasta`
5 secuencias del gen **rbcL** (RuBisCO subunidad grande) de plantas modelo:
- *Arabidopsis thaliana*
- *Oryza sativa* (arroz)
- *Zea mays* (maíz)
- *Glycine max* (soya)
- *Solanum lycopersicum* (tomate)

```bash
grep -c ">" seqs_1.fasta
# 5

grep ">" seqs_1.fasta
# >Arabidopsis_thaliana_rbcL
# >Oryza_sativa_rbcL
# >Zea_mays_rbcL
# >Glycine_max_rbcL
# >Solanum_lycopersicum_rbcL
```

---

### `seqs_2.fasta`
5 secuencias del gen **rbcL** de cereales:
- *Oryza sativa* (arroz) ← también está en seqs_1.fasta
- *Zea mays* (maíz) ← también está en seqs_1.fasta
- *Triticum aestivum* (trigo)
- *Sorghum bicolor* (sorgo)
- *Hordeum vulgare* (cebada)

```bash
grep -c ">" seqs_2.fasta
# 5

diff -q seqs_1.fasta seqs_2.fasta
# Files seqs_1.fasta and seqs_2.fasta differ
```

---

## Actividad asincrónica — guía de resolución

```bash
# 1. Contar secuencias en cada archivo
grep -c ">" seqs_1.fasta     # → 5
grep -c ">" seqs_2.fasta     # → 5

# 2. Comparar si los archivos son idénticos
diff -q seqs_1.fasta seqs_2.fasta

# 3. Extraer y ordenar los nombres
grep ">" seqs_1.fasta | tr -d ">" | sort > nombres_1.txt
grep ">" seqs_2.fasta | tr -d ">" | sort > nombres_2.txt

cat nombres_1.txt
cat nombres_2.txt

# 4. Encontrar nombres en común
comm -12 nombres_1.txt nombres_2.txt
# → Oryza_sativa_rbcL
# → Zea_mays_rbcL
```

---

*Datos preparados por Manuel Ramírez Sáenz · Semestre 2026-1*
