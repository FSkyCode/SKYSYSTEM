for archivo in Codigos/*.sh; do
  if [[ "$archivo" == "${BASH_SOURCE[0]}" ]]; then
#    echo "Bucle bloqueado"
    continue
  fi
 # echo "$archivo"
 # source "$archivo"
done
