#!/bin/sh
echo "Iniciando proceso de limpieza"

# Directorio de trabajo actual
APP_DIR="/app"

# Limpiar archivos temporales si existen
if [ -d "$APP_DIR/temp" ]; then
  echo "Limpiando directorio temporal..."
  rm -rf $APP_DIR/temp/*
fi

# Limpiar caché de metadatos si existe
if [ -d "$APP_DIR/META-INF" ]; then
  echo "Limpiando caché de metadatos..."
  rm -rf $APP_DIR/META-INF/*
fi

# Asegurarse que tengamos permisos adecuados
chmod 755 $APP_DIR/app.jar

# Iniciar la aplicación con opciones para forzar recarga de clases
echo "Iniciando aplicación Spring Boot..."
java -XX:+TieredCompilation -XX:TieredStopAtLevel=1 -Dspring.jpa.hibernate.ddl-auto=update -jar $APP_DIR/app.jar