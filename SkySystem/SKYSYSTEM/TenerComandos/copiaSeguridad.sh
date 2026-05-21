crearCopia() {
  echo "Creando copia de seguridad..."
  if cp ~/.bashrc Copias/copia_seguridad.sh 2>/dev/null; then
    echo "Copia de seguridad exitosa =D"
    echo "Finalizando el proceso"
  else
    echo "No se pudo crear una copia de seguridad..."
    echo "Finalizando el proceso"
  fi
}

crearCopia
