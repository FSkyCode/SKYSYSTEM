# CUADRO DINAMICO
LOG_LINE=6

log() {
  tput cup $LOG_LINE 2
  tput el  # 🔥 limpia la línea antes de escribir
  printf "%-30s" "$1"
  ((LOG_LINE++))

  if (( LOG_LINE > 15 )); then
    LOG_LINE=6
  fi
}

loader_ui() {
  echo "PROTOTIPO SKYSYSTEM"
  echo "Asegurese de estar en Terminal-Config"
  echo "SystemCopyCommands ejecutandose... (copiando)"
  sleep 4
  clear
  echo "================================="
  echo "       COPIANDO ARCHIVOS"
  echo "================================="
  echo ""
  echo "+-------------------------------+"
  for i in {1..10}; do
    echo "|                               |"
  done
  echo "+-------------------------------+"
  echo ""
}

# CARGAR ARCHIVOS
loading_bar() {
  local progress=$1
  local total=$2
  local width=30

  local percent=$((progress * 100 / total))
  local filled=$((progress * width / total))

  tput cup 17 2
  printf "[%-${width}s] %d%%" "$(printf '#%.0s' $(seq 1 $filled))" "$percent"
}

# Verificar archivos
copiar_archivos() {
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
actualizar_bloque() {
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
