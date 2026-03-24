#!/bin/bash

trap '' SIGINT

export PATH=""
export TERM=""


echo " Bienvenido a Jail Challenge."
echo " Tu objetivo es leer el archivo 'flag.txt'."


while true; do
    read -p "jail> " user_input
    
    if [[ "$user_input" == *"cat"* || "$user_input" == *"sh"* || "$user_input" == *"/"* || "$user_input" == *"*"* ]]; then
        echo "Esta mal... en algo... ya nimodo"

    else
        timeout 2 bash -c "$user_input" 2>/dev/null

        if [ $? -ne 0 ]; then
            echo "Comando no encontrado o error de ejecución."
        fi
    fi
done
