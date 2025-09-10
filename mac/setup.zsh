#!/bin/zsh

# Set variables
SOURCE_DIR="."              # Current working directory
DEST_DIR="$HOME/Scripts"

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
  echo "Usage: ./setup.zsh"
  echo
  echo "Recursively adds all scripts (identified as files with no extension) to $DEST_DIR"
  exit 0
fi

# Clear and recreate destination directory
mkdir -p "$DEST_DIR"

# Find and move files without extensions
find "$SOURCE_DIR" -type f -not -name "*.*" -exec cp "{}" "$DEST_DIR" \;

echo "Done!"