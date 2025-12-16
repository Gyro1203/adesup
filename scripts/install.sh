#!/bin/sh
set -e

echo "⏳ Esperando archivos de WordPress..."
sleep 40


if wp core is-installed --allow-root 2>/dev/null; then
  echo "✅ WordPress ya instalado"
  exit 0
fi


echo "🛠️ Instalando WordPress"
wp core install \
  --url="http://localhost:8000" \
  --title="Mi sitio Docker" \
  --admin_user="admin" \
  --admin_password="admin123" \
  --admin_email="admin@test.local" \
  --skip-email \
  --allow-root

echo "🔧 Preparando directorios para plugins e idiomas..."
mkdir -p /var/www/html/wp-content/upgrade || true
mkdir -p /var/www/html/wp-content/languages || true
mkdir -p /var/www/html/wp-content/plugins || true
mkdir -p /var/www/html/wp-content/uploads || true
chmod -R 777 /var/www/html/wp-content || true

echo "🌍 Descargando idioma español"
wp language core install es_ES --activate --allow-root || echo "⚠️ No se pudo instalar es_ES (continuando...)"

echo "📦 Instalando All-in-One WP Migration..."
wp plugin install all-in-one-wp-migration --activate --allow-root || echo "⚠️ No se pudo instalar All-in-One WP Migration (continuando...)"

echo "🔐 Preparando directorios para el plugin All-in-One WP Migration..."
mkdir -p /var/www/html/wp-content/ai1wm-backups || true
mkdir -p /var/www/html/wp-content/plugins/all-in-one-wp-migration/storage || true
chown -R www-data:www-data /var/www/html/wp-content/ai1wm-backups || true
chown -R www-data:www-data /var/www/html/wp-content/plugins/all-in-one-wp-migration/storage || true
chmod -R 777 /var/www/html/wp-content/ai1wm-backups || true
chmod -R 777 /var/www/html/wp-content/plugins/all-in-one-wp-migration/storage || true
chmod -R 777 /var/www/html/wp-content || true

echo "✅ WordPress instalado correctamente"
