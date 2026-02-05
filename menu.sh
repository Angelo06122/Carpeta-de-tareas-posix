#!/bin/bash
SCRIPT=
while true
do

	echo -e "\nMENU"
	echo "1.- Hola mundo"
	echo "2.- Hola mundo con variables"
	echo "3.- Arbol de directorios" 
	echo -e "x.- salir\n\n"

	echo -n "Selecciona un script: "
	read SCRIPT

	case ${SCRIPT} in
		1)
			source hola_mundo.sh
			;;
		2)
			MUNDO="mundo"
			echo "hola $MUNDO"
			;;
		3)
			mkdir -p proyecto/{docs,src,bin}
			echo "arbol creado"
			;;
		x)
			echo "saliendo.............."
			break
			;;
		*)
			echo "no hay, no existe" 
esac
done
