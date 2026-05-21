#!/bin/bash

# Estas funciones recibiran el nombre del repo y haran el trabajo
boton_guardar_cambios() {
  ESTADO="GUARDAR_CAMBIOS"
  sleep 1
}

boton_add_carpeta() {
  ESTADO="ADD_CARPETA"
  sleep 1
}

boton_add_repositorio() {
  ESTADO="ADD_REPOSITORIO"
  sleep 1
}

boton_quit_repositorio() {
  ESTADO="QUIT_REPOSITORIO"
  sleep 1
}

boton_ver_creditos() {
    clear
    echo "=========================================="
    echo " Creado por: FSkyCode (Juan Felipe)"
    echo " Proyecto: SKYSYSTEM 2026"
    echo "=========================================="
    read -n 1 -s -r -p "Presiona cualquier tecla para volver..."
}

