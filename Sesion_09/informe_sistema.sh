#!/bin/bash
#29/05/2026
#Santiago Calero Alvarez
#Script 1, Tarea semana 9

# Este comando te informa en qué directorio te encuentras
lugar=$(pwd)
echo ""
echo "Usuario: $(whoami)"
echo "Fecha: $(date)"
echo ""
echo "En este momento te encuentras trabajando en: $lugar"
echo ""
echo "Contenido del directorio:"
ls -lh
echo ""
echo "Uso del disco por el directorio actual:"
du -sh .
