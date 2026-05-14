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


add_carpeta() {
  echo "Para separar por categoria lol"
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
  echo "      AGREGAR NUEVO REPOSITORIO"
  echo "=========================================="
  echo -n "Introduce el nombre del repo en GitHub: "
  read -r nombre_nuevo
  
  if [ -n "$nombre_nuevo" ]; then
    add_repositorio "$nombre_nuevo" && ESTADO="INICIO"
    # Opcional: Recargar la lista de REPOSITORIOS (ver nota abajo)
  else
    echo "Operación cancelada."
    sleep 1
    ESTADO="INICIO"
    fi
}


interfaz_quitar_repositorio() {
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
        if sed -i "/^$repo_actual:/d" "$RUTA_DAT"; then
            echo "¡Listo! Repositorio quitado de la lista."
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
