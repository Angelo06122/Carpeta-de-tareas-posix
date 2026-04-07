#!/bin/bash

# ==========================================
# RPG 
# ==========================================

# 1. estats
carlo_hp_max=90
max_hp_max=110
darius_hp_max=70

carlo_def=9
max_def=11
darius_def=7

total_kills=0
oleada=1

# 2. muertes y pasivas (daño mortal)
revisar_muerte() {
    local idx=$1
    if [ ${enemigo_hp[$idx]} -le 0 ] && [ ${enemigo_vivo[$idx]} -eq 1 ]; then
        enemigo_vivo[$idx]=0
        total_kills=$((total_kills + 1))
        echo "   ¡${enemigo_nombre[$idx]} ha sido derrotado!"
        
        # Pasiva: daño mortal a todos (tipo 4)
        if [ ${enemigo_tipo[$idx]} -eq 4 ]; then
            echo "   ¡CUIDADO! ${enemigo_nombre[$idx]} explota en la cara de todo tu equipo a nombre de su religión"
            dmg_exp=0
            for d in {1..2}; do dmg_exp=$(( dmg_exp + (RANDOM % 12) + 2 )); done
            
            if [ $carlo_hp -gt 0 ]; then 
                final=$(( dmg_exp - carlo_def )); [ $final -lt 0 ] && final=0
                carlo_hp=$(( carlo_hp - final ))
                echo "   >> Carlo recibe $final de daño explosivo."
            fi
            if [ $max_hp -gt 0 ]; then
                final=$(( dmg_exp - max_def )); [ $final -lt 0 ] && final=0
                max_hp=$(( max_hp - final ))
                echo "   >> La explosión arruinó la melena de Maximus, recibe $final de daño explosivo."
            fi
            if [ $darius_hp -gt 0 ]; then
                final=$(( dmg_exp - darius_def )); [ $final -lt 0 ] && final=0
                darius_hp=$(( darius_hp - final ))
                echo "   >> La explosión asustó a Darius, recibe $final de daño psicológico."
            fi
        fi
    fi
}

# 3. generador de enemigos
generar_horda() {
    num_enemigos=$(( (RANDOM % 8) + 1 ))
    echo -e "\n=========================================="
    echo "--- OLEADA $oleada: Aparecen $num_enemigos enemigos ---"
    echo "=========================================="

    for i in $(seq 1 $num_enemigos); do
        enemigo_vivo[$i]=1
        suerte=$(( (RANDOM % 100) + (total_kills * 2) ))

        if [ $suerte -lt 30 ]; then
            enemigo_nombre[$i]="Esqueleto Esqueletoso"
            enemigo_hp_max[$i]=45
            enemigo_dados[$i]=4
            enemigo_tipo[$i]=1
        elif [ $suerte -lt 55 ]; then
            enemigo_nombre[$i]="Espíritu Malsi"
            enemigo_hp_max[$i]=25
            enemigo_dados[$i]=15
            enemigo_tipo[$i]=4
        elif [ $suerte -lt 80 ]; then
            enemigo_nombre[$i]="Curandero Oscuro"
            enemigo_hp_max[$i]=45
            enemigo_dados[$i]=0
            enemigo_tipo[$i]=5
        elif [ $suerte -lt 95 ]; then
            enemigo_nombre[$i]="Guardián Menor"
            enemigo_hp_max[$i]=60
            enemigo_dados[$i]=6
            enemigo_tipo[$i]=2
        else
            enemigo_nombre[$i]="General de Generales"
            enemigo_hp_max[$i]=110
            enemigo_dados[$i]=9
            enemigo_tipo[$i]=3
        fi
        
        enemigo_hp[$i]=${enemigo_hp_max[$i]}
        echo "[$i] ${enemigo_nombre[$i]} (HP: ${enemigo_hp[$i]})"
    done
}

# 4. bucle
while [ $carlo_hp_max -gt 0 ]; do # Mientras exista el juego
    
    # --- curación al final de oleadas ---
    if [ $oleada -eq 1 ]; then
        # Primera oleada, empiezan al 100%
        carlo_hp=$carlo_hp_max
        max_hp=$max_hp_max
        darius_hp=$darius_hp_max
    else
        # Curan el 25% de su vida máxima
        echo -e "\n[!] El equipo descansa brevemente y recupera el 25% de su vida máxima."
        
        carlo_hp=$(( carlo_hp + (carlo_hp_max / 4) ))
        [ $carlo_hp -gt $carlo_hp_max ] && carlo_hp=$carlo_hp_max
        
        max_hp=$(( max_hp + (max_hp_max / 4) ))
        [ $max_hp -gt $max_hp_max ] && max_hp=$max_hp_max
        
        darius_hp=$(( darius_hp + (darius_hp_max / 4) ))
        [ $darius_hp -gt $darius_hp_max ] && darius_hp=$darius_hp_max
    fi

    generar_horda

    while true; do
        # --- mostrar estado ---
        echo -e "\n------------------------------------------"
        [ $carlo_hp -gt 0 ]   && echo "1) Carlo   (HP: $carlo_hp/$carlo_hp_max)" || echo "1) Carlo   (CAÍDO)"
        [ $max_hp -gt 0 ]     && echo "2) Maximus (HP: $max_hp/$max_hp_max)" || echo "2) Maximus (CAÍDO)"
        [ $darius_hp -gt 0 ]  && echo "3) Darius  (HP: $darius_hp/$darius_hp_max)" || echo "3) Darius  (CAÍDO)"
        echo "------------------------------------------"
        
        enemigos_vivos_count=0
        for i in $(seq 1 $num_enemigos); do
            if [ ${enemigo_vivo[$i]} -eq 1 ]; then
                echo "[$i] ${enemigo_nombre[$i]} (HP: ${enemigo_hp[$i]}/${enemigo_hp_max[$i]})"
                enemigos_vivos_count=$((enemigos_vivos_count + 1))
            fi
        done
        echo "------------------------------------------"

        if [ $enemigos_vivos_count -eq 0 ]; then
            echo -e "\n¡Horda derrotada! El grupo avanza a la siguiente sala."
            oleada=$((oleada + 1))
            sleep 2
            break
        fi

        # --- turno de carlo ---
        if [ $carlo_hp -gt 0 ]; then
            read -p "Carlo, ¿a qué enemigo atacas? (1-$num_enemigos): " obj
            
            # Validación mejorada para evitar que pierda el turno por un error de texto
            if [[ "$obj" =~ ^[0-9]+$ ]] && [ "$obj" -ge 1 ] && [ "$obj" -le "$num_enemigos" ]; then
                if [ ${enemigo_vivo[$obj]} -eq 1 ]; then
                    danio=0
                    for d in {1..6}; do danio=$(( danio + (RANDOM % 12) + 1 )); done
                    enemigo_hp[$obj]=$(( enemigo_hp[$obj] - danio ))
                    echo ">> Carlo causa $danio de daño a ${enemigo_nombre[$obj]}."
                    revisar_muerte $obj
                else
                    echo ">> ¡Ese enemigo ya está muerto! Carlo ataca al aire y pierde el turno."
                fi
            else
                echo ">> Objetivo inválido. Carlo se confunde y pierde el turno."
            fi
            sleep 1
        fi

        # --- turno de maximus ---
        if [ $max_hp -gt 0 ]; then
            read -p "Maximus, elige a un enemigo para tu golpe inicial (1-$num_enemigos): " obj_m
            
            # El primer golpe de Maximus
            if [[ "$obj_m" =~ ^[0-9]+$ ]] && [ "$obj_m" -ge 1 ] && [ "$obj_m" -le "$num_enemigos" ]; then
                if [ ${enemigo_vivo[$obj_m]} -eq 1 ]; then
                    dmg1=0; for d in {1..2}; do dmg1=$(( dmg1 + (RANDOM % 12) + 1 )); done
                    enemigo_hp[$obj_m]=$(( enemigo_hp[$obj_m] - dmg1 ))
                    echo ">> Maximus da un primer golpe letal causando $dmg1 de daño a ${enemigo_nombre[$obj_m]}."
                    revisar_muerte $obj_m
                else
                    echo ">> ¡Ese enemigo ya no está! Maximus golpea el suelo."
                fi
            else
                echo ">> Objetivo inicial inválido. Maximus se salta el primer golpe."
            fi
            
            # Golpe en área (3d8) siempre ocurre si está vivo
            echo ">> ¡Maximus sigue con su danza arrolladora y ataca a TODOS los enemigos!"
            dmg_aoe=0; for d in {1..3}; do dmg_aoe=$(( dmg_aoe + (RANDOM % 8) + 1 )); done
            echo "   (Maximus lanza 3 dados: $dmg_aoe de daño en área)"
            
            for i in $(seq 1 $num_enemigos); do
                if [ ${enemigo_vivo[$i]} -eq 1 ]; then
                    enemigo_hp[$i]=$(( enemigo_hp[$i] - dmg_aoe ))
                    echo "   -> ${enemigo_nombre[$i]} recibe $dmg_aoe de daño."
                    revisar_muerte $i
                fi
            done
            sleep 1
        fi

        # --- turno de darius ---
        if [ $darius_hp -gt 0 ]; then
            read -p "Darius, elige a quién curar primero (1: Carlo, 2: Maximus, 3: Darius): " obj_d
            
            heal_single=0; for d in {1..2}; do heal_single=$(( heal_single + (RANDOM % 12) + 1 )); done
            heal_aoe=0; for d in {1..2}; do heal_aoe=$(( heal_aoe + (RANDOM % 8) + 1 )); done
            
            echo ">> El Hermano Darius canaliza su mejor conjuro... sana sana colita de rana."
            
            if [ "$obj_d" == "1" ] && [ $carlo_hp -gt 0 ]; then
                carlo_hp=$(( carlo_hp + heal_single ))
                echo "   Carlo recupera $heal_single HP por oración directa."
            elif [ "$obj_d" == "2" ] && [ $max_hp -gt 0 ]; then
                max_hp=$(( max_hp + heal_single ))
                echo "   Maximus recupera $heal_single HP por oración directa."
            elif [ "$obj_d" == "3" ]; then
                darius_hp=$(( darius_hp + heal_single ))
                echo "   Darius (envidiosamente) se cura a sí mismo por $heal_single HP."
            else
                echo "   Objetivo inválido. Darius no cura a nadie directamente."
            fi
            
            echo "   ¡Darius emite un aura que cura a TODO el grupo por $heal_aoe HP!"
            [ $carlo_hp -gt 0 ] && carlo_hp=$(( carlo_hp + heal_aoe ))
            [ $max_hp -gt 0 ] && max_hp=$(( max_hp + heal_aoe ))
            [ $darius_hp -gt 0 ] && darius_hp=$(( darius_hp + heal_aoe ))
            
            [ $carlo_hp -gt $carlo_hp_max ] && carlo_hp=$carlo_hp_max
            [ $max_hp -gt $max_hp_max ] && max_hp=$max_hp_max
            [ $darius_hp -gt $darius_hp_max ] && darius_hp=$darius_hp_max
            sleep 1
        fi

        # --- turno enemigo ---
        echo -e "\n--- ATAQUE ENEMIGO ---"
        for i in $(seq 1 $num_enemigos); do
            if [ ${enemigo_vivo[$i]} -eq 1 ]; then
                
                if [ ${enemigo_tipo[$i]} -eq 5 ]; then
                    vivos_e=()
                    for j in $(seq 1 $num_enemigos); do
                        [ ${enemigo_vivo[$j]} -eq 1 ] && vivos_e+=($j)
                    done
                    
                    if [ ${#vivos_e[@]} -gt 0 ]; then
                        obj_heal=${vivos_e[$(( RANDOM % ${#vivos_e[@]} ))]}
                        h_s=0; for d in {1..2}; do h_s=$(( h_s + (RANDOM % 12) + 1 )); done
                        h_a=0; for d in {1..1}; do h_a=$(( h_a + (RANDOM % 12) + 1 )); done
                        
                        enemigo_hp[$obj_heal]=$(( enemigo_hp[$obj_heal] + h_s ))
                        [ ${enemigo_hp[$obj_heal]} -gt ${enemigo_hp_max[$obj_heal]} ] && enemigo_hp[$obj_heal]=${enemigo_hp_max[$obj_heal]}
                        echo "${enemigo_nombre[$i]} inyecta magia oscura a ${enemigo_nombre[$obj_heal]} curándole $h_s HP."
                        
                        echo "${enemigo_nombre[$i]} libera un pulso curativo de $h_a HP a todos sus aliados."
                        for j in ${vivos_e[@]}; do
                            enemigo_hp[$j]=$(( enemigo_hp[$j] + h_a ))
                            [ ${enemigo_hp[$j]} -gt ${enemigo_hp_max[$j]} ] && enemigo_hp[$j]=${enemigo_hp_max[$j]}
                        done
                    fi

                elif [ ${enemigo_tipo[$i]} -eq 4 ]; then
                    danio_e=0
                    for d in $(seq 1 ${enemigo_dados[$i]}); do danio_e=$(( danio_e + (RANDOM % 12) + 1 )); done
                    echo "${enemigo_nombre[$i]} expulsa gas tóxico atacando a TODO el grupo por $danio_e de daño bruto."
                    
                    if [ $carlo_hp -gt 0 ]; then
                        final=$(( danio_e - carlo_def )); [ $final -lt 0 ] && final=0
                        carlo_hp=$(( carlo_hp - final ))
                    fi
                    if [ $max_hp -gt 0 ]; then
                        final=$(( danio_e - max_def )); [ $final -lt 0 ] && final=0
                        max_hp=$(( max_hp - final ))
                    fi
                    if [ $darius_hp -gt 0 ]; then
                        final=$(( danio_e - darius_def )); [ $final -lt 0 ] && final=0
                        darius_hp=$(( darius_hp - final ))
                    fi

                else
                    vivos_h=()
                    [ $carlo_hp -gt 0 ] && vivos_h+=("carlo")
                    [ $max_hp -gt 0 ] && vivos_h+=("maximus")
                    [ $darius_hp -gt 0 ] && vivos_h+=("darius")
                    
                    if [ ${#vivos_h[@]} -gt 0 ]; then
                        obj=${vivos_h[$(( RANDOM % ${#vivos_h[@]} ))]}
                        danio_e=0
                        for d in $(seq 1 ${enemigo_dados[$i]}); do danio_e=$(( danio_e + (RANDOM % 12) + 1 )); done
                        
                        if [ "$obj" == "carlo" ]; then
                            final=$(( danio_e - carlo_def )); [ $final -lt 0 ] && final=0
                            carlo_hp=$(( carlo_hp - final ))
                            echo "${enemigo_nombre[$i]} ataca a Carlo por $final."
                        elif [ "$obj" == "maximus" ]; then
                            final=$(( danio_e - max_def )); [ $final -lt 0 ] && final=0
                            max_hp=$(( max_hp - final ))
                            echo "${enemigo_nombre[$i]} ataca a Maximus por $final."
                        elif [ "$obj" == "darius" ]; then
                            final=$(( danio_e - darius_def )); [ $final -lt 0 ] && final=0
                            darius_hp=$(( darius_hp - final ))
                            echo "${enemigo_nombre[$i]} ataca a Darius por $final."
                        fi
                    fi
                fi
            fi
        done
        sleep 2

        # Revisar si todos perdieron
        if [ $carlo_hp -le 0 ] && [ $max_hp -le 0 ] && [ $darius_hp -le 0 ]; then
            echo -e "\n=========================================="
            echo "El equipo ha caído en la oleada $oleada."
            echo "Total de enemigos derrotados: $total_kills"
            echo "=========================================="
            exit 0
        fi
    done
done
