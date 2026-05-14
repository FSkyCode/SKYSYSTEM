#!/bin/bash

# Esta función recibirá el nombre del repo y hará el trabajo
guardar_cambios() {
    local repo=$1
    echo -e "\n[LOG] Guardando cambios en: $repo..."
    # Aquí es donde luego pondrás: git add . && git commit...
    sleep 2
}

agregar_repositorio() {
  ESTADO="AGREGAR_REPOSITORIO"
  sleep 1
}

quitar_repositorio() {
  ESTADO="QUITAR_REPOSITORIO"
  sleep 1
}

ver_creditos() {
    clear
    echo "=========================================="
    echo " Creado por: FSkyCode (Juan Felipe)"
    echo " Proyecto: SKYSYSTEM 2026"
    echo "=========================================="
    read -n 1 -s -r -p "Presiona cualquier tecla para volver..."
}

