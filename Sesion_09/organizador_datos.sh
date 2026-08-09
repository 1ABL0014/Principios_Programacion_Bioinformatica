#!/bin/bash
# Estructura de mi proyecto bioinformatico

# Crear estructura de directorios para un proyecto de metagenómica
PROYECTO="mi_proyecto_bioinfo_semana_09"

echo "Creando estructura de proyecto: $PROYECTO"

mkdir -p $PROYECTO/{datos_raw,datos_procesados,resultados,scripts,logs,referencias}

# Crear archivos de ejemplo en datos_raw y datos_procesados
echo "ATCGATCGATCG" > $PROYECTO/datos_raw/muestra1.fasta
echo "AGAGAG" > $PROYECTO/datos_procesados/muestra1_purinas.fasta

#listando estructura
tree mi_proyecto_bioinfo_semana_09

