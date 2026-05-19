#!/bin/bash

# fecha y hora
FECHA=$(date +"%Y%m%d_%H%M%S")
BACKUP="backup_home_$FECHA.tar.gz"

HOME_DIR="$HOME"

# lista temporal 
TMP_LIST=$(mktemp)

find "$HOME_DIR" -type f -mtime -1 > "$TMP_LIST"

# Crear el archivo tar.gz usando la lista
tar -czf "$BACKUP" -T "$TMP_LIST"

# Eliminar archivo temporal
rm "$TMP_LIST"

echo "Copia de seguridad creada: $BACKUP"
