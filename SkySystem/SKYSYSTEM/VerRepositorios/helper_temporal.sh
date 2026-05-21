save() {
    local repo_nombre=$1
    # Buscamos la ruta real en el archivo .dat usando el nombre
    local ruta_repo=$(grep "^$repo_nombre:" "$RUTA_DAT" | cut -d':' -f2)

    # 1. Verificar si la ruta existe
    if [ ! -d "$ruta_repo" ]; then
        echo -e "${RED}Error: La carpeta no existe en $ruta_repo${RESET}"
        echo "Volviendo..."
    else
        cd "$ruta_repo" || return
        clear
        echo "=========================================="
        echo "  Sincronizando: $repo_nombre"
        echo "=========================================="

        # 2. Verificar si hay cambios reales
        if [ -z "$(git status --porcelain)" ]; then
             echo "No hay cambios para subir. Todo al día =D"
             sleep 1
        else
             echo "Se detectaron cambios. Subiendo..."

             # 3. Proceso de Git
             git add .

             # Pedir mensaje de commit rápido
             echo -n "Mensaje del commit: "
             read -r mensaje
             [ -z "$mensaje" ] && mensaje="Update desde SKYSYSTEM $(date +'%Y-%m-%d %H:%M')"

             git commit -m "$mensaje"

             echo "Haciendo Push a GitHub..."
             if git push; then
             echo -e "${VERDE}✓ ¡Sincronización exitosa!${RESET}"
             else
             echo -e "${RED}✗ Error al subir. Revisa tu conexión o llave SSH.${RESET}"
             fi
        sleep 2
        # Volver a la carpeta del script para no romper la interfaz
        cd - > /dev/null
        ESTADO="INICIO"
        fi
    fi
    sleep 2
    ESTADO="INICIO"
    # Aqui se copi lo de adelante en lo de atras1
}

dev_borrar_referencia() {
    cd "$ruta_repo" || return
    clear
    echo "=========================================="
    echo "  Sincronizando: $repo_nombre"
    echo "=========================================="

    # 2. Verificar si hay cambios reales
    if [ -z "$(git status --porcelain)" ]; then
        echo "No hay cambios para subir. Todo al día =D"
        sleep 1
    else
        echo "Se detectaron cambios. Subiendo..."
        
        # 3. Proceso de Git
        git add .
        
        # Pedir mensaje de commit rápido
        echo -n "Mensaje del commit: "
        read -r mensaje
        [ -z "$mensaje" ] && mensaje="Update desde SKYSYSTEM $(date +'%Y-%m-%d %H:%M')"
        
        git commit -m "$mensaje"
        
        echo "Haciendo Push a GitHub..."
        if git push; then
            echo -e "${VERDE}✓ ¡Sincronización exitosa!${RESET}"
        else
            echo -e "${RED}✗ Error al subir. Revisa tu conexión o llave SSH.${RESET}"
        fi
        sleep 2
    fi

    # Volver a la carpeta del script para no romper la interfaz
    cd - > /dev/null
    ESTADO="INICIO"
}
