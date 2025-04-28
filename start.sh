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

# Limpiar caché de Hibernate si existe
if [ -d "$APP_DIR/org/hibernate" ]; then
  echo "Limpiando caché de Hibernate..."
  rm -rf $APP_DIR/org/hibernate/*
fi

# Crear un directorio para el archivo de limpieza
mkdir -p "$APP_DIR/cleanup"

# Asegurarse que tengamos permisos adecuados
chmod 755 $APP_DIR/app.jar

# Iniciar la aplicación con opciones para forzar recarga de clases y activar la limpieza
echo "Iniciando aplicación Spring Boot..."
java -XX:+TieredCompilation -XX:TieredStopAtLevel=1 \
     -Dspring.jpa.properties.hibernate.cache.use_second_level_cache=false \
     -Dspring.jpa.properties.hibernate.cache.use_query_cache=false \
     -Dspring.jpa.defer-datasource-initialization=true \
     -Dspring.jpa.properties.hibernate.enable_lazy_load_no_trans=true \
     -jar $APP_DIR/app.jar