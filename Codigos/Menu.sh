# -- MENUS DINAMICOS O ESPECIALES --
# COMANDOS U HELPERS
UI() {
  tipo="$1"
  titulo="$2"
  contenido="$3"

  case "$tipo" in
    Cuadro)
      CUADRO "$titulo" "$contenido" ;;
    Barra_Progreso)
      BARRA_PROGRESO "$titulo" "$contenido" ;;
    *)
      helpUI
      ;;
  esac
}

helpUI() {
  echo "-- TIPOS DE UI --"
  echo "1 = Cuadro"
  echo "2 = Barra_Progreso"
  echo "-- ARGUMENTOS PARA UI --"
  echo "1 = Tipo"
  echo "2 = Titulo/Valor 1"
  echo "3 = Contenido/Valor 2"
}

texto_centrado() {
  local texto="$1"
  local ancho=50
  local relleno="================================="

  local len=${#texto}
  local total_esp=$((ancho - len))

  local izq=$(( total_esp / 2 ))
  local der=$(( total_esp - izq ))

  printf "%*s%s%*s\n" \
    "$izq" "" \
    "$texto" \
    "$der" ""
}

# TIPO 1 - CUADRO DE CARGA
LOG_LINE=6

log() {
  tput cup $LOG_LINE 4
  tput el
  echo "-> $1"
  ((LOG_LINE++))
  [[ $LOG_LINE -gt 15 ]] && LOG_LINE=6
}

CUADRO() {
  clear
  echo "================================="
  texto_centrado "$1"
  echo "================================="
  echo ""
  echo "$2"
  echo ""
  echo "+-------------------------------+"
  for i in {1..10}; do
    echo "|                               |"
  done
  echo "+-------------------------------+"
  echo ""
}

# TIPO 2 - BARRA DE PROGRESO

BARRA_PROGRESO() {
  local progress=$1
  local total=$2
  local width=30

  local percent filled

  if [[ $total -eq 0 ]]; then
    percent=0
    filled=0
  else
    percent=$((progress * 100 / total))
    filled=$((progress * width / total))
  fi

  local bar
  bar=$(printf '%*s' "$filled" | tr ' ' '#')

  tput cup 17 2
  printf "[%-${width}s] %d%%" "$(printf '#%.0s' $(seq 1 $filled))" "$percent"
}

# TIPO 3 -
