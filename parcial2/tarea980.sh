#!/bin/bash

# Verificar el nombre del archivo como parámetro
if [ $# -eq 0 ]; then
    echo "Debes proporcionar el nombre de un archivo."
    echo "Uso: $0 <nombre_del_archivo>"
    exit 1
fi

Archivo="$1"

# Verificar si el archivo existe
if [ ! -e "$Archivo" ]; then
    echo "El archivo '$Archivo' no existe."
    exit 1
fi

# Extraer información 
Ruta=$(realpath "$Archivo")
Nombre=$(basename "$Archivo")
Tamano=$(stat -c "%s" "$Archivo")
Usuario=$(stat -c "%U" "$Archivo")
Grupo=$(stat -c "%G" "$Archivo")
Fecha=$(stat -c "%y" "$Archivo" | cut -d' ' -f1) 

# Extraer los permisos
Permisos=$(stat -c "%A" "$Archivo")

Tipo_char=${Permisos:0:1}
if [ "$Tipo_char" == "-" ]; then
    Tipo="archivo"
elif [ "$Tipo_char" == "d" ]; then
    Tipo="directorio"
elif [ "$Tipo_char" == "l" ]; then
    Tipo="enlace simbólico"
else
    Tipo="otro"
fi

# rwx
permisos_rwx() {
    local cadena=$1
    local texto=""

    # Evaluamos cada posición de los 3 caracteres enviados
    if [ "${cadena:0:1}" == "r" ]; then texto="Lectura"; fi
    
    if [ "${cadena:1:1}" == "w" ]; then
        if [ -n "$texto" ]; then texto="$texto, Escritura"; else texto="Escritura"; fi
    fi
    
    if [ "${cadena:2:1}" == "x" ]; then
        if [ -n "$texto" ]; then texto="$texto, Ejecucion"; else texto="Ejecucion"; fi
    fi

    if [ -z "$texto" ]; then texto="Ninguno"; fi
    
    echo "$texto"
}

Permiso_usuario=$(permisos_rwx "${Permisos:1:3}")
Permiso_grupos=$(permisos_rwx "${Permisos:4:3}")
Otros_permisos=$(permisos_rwx "${Permisos:7:3}")

# Imprimir el resultado final 
echo "Nombre: $Nombre"
echo "Tipo: $Tipo"
echo "Ruta absoluta: $Ruta"
echo "Fecha de creacion/modificacion: $Fecha"
echo "Tamaño en bytes: $Tamano bytes"
echo "Permisos:"
echo "     User($Usuario): $Permiso_usuario"
echo "     Group($Grupo): $Permiso_grupos"
echo "     Others: $Otros_permisos"
