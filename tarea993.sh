#!/bin/bash

pausar() {
    echo ""
    read -p "Presiona [Enter] para continuar..."
}

while true; do
    clear
    echo "=========================================="
    echo "          MI MENÚ DE BASH (18 OPCIONES)   "
    echo "=========================================="
    echo "1) Hola Mundo"
    echo "2) Argumentos y Variables especiales"
    echo "3) Variables"
    echo "4) arrays"
    echo "5) otros usos"
    echo "6) operaciones aritméticas"
    echo "7) operaciones lógicas"
    echo "8) operaciones condicionales"
    echo "9) comprobaciones"
    echo "10) case"
    echo "11) iteraciones"
    echo "12) while"
    echo "13) until"
    echo "14) select"
    echo "15) funciones"
    echo "16) librerias"
    echo "17) señales"
    echo "18) colores"
    echo "q) Salir"
    echo "------------------------------------------"
    
    read -p "Seleccione una opción [1-18, o q para salir]: " OPCION

    case $OPCION in
        1)
            echo "Hola mundo"
            pausar
            ;;

        2)
            SALUDO="Hola mundo"
            echo -n "Este script te dice: "
            echo ${SALUDO}
            pausar
            ;;

        3)
            una_variable=666
            MI_NOMBRE="Richard"
            NOMBRES="Iñigo Asier Sten Roberto Pello"
            BOOLEANO=true
            echo "Echemos un ojo a las variables "
            echo "Un número: ${una_variable}"
            echo "Un nombre ${MI_NOMBRE}"
            echo "Un grupo de nombres: ${NOMBRES}"
            echo "Me has pasado $# argumentos"
            echo IDa: ${!} y $@
            echo "Mi directorio actual: ${PWD} y mi usuario ${UID}"
            pausar
            ;;

        4)
            asociaciones[0]="Gruslin"
            asociaciones[1]="Hackresi"
            asociaciones[2]="NavarradotNET"
            asociaciones[3]="Riberlug"
            partidos=("UPN" "PSN" "CDN" "IUN" "Nafarroa BAI" "RCN" )
            numeros=(15 23 45 42 23 1337 23 666 69)
            echo ${asociaciones[0]} es una asociación, ${partidos[1]} un partido
            pausar
            ;;

        5)
            NOMBRE="Navarrux Live edition"
            echo ${NOMBRE} una parte ${NOMBRE:8} y otra ${NOMBRE:8:4}
            SINVALOR=
            echo "Variable SINVALOR: ${SINVALOR:-31337} eta ${VACIO:-'Miguel Indurain'}"
            echo "La variable SINVALOR no tiene valor algun ${SINVALOR} "
            echo "Variable SINVALOR: ${SINVALOR:=31337} eta ${VACIO:='Miguel Indurain'}"
            echo "La variable SINVALOR no tiene valor algun ${SINVALOR} "
            PROGRAMA='sniffit'
            echo "valor de PROGRAMA: ${PROGRAMA:+'tcpdump'} y ahora ${PROGRAMA}"
            EJEMPLO="Test"
            echo "Valor de: ${EJEMPLO:?'Roberto'} y luego ${EJEMPLO}"
            echo "Variables que empiezan con P:"
            for i in ${!P*}; do echo $i; done
            pausar
            ;;
            
        6)
            VALOR1=23
            VALOR2=45
            RESULTADO=`expr ${VALOR1} + ${VALOR2}`
            echo "Resultado: ${RESULTADO}"
            RESULTADO=`expr ${VALOR1} + ${VALOR2} + 3`
            echo "Resultado: ${RESULTADO}"
            VALOR1=5
            VALOR2=4
            echo "${VALOR1} y ${VALOR2}"
            RESULTADO=$((VALOR1 + VALOR2 + 2))
            echo "Ahora: ${VALOR1} + ${VALOR2} + 2 = ${RESULTADO}"
            RESULTADO=$((VALOR1 + (VALOR2 * 3)))
            echo "Ahora: ${VALOR1} + ${VALOR2} * 3 = ${RESULTADO}"
            pausar
            ;;

        7)
            booleano=true
            $booleano && echo "OK" || echo "no es true"
            otrobool=!${booleano}
            test ${otrobool} || echo "Ahora es falso"
            valor=6
            test $valor -le 6 && echo "Se cumple el -le"
            nuevo=${valor}
            test ${nuevo} -eq ${valor} && echo "Son los mismos"
            echo "Ahora ${nuevo} es lo mismo que ${valor}"
            pausar
            ;;

        8)
            VARIABLE=45
            if [ ${VARIABLE} -gt 0 ]; then
                echo "${VARIABLE} es mayor que 0"
            fi
            if [ -e /etc/shadow ]; then
                echo "OK, parece que tienes un sistema con shadow pass"
            fi
            OTRA=-23
            if [ ${OTRA} -lt 0 ]; then
                echo "${OTRA} es menor que 0"
            else
                echo "${OTRA} es mayor que 0"
            fi
            echo -n "Mete un valor: "
            read VALOR1
            echo -n "Mete otro valor: "
            read VALOR2
            echo "Has introducido los valores ${VALOR1} y ${VALOR2}"
            if [ ${VALOR1} -gt ${VALOR2} ]; then
                echo "${VALOR1} es mayor que ${VALOR2}"
            elif [ ${VALOR1} -lt ${VALOR2} ]; then
                echo "${VALOR1} es menor que ${VALOR2}"
            else
                echo "${VALOR1} y ${VALOR2} son iguales"
            fi
            test -f './fichero.txt' || touch fichero.txt
            echo "Se comprobó fichero.txt"
            pausar
            ;;

        9)
            echo -n "Dame la ruta de un fichero para comprobar: "
            read fichero
            if [ -e "$fichero" ] && [ -f "$fichero" ]; then
                echo "OK, el fichero existe"
            else 
                echo "NO existe"
            fi
            if [ ! -e "$fichero" ]; then
                echo "Efectivamente, no existe"
            fi
            pausar
            ;;

        10)
            NOMBRE=""
            echo -n "Dame un nombre (iñigo, sten, asier, pello): "
            read NOMBRE
            case ${NOMBRE} in
                iñigo)
                    echo "${NOMBRE} dice: me dedico a Navarrux"
                    ;;
                sten)
                    echo "${NOMBRE} dice: tengo un blog friki"
                    ;;
                asier)
                    echo "${NOMBRE} dice: .NET me gusta"
                    ;;
                pello)
                    echo "${NOMBRE} dice: el shell mola"
                    ;;
                *)
                    echo "A ${NOMBRE} no lo conozco"
                    ;;
            esac
            pausar
            ;;

        11)
            echo "FOR simple: "
            for i in a b c d e f g h i; do
                echo "letra: $i"
            done
            NOMBRES="Iñigo Sten Asier Pello Roberto"
            echo "FOR simple para recorrer un array: "
            echo "Participantes en la 4party: "
            for i in ${NOMBRES}; do
                echo ${i}
            done
            echo "FOR con ficheros *.sh"
            for i in *.sh; do
                if [ -e "$i" ]; then
                    ls -lh "${i}"
                fi
            done
            echo "FOR clásico "
            for (( cont=0 ; ${cont} < 10 ; cont=`expr $cont + 1` )); do
                echo "Ahora valgo> ${cont}"
            done
            pausar
            ;;

        12)
            echo "WHILE en marcha"
            cont=0
            while [ ${cont} -lt 100 ]; do
                cont=`expr $cont + 10`
                echo "Valor del contador: ${cont}"
            done
            echo "Valor final del contador: ${cont}"
            pausar
            ;;

        13)
            echo "Estructura until"
            cont=15
            until [ ${cont} -lt 0 ]; do
                echo "Valor del contador: ${cont}"
                cont=`expr $cont - 1`
            done
            echo "Valor final del contador: ${cont}"
            pausar
            ;;

        14)
            echo "Select de distros"
            DISTROS="Debian Ubuntu Navarrux Gentoo Mandriva"
            select resultado in ${DISTROS}; do
                if [ -n "${resultado}" ]; then
                    break
                else
                    echo "Opción inválida."
                fi
            done
            echo "Sistema seleccionado: [${resultado}] longitud de cadena: ${#resultado}"
            pausar
            ;;

        15)
            RESULTADO=0
            muestrapantalla () {
                echo "Valores: $0> $1 y $2 y $3"
            }
            sumame () {
                echo "Estamos en la función: ${FUNCNAME}"
                echo "Parametros: $1 y $2"
                RESULTADO=`expr ${1} + ${2}`
                return 0
            }
            muestrapantalla 3 4 "epa"
            sumame 45 67 && echo "OK" || echo "Ocurrió un error"
            echo "Resultado: ${RESULTADO} Código de salida: $?"
            pausar
            ;;

        16)
            if [ -f "libreria.sh" ]; then
                source libreria.sh
                muestrapantalla 69 123 "epa"
                sumame 1337 3389 && echo "OK" || echo "Ocurrió un error"
                echo "Resultado: ${RESULTADO} Código de salida: $?"
            else
                echo "El archivo libreria.sh no existe en este directorio."
            fi
            pausar
            ;;

        17)
            funcion_trap () {
                echo "Se ha recibido una señal: ${FUNCNAME} ${0}"
                echo "Saliendo del bucle seguro..."
                exit 0
            }
            trap "funcion_trap" INT QUIT TSTP
            echo "Atrapando señales (Presiona Ctrl+C para salir y probar el trap)"
            while true; do
                sleep 2
                echo "ufff qué sueño..."
            done
            pausar
            ;;

        18)
            echo -e "\033[40m\033[37m Blanco \033[0m"
            echo -e "\033[40m\033[1;37m Gris claro \033[0m"
            echo -e "\033[40m\033[30m Negro \033[0m (esto es negro)"
            echo -e "\033[40m\033[1;30m Gris \033[0m"
            echo -e "\033[40m\033[31m Rojo \033[0m"
            echo -e "\033[40m\033[1;31m Rojo claro \033[0m"
            echo -e "\033[40m\033[32m Verde \033[0m"
            echo -e "\033[40m\033[1;32m Verde claro \033[0m"
            echo -e "\033[40m\033[33m Marrón \033[0m"
            echo -e "\033[40m\033[1;33m Amarillo \033[0m"
            echo -e "\033[40m\033[34m Azul \033[0m"
            echo -e "\033[40m\033[1;34m Azul claro \033[0m"
            echo -e "\033[40m\033[35m Purpura \033[0m"
            echo -e "\033[40m\033[1;35m Rosa \033[0m"
            echo -e "\033[40m\033[36m Cyan \033[0m"
            echo -e "\033[40m\033[1;36m Cyan claro \033[0m"
            echo -e "\033[42m\033[31m Navarrux v1.0 \033[0m"
            echo -e "\033[40m\033[4;33m Amarillo \033[0m"
            pausar
            ;;
            
        q|Q)
            echo "Saliendo del script..."
            exit 0
            ;;
            
        *)
            echo "Opción no válida, intenta de nuevo."
            sleep 1
            ;;
    esac
done