# PROTOTIPO Version -> 100%!
# Alias u otros datos
alias sd='skycd'
skymainBASICO="/mnt/c/Users/juanf/"
bluemainBASICO="/storage/emulated/0/"

# Prototipo de comandos
Prototipo="systemCopyCommands.sh"

# Opciones de navegacion
skymainOPTIONS=(
  "SKYSYSTEM"
  "SKYCARPETA"
  "> LUCKY-BLOCK-GAME"
  "REPOSITORIOS"
  "> terminal-config"
  "> Proyecto-G-nesis-ASISTENTE-"
)
bluemainOPTIONS=(
  "SKYSYSTEM"
  "SKYCARPETA"
  "> LUCKY-BLOCK-GAME"
  "REPOSITORIOS"
  "> terminal-config"
)


# Comandos personalisados
# Help
help() {
  echo -e "\e[36m=========== SKY HELP ===========\e[0m"
  echo -e "\e[34mcolors:\e[96m Ver el numero de color para echos =D"
  echo -e "\e[33mcargaIm:\e[0m Carga archivos con codigos del sistema y subsistema."
  echo -e "\e[33mskycd:\e[0m Una mejora a 'cd'."
  echo -e "\e[33mback:\e[0m Salir de una carpeta."
  echo -e "\e[33mat:\e[0m Devolverte a la ultima carpeta."
  echo -e "\e[33mskymainAllSaves:\e[0m Un save a todas las carpetas."
  echo -e "\e[33mskymain:\e[0m Atajos para carpetas importantes en SkyMain."
  echo -e "\e[33mbluemain:\e[0m ..."
  echo -e "\e[33mskylun:\e[0m ..."
  echo -e "\e[33msave:\e[0m Guardar con git."
  echo -e "\e[33msaveAndExit:\e[0m Guardar y salir."
  echo -e "\e[36mLOL=============================\e[0m"
}

colors() {
  echo "===== COLORES NORMALES ====="
  for i in {30..37}; do
    echo -e "\e[${i}mColor codigo ${i}m\e[0m"
    done

  echo ""
  echo "===== COLORES BRILLANTES ====="
  for i in {90..97}; do
    echo -e "\e[${i}mColor codigo ${i}m\e[0m"
    done

  echo ""
  echo "===== FONDOS ====="
  for i in {40..47}; do
    echo -e "\e[${i}mFondo codigo ${i}m\e[0m"
    done

  echo ""
  echo "===== FONDOS BRILLANTES ====="
  for i in {100..107}; do
    echo -e "\e[${i}mFondo codigo ${i}m\e[0m"
    done

  echo ""
  echo "===== ESTILOS ====="
  echo -e "\e[1m1 Negrita\e[0m"
  echo -e "\e[2m2 Opaco\e[0m"
  echo -e "\e[3m3 Italico\e[0m"
  echo -e "\e[4m4 Subrayado\e[0m"
  echo -e "\e[5m5 Parpadeo\e[0m"
  echo -e "\e[7m7 Invertido\e[0m"
}

# Comandos personalizados
skycd() {
  if [ -z "$1" ]; then
    echo -e "\e[31mDigita una ubicacion lol\e[0m"
    return 1
  fi

  if ! cd "$1"; then
    echo -e "\e[31mNo se pudo entrar a la carpeta\e[0m"
    return 1
  fi

  echo -e "\e[32mEstas en $(pwd)\e[0m"
  echo -e "\e[34mArchivos:\e[0m"
  ls -a
}

skymkdir() {
  mkdir -p "$1"
  touch "$1/.gitkeep"
  echo "Carpeta $1 creada =D"
}

back() {
  echo "Saliendo..."
  skycd ..
  echo "Ya saliste a $1... ahora sal a tocar pasto XD"
}

at() {
  echo "Atajo fuaaa"
  cd -
  echo "Y volo... Nombrando su barco Libertad"
}

# PRUEBA
skymkdirLIMPIEZA() {
  local base="/mnt/c/Users/juanf/PROYECTOS/REPOSITORIOS/terminal-config"
  
  # 1. Buscamos todas las carpetas dentro de la base (excluyendo la base misma)
  # Usamos find para que sea más robusto
  for carpeta in $(find "$base" -mindepth 1 -type d); do
    
    # 2. Contamos cuántos archivos hay (incluyendo ocultos como .gitkeep)
    total_archivos=$(ls -A "$carpeta" | wc -l)

    # 3. Lógica de protección
    if [ "$total_archivos" -eq 1 ]; then
      # Verificamos si ese único archivo es un .gitkeep
      if [ -f "$carpeta/.gitkeep" ]; then
        echo "Protegiendo: $carpeta (Solo contiene .gitkeep)"
      else
        echo "Alerta: $carpeta tiene 1 archivo que NO es .gitkeep"
      fi
    elif [ "$total_archivos" -eq 0 ]; then
      echo "Carpeta vacía detectada: $carpeta. Añadiendo protección..."
      touch "$carpeta/.gitkeep"
    else
      echo "OK: $carpeta tiene $total_archivos archivos."
      # Opcional: Si quieres borrar el .gitkeep porque ya hay archivos reales
      rm -f "$carpeta/.gitkeep"
    fi
  done
}

# --  Dispositivos  --
# Comandos helpers

# Guardado Globalizado
skymainAllSaves() {
  cd
  skymain 1 && echo "A guardar SKYCARPETA"
  save
  for dir in /c/Users/juanf/REPOSITORIOS/*; do
    if [ -d "$dir/.git" ]; then
      echo "Repositorio: $dir"
      cd "$dir" || continue
      save
      echo "----------------"
    fi
  done
}

maincd() {
  local ruta="$1"
  local nombre="$2"
  local menu="$3"
  local autosave="$4"

  cd ~ || return
  skycd "$ruta"

  echo "Estas en $nombre"

  if [[ "$autosave" == "S" ]]; then
    sleep 1
    echo "Guardando durante navegacion"
    save
  else
    echo "Sin guardar despues de navegacion"
    mostrar_opciones "$menu"
  fi
}

mostrar_opciones() {
  local tipo="$1"
  local usuarioNavegacion

  if [[ "$tipo" == "skymain" ]]; then
    echo "Opciones de SkyMain:"
    usuarioNavegacion="skymainOPTIONS"
  elif [[ "$tipo" == "bluemain" ]]; then
    echo "Opciones de BlueMain:"
    usuarioNavegacion="bluemainOPTIONS"
  else
    echo "Menu desconocido"
    return
  fi

  declare -n opciones="$usuarioNavegacion"

  local i=1
  for item in "${opciones[@]}"; do
    echo "[$i] = $item"
    ((i++))
  done
}


# Para SkyMain - Laptod OP
skymain() {
  case "$1" in
    1)
      maincd "${skymainBASICO}SKYSYSTEM" "SKYSYSTEM" "skymain" "$2"
      ;;
    2)
      maincd "$skymainBASICO"PROYECTOS/SKYCARPETA "SKYCARPETA" "$2"
      ;;
    3)
      maincd "$skymainBASICO"PROYECTOS/SKYCARPETA "AUN NO DISPONIBLE" "$2"
      ;;
    4)
      maincd "$skymainBASICO"PROYECTOS/REPOSITORIOS "REPOSITORIOS" "$2"
      ;;
    5)
      maincd "$skymainBASICO"PROYECTOS/REPOSITORIOS/terminal-config "TERMINAL-CONFIG" "$2"
      ;;
    6)
      maincd "$skymainBASICO"PROYECTOS/REPOSITORIOS/ "AUN NO DISPONIBLE" "$2"
      ;;
    *)
      mostrar_opciones "skymain"
      ;;
  esac
}

# Para BlueMain - Android no OP
bluemain() {
  case "$1" in
    1)
      maincd "$bluemainBASICO"SKYSYSTEM "No existe SKYSYSTEM" "$2"
      ;;
    2)
      maincd "$bluemainBASICO"SKYCARPETA "SKYCARPETA" "$2"
      ;;
    3)
      maincd "$bluemainBASICO"SKYCARPETA/root/ESCRIBIR/ "SKYCARP" "$2"
      ;;
    4)
      maincd "$bluemainBASICO"REPOSITORIOS "REPOSITORIOS" "$2"
      ;;
    5)
      maincd "$bluemainBASICO"REPOSITORIOS/terminal-config "TERMINAL-CONFIG" "$2"
      ;;
    6)
      maincd "$bluemainBASICO"REPOSITORIOS/Proyecto-G-nesis-ASISTENTE- "SIN NOMBRE" "$2"
      ;;
    *)
      mostrar_opciones "bluemain"
      ;;
  esac
}

# Para SkyLun - Laptod Ubuntu/Lubuntu
skylun() {
  case "$1" in
    1)
      skycd REPOSITORIOS && echo "Estas en REPOSITORIOS lol"
      ;;
    2)
      skycd SKYCARPETA && echo "Estas en SKYCARPETA"
      ;;
    *)
      echo "Opciones:"
      echo "1 = Repositorios"
      echo "2 = SKYCARPETA"
      ;;
  esac
}

# Guardar y cargar
save() {
  echo "Guardando..."

  git add .

  git commit -m "auto-save" || echo "Nada que commitear"

  # IMPORTANTE
  if ! git pull --rebase; then
    echo "Error en rebase, abortando..."
    git rebase --abort 2>/dev/null
    return 1
  fi

  if ! git push; then
    echo "Error al hacer push"
    return 1
  fi
}

saveAndExit() {
  echo "Guardando y saliendo, ten cuidado!"
  save
  echo "Bye lol"
  exit
}
