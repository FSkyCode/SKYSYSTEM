#!/bin/bash
ESTADO="INICIO"
SECCION=0 # 0 para Repositorios, 1 para Opciones

USUARIO="FSkyCode"
OPCIONES=( "Guardar cambios" "Agregar nuevo repositorio" "Eliminar repositorio" "Ver creditos" )

indice_repositorios=0
indice_opciones=0

repo_actual="" # El repositorio escogido lol

# Colores
RESET='\033[0m'
BOLD='\033[1m'
VERDE='\033[32m'
CYAN='\033[36m'

# Definimos la ruta al archivo
ARCHIVO_DATA="data/rutas.dat"
# Creamos el array vacío
REPOSITORIOS=()
# Leemos el archivo y llenamos el array
if [[ -f "$ARCHIVO_DATA" ]]; then
    while IFS= read -r linea || [[ -n "$linea" ]]; do
        # Extraemos solo el nombre del repo (lo que está después de la última /)
        nombre_repo=$(basename "$linea")
        
        # Lo añadimos al array
        REPOSITORIOS+=("$nombre_repo")
    done < "$ARCHIVO_DATA"
else
    echo "Error: No se encontró $ARCHIVO_DATA"
fi


# Funciones de índice circular
get_indice() {
    local index=$1
    local total=$2
    echo $(( (index + total) % total ))
}

# Dibujar una lista tipo carrusel (3 elementos)
dibujar_carrusel() {
    local lista=("${!1}") # Pasamos el array por referencia
    local indice_actual=$2
    local es_seccion_activa=$3
    local total=${#lista[@]}

    for i in -1 0 1; do
        local idx=$(get_indice $((indice_actual + i)) $total)
        local nombre="${lista[$idx]}"

        if [ $i -eq 0 ]; then
            if [ "$es_seccion_activa" = true ]; then
                echo -e "${VERDE}${BOLD}  [X] -> $nombre <---${RESET}"
            else
                echo -e "${BOLD}  [ ] -> $nombre${RESET}"
            fi
        else
            echo -e "      $nombre"
        fi
    done
}

inicio() {
    clear
    echo -e "${CYAN}${BOLD}=========================================="
    echo "          -- REPOSITORIOS --"
    echo -e "==========================================${RESET}"
    echo " Usuario actual: $USUARIO"
    echo " [M] Cambiar sección | [W/S] Navegar | [Q] Salir"
    echo "------------------------------------------"

    echo -e "\n${BOLD}--- LISTA DE REPOS ---${RESET}"
    local activa_repo=false
    [ $SECCION -eq 0 ] && activa_repo=true
    dibujar_carrusel REPOSITORIOS[@] $indice_repositorios $activa_repo

    echo -e "\n${BOLD}--- ACCIONES ---${RESET}"
    local activa_opcion=false
    [ $SECCION -eq 1 ] && activa_opcion=true
    dibujar_carrusel OPCIONES[@] $indice_opciones $activa_opcion

    input_read
}

input_read() {
    # -t 0.1 para que el bucle no se trabe, pero read -n1 es mejor aquí
    read -rsn1 tecla

    case "$tecla" in
        [mM]) # Cambiar de seccion
            SECCION=$(( (SECCION + 1) % 2 ))
            ;;
        [wW]) # Subir
            if [ $SECCION -eq 0 ]; then
                indice_repositorios=$(get_indice $((indice_repositorios - 1)) ${#REPOSITORIOS[@]})
            else
                indice_opciones=$(get_indice $((indice_opciones - 1)) ${#OPCIONES[@]})
            fi
            ;;
        [sS]) # Bajar
            if [ $SECCION -eq 0 ]; then
                indice_repositorios=$(get_indice $((indice_repositorios + 1)) ${#REPOSITORIOS[@]})
            else
                indice_opciones=$(get_indice $((indice_opciones + 1)) ${#OPCIONES[@]})
            fi
            ;;
        [qQ]) # Salir
            clear
            ESTADO="SALIR"
            ;;
        [xX]) # Ejecutar lo seleccionado
            repo_actual="${REPOSITORIOS[$indice_repositorios]}"
            
            # Revisamos qué número de opción (Acción) está seleccionada
            case $indice_opciones in
              0) # "Guardar cambios"
                guardar_cambios "$repo_actual"
                ;;
              1) # "Agregar nuevo"
                agregar_repositorio
                ;;
              2) # "Eliminar"
                quitar_repositorio
                ;;
              3) # "Ver créditos"
                ver_creditos
                ;;
            esac
            ;;
    esac
}

# Terminal - UI
while true; do
    if [ "$ESTADO" = "INICIO" ]; then
        inicio
    elif [ "$ESTADO" = "SALIR" ]; then
        break
    elif [ "$ESTADO" = "AGREGAR_REPOSITORIO" ]; then
        interfaz_add_repositorio
    elif [ "$ESTADO" = "QUITAR_REPOSITORIO" ]; then
        interfaz_quitar_repositorio "$repo_actual"
    fi
done
echo "¡Nos vemos, FSkyCode!"
