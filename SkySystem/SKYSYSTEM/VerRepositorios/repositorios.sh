#!/bin/bash

# Configuración de rutas
DATA_DIR="./data"
RUTA_DAT="$DATA_DIR/rutas.dat"
SKYSYSTEM_DIR="$HOME/Repositorios/root"

# Asegurarnos de que las carpetas existan
mkdir -p "$DATA_DIR"
mkdir -p "$SKYSYSTEM_DIR"


obtener_ruta() {
    local buscando="$1"
    # grep busca la línea, cut corta por el ":" y toma la segunda parte (f2)
    local resultado=$(grep "^$buscando:" "$RUTA_DAT" | cut -d':' -f2)
    echo "$resultado"
}
# Ejemplo de uso:
# RUTA_A_USAR=$(obtener_ruta "Happy-Bird")
obtener_repos_github() {
    # gh repo list devuelve: "usuario/nombre-repo  descripción..."
    # Usamos awk para quedarnos solo con el "nombre-repo" después del '/'
    gh repo list --limit 100 | awk '{print $1}' | cut -d'/' -f2
}



# Para guardar un repositorio en especifico
interfaz_guardar_cambios() {
  save $1
}


interfaz_add_carpeta() {
  echo "Para separar por categoria lol"
  sleep 1
  ESTADO="INICIO"
}


add_repositorio() {
    local repo_nombre="$1"
    local destino="$SKYSYSTEM_DIR/$repo_nombre"

    echo -e "\n[+] Iniciando clonación en instancia SKYSYSTEM..."

    # 1. Clonar usando SSH en la ruta específica
    if git clone "git@github.com:$USUARIO/$repo_nombre" "$destino"; then
        echo -e "${VERDE}✓ Clonado con éxito en: $destino${RESET}"
        
        # 2. Guardar la relación "Nombre:Ruta" en el archivo .dat
        # Usamos echo en lugar de cat para escribir texto directo
        echo "$repo_nombre:$destino" >> "$RUTA_DAT"
        
        echo "[!] Ruta guardada en base de datos."
    else
        echo -e "${RED}✗ Error: No se pudo clonar el repositorio.${RESET}"
    fi
    
    sleep 2
}

interfaz_add_repositorio() {
    clear
    echo "=========================================="
    echo "    BUSCANDO REPOSITORIOS EN GITHUB...   "
    echo "=========================================="

    # 0. Verificar
    if ! command -v gh >/dev/null 2>&1; then
         echo "GitHub CLI no encontrado."
         echo "Instálalo desde:"
         echo "https://cli.github.com/"
    fi

echo "gh encontrado correctamente"

    # 1. Guardar los repositorios en un array de Bash
    mapfile -t REPOS < <(obtener_repos_github)

    if [ ${#REPOS[@]} -eq 0 ]; then
        echo -e "${RED}✗ No se encontraron repositorios o no estás autenticado con 'gh auth login'.${RESET}"
        sleep 2
        ESTADO="INICIO"
    fi

    echo "Selecciona el repositorio que deseas clonar:"
    echo "------------------------------------------"
    
    # 2. Menú interactivo numerado
    select repo_seleccionado in "${REPOS[@]}" "Cancelar y volver"; do
        if [ "$repo_seleccionado" = "Cancelar y volver" ]; then
            echo "Operación cancelada."
            sleep 1
            break
        elif [ -n "$repo_seleccionado" ]; then
            # 3. Si seleccionó un repo válido, llamamos a tu función original
            add_repositorio "$repo_seleccionado"
            break
        else
            echo "Opción inválida. Elige un número de la lista."
        fi
    done

    ESTADO="INICIO"
}

interfaz_quit_repositorio() {
    local repo_actual="$1"

    clear
    echo "=========================================="
    echo "           QUITAR REPOSITORIO"
    echo "=========================================="
    echo "Repositorio seleccionado: $repo_actual"
    echo -n "¿Está seguro de eliminarlo de la lista? (y/n): "
    read -r verificacion

    if [[ "$verificacion" =~ ^[yY]$ ]]; then
        echo "Buscando '$repo_actual' en la base de datos..."
        
        # El símbolo ^ indica "inicio de línea"
        # Así evitamos borrar por error algo que contenga el nombre pero no sea el ID
        ruta_repo=$(obtener_ruta "$repo_actual")
        if sed -i "/^$repo_actual:/d" "$RUTA_DAT"; then
           echo "¡Listo! Repositorio quitado de la lista."
           if rm -rf "$ruta_repo"; then
	     echo "¡Listo! Repositorio eliminado"
           else
	     echo "No se pudo eliminar... Tener a cuenta!"
           fi
        else
            echo "Error: No se encontró el registro."
        fi
        
        sleep 1
        ESTADO="INICIO"
    else
        echo "Cancelado. Volviendo al inicio..."
        sleep 1
        ESTADO="INICIO"
    fi
}
