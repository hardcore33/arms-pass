#!/bin/bash
set -e
echo "=== Preparando ambiente Flutter Web para Vercel ==="

git config --global --add safe.directory '*' 2>/dev/null || true

if ! command -v flutter &> /dev/null; then
  echo "Instalando Flutter SDK (channel stable)..."
  rm -rf $HOME/flutter
  git clone https://github.com/flutter/flutter.git --depth 1 -b stable $HOME/flutter
  export PATH="$PATH:$HOME/flutter/bin"
fi

echo "Versao do Flutter:"
flutter --version
flutter config --no-analytics
echo "Compilando Flutter Web Release..."
flutter build web --release
echo "=== Build concluído com sucesso em build/web! ==="
