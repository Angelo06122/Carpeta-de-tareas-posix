#!/bin/bash

# Función para sumar dígitos repetidamente
sumar_digitos() {
    local num=$1

    while [ $num -ge 10 ]; do
        suma=0

        while [ $num -gt 0 ]; do
            digito=$((num % 10))
            suma=$((suma + digito))
            num=$((num / 10))
        done

        num=$suma
    done

    echo $num
}

echo "Números de la suerte entre 1000 y 10000:"

for ((i=1000; i<=10000; i++)); do
    resultado=$(sumar_digitos $i)

    if [ $resultado -eq 7 ]; then
        echo $i
    fi
done
