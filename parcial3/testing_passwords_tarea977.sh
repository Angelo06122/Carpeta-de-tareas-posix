#!/bin/bash

# Verificar parámetro
if [ $# -ne 1 ]; then
    echo "Uso: $0 \"contraseña\""
    exit 1
fi

password="$1"

echo "Analizando contraseña: $password"
echo "--------------------------------"

valida=true

# 1. Verificar longitud mínima de 8 caracteres

if [[ ${#password} -lt 8 ]]; then
    echo "Debe tener al menos 8 caracteres"
    valida=false
else
    echo "Longitud correcta"
fi

# 2. Debe contener al menos un número

if [[ ! $password =~ [0-9] ]]; then
    echo "Debe contener al menos un número"
    valida=false
else
    echo "Contiene números"
fi

# 3. Debe contener un símbolo especial permitido

regex='[@#$%&*+=-]'

if [[ ! $password =~ $regex ]]; then
    echo "Debe contener un símbolo especial (@ # $ % & * + - =)"
    valida=false
else
    echo "Contiene símbolos especiales"
fi

# 4. Verificación de palabras de diccionario
#    Busca secuencias de 4+ letras consecutivas

echo "Verificando palabras de diccionario..."

# Extraer secuencias alfabéticas de 4 o más letras
palabras=$(echo "$password" | grep -oE '[A-Za-z]{4,}')

diccionario="/usr/share/dict/words"

if [ -f "$diccionario" ]; then

    for palabra in $palabras
    do
        if grep -iq "^$palabra$" "$diccionario"; then
            echo "Contiene palabra de diccionario: $palabra"
            valida=false
        fi
    done

else
    echo "No se encontró diccionario en $diccionario"
fi

# Resultado final
echo "--------------------------------"

if [ "$valida" = true ]; then
    echo "Contraseña fuerte"
else
    echo "Contraseña débil"
fi
