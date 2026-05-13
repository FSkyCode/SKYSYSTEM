# PROTOTIPO A MODIFICAR
BASHRC="$HOME/.bashrc"
source carga.sh
source Codigos/Basico.sh

# PREGUNTAS
pregunta_A() {
  while true; do
    log "Ha habido distintos errores durante la carga, ¿seguir?"
    read -p "Y|y / N|n> " respuesta_A

    case "$respuesta_A" in
      Y|y)
        log "Todo listo, disfrute sus comandos!"
        sleep 1
        clear
        break
        ;;
      N|n)
        log "Entendido, eliminando modificaciones..."
        cp copia_seguridad "$BASHRC"
        sleep 3
        clear
        break
        ;;
      *)
        log "Inserte una opcion correcta, por favor"
        ;;
    esac
  done
}

pregunta_B() {
  log "Todo ha sido correctamente cargado, por favor prosiga"
  read -n 1 -s -r -p "> Presione cualquier tecla"
  clear
}

# Comandos importantes
SystemCopyCommands() {
  source systemCopyCommands.sh
  cargar_sistema
  source ~/.bashrc
}


# Final
sky() {
  comando="$1"

  case "$comando" in
    SystemCopyCommands|systemCopyCommands)
      SystemCopyCommands
      ;;
    Help|help)
      help
      ;;
    *)
      helpSystem
      ;;
    esac
}

comandosSystem=(
  "SystemCopyCommands"
  "Help"
)

helpSystem() {
  local i=1
  for item in "${comandosSystem[@]}"; do
    echo "[$i] =  $item"
    ((i++))
  done
}

_sky_completion() {
  COMPREPLY=($(compgen -W "SystemCopyCommands help" -- "${COMP_WORDS[1]}"))
}

complete -F _sky_completion sky
