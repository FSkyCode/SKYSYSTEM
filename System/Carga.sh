# carga_ui() {}

PruebaSystemCopyCommands() {
 Inicio
}

# Estados
TERMINAL_ESTADO="INICIO" 
# INICIO = Inicio
# PASO_1 = Paso1
# PASO_2 = Paso2

# Menu
Inicio() {
  while true; do
  read -p "$TERMINAL_ESTADO > " terminalEstado

  case "$terminalEstado" in
    ProcesoCompleto) TERMINAL_ESTADO="INICIO/PROCESO_COMPLETO" ;;
    salir) break ;;
    *) help ;;
    esac
  done
}

help() {
  echo ""
  echo "... No hay nada lol"
}

Paso1() {
  # PASO 1 - COPIA DE SEGURIDAD
  contenido=( "XD" "Lol" )
  contenido_texto=$(printf "%s\n" "${contenido[@]}")
  UI "Cuadro" "COPIA" "$contenido_texto"

  log "Creando copia de seguridad..."
  if cp ~/.bashrc Copias/copia_seguridad.sh 2>/dev/null; then
    log "Copia de seguridad exitosa =D"
    Paso2
  else
    log "No se pudo crear una copia de seguridad, ¿continuar?"
    read -p "> " respuesta

    if [[ "$respuesta" == "Y" || "$respuesta" == "y" ]]; then
      log "Adios..."
      sleep 1
      Paso2
    elif [[ "$respuesta" == "N" || "$respuesta" == "n" ]]; then
      log "Pausando proceso..."
      sleep 1
      clear
    else
      log "Introduzca una respuesta válida (y/n)"
    fi
  fi
}

Paso2() {
  # CARGA
  contenido=(
    "Recuerde estar en Terminal-Config!"
    "Este proceso sera corto, podra configurar cosas mas tarde!"
  )
  cargar=(
  "System/modulo.sh"
  "Codigos/modulo.sh"
  )
  UI "Barra_Carga" "SYSTEM COPY COMMANDS" "${contenido[@]}"

}



# Funciones

copiar=(
  "Codigos/modulo.sh"
  )
BASHRC="~/.bashrc"

Copiar_Archivos() {
  for archivo in "${copiar[@]}"; do
    if [[ -f "$archivo" ]]; then
      ((progreso++))
      log "Procesando $archivo"
      loading_bar $progreso $total
      sleep 0.2
    else
      log "Error: $archivo no existe"
      ((errores++))
    fi
  done

  if (( errores == 0 )); then
    actualizar_bloque
    pregunta_B
  else
    pregunta_A
  fi
}

# Helper
Actualizar_Bloque() {
  local temp_file
  temp_file=$(mktemp)

  # Construir contenido nuevo
  {
    echo "# SKYSYSTEM START"
    for archivo in "${copiar[@]}"; do
      [[ -f "$archivo" ]] && cat "$archivo"
    done
    echo "# SKYSYSTEM END"
  } > "$temp_file"

  # Si ya existe el bloque → reemplazarlo
  if grep -q "# SKYSYSTEM START" "$BASHRC"; then
    awk '
      BEGIN {skip=0}
      /# SKYSYSTEM START/ {skip=1; next}
      /# SKYSYSTEM END/ {skip=0; next}
      skip==0 {print}
    ' "$BASHRC" > "$BASHRC.tmp"

    cat "$temp_file" >> "$BASHRC.tmp"
    mv "$BASHRC.tmp" "$BASHRC"
  else
    # Si no existe → añadir al final
    cat "$temp_file" >> "$BASHRC"
  fi

  rm "$temp_file"
}

# Inicio de la cadena domino
cargar_sistema() {
  loader_ui

  copiar=(
    "Basico.sh"
#    "SkyMain.sh"
 #   "BlueMain.sh"
  )

  total=${#copiar[@]}
  progreso=0
  errores=0

  log "Creando copia de seguridad..."
  if cp ~/.bashrc copia_seguridad.sh 2>/dev/null; then
    log "Copia de seguridad exitosa =D"
    copiar_archivos
  else
    log "No se pudo crear una copia de seguridad, continuar o pausar? (c/p)"
    read -p "> " respuesta
    if [[ "$respuesta" == "c" ]]; then
      copiar_archivos
    elif [[ "$respuesta" == "p" ]]; then
      log "Pausando proceso..."
      sleep 2
      clear
    else
      log "Introduzca una respuesta disponible (y/n)"
    fi
  fi
}
