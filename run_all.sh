#!/bin/bash

# Verificar que se pase un argumento para el stage
if [ -z "$1" ]; then
    echo "Por favor, especifica un entorno: --dev, --test, o --prod"
    exit 1
fi

# Asignar el valor del entorno
STAGE=$1  # El valor será --dev, --test, o --prod

# Definir las carpetas y las imágenes Docker (diccionario)
declare -A carpetas
carpetas=(
    ["Ingesta1"]="ingesta1"
    ["Ingesta2"]="ingesta2"
    ["Ingesta3"]="ingesta3"
    ["Ingesta4"]="ingesta4"
    ["Ingesta5"]="ingesta5"
    ["Ingesta6"]="ingesta6"
)

# Recorrer todas las carpetas del diccionario
for carpeta in "${!carpetas[@]}"; do
  imagen="${carpetas[$carpeta]}" # Obtener el nombre de la imagen correspondiente

  echo "Construyendo la imagen Docker para $carpeta (imagen: $imagen)..."

  # Cambiar al directorio de la carpeta correspondiente
  cd $carpeta

  # Construir la imagen Docker
  docker build -t $imagen .

  # Ejecutar el contenedor Docker pasando el entorno como variable de entorno
  echo "Corriendo el contenedor para $carpeta con la imagen $imagen..."
  docker run -v /home/ubuntu/.aws/credentials:/root/.aws/credentials -e STAGE=$STAGE $imagen

  # Volver al directorio anterior
  cd ..

  echo "Proceso completado para $carpeta."
done

echo "¡Todos los procesos de build y run han sido completados!"
