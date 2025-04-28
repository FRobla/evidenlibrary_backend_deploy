#!/bin/bash

# Colores
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Limpiando completamente el proyecto...${NC}"

# Eliminar completamente la carpeta target
rm -rf target/

# Limpiar la caché de Maven para este proyecto
echo -e "${YELLOW}Ejecutando limpieza de Maven...${NC}"
./mvnw clean

# Actualizar dependencias
echo -e "${YELLOW}Actualizando dependencias...${NC}"
./mvnw dependency:purge-local-repository -DreResolve=false

# Compilar y empaquetar el proyecto
echo -e "${YELLOW}Compilando y empaquetando...${NC}"
./mvnw package -DskipTests

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Compilación exitosa. Iniciando aplicación...${NC}"
    java -jar target/backend-0.0.1-SNAPSHOT.jar
else
    echo -e "${RED}Error en la compilación. Revisa los errores anteriores.${NC}"
    exit 1
fi