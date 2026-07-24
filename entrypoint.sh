#!/bin/bash
set -e

INSTALL="/server/tmodloader"
ZIP="/server/tmodloader.zip"
WORLD_DIR="/root/.local/share/Terraria/tModLoader/Worlds"
WORLD_FILE="$WORLD_DIR/Капризный_вымысел.wld"

mkdir -p "$INSTALL"
mkdir -p "$WORLD_DIR"

echo "Checking tModLoader..."

# если не распакован — качаем
if [ ! -f "$INSTALL/start-tModLoaderServer.sh" ]; then
  echo "Downloading tModLoader..."

  curl -L -o "$ZIP" \
    https://github.com/tModLoader/tModLoader/releases/download/v2026.05.3.0/tModLoader.zip

  unzip -o "$ZIP" -d "$INSTALL"
  rm "$ZIP"
fi

cd "$INSTALL"

chmod +x start-tModLoaderServer.sh || true

echo "Starting server (auto world)..."

exec ./start-tModLoaderServer.sh \
  -nographics \
  -batchmode \
  -world "$WORLD_FILE" \
  -difficulty 2 \
  -port 7777
