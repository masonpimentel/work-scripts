#!/bin/zsh

if [[ "$1" == "-h" || "$1" == "--help" ]]; then
  echo "Usage: ./setup.zsh"
  echo
  echo "Recursively adds all scripts (identified as files with no extension) to $HOME/Scripts"
  echo "Also unaliases `l` for the custom `l` script here"
  exit 0
fi

# Set variables
SOURCE_DIR="."              # Current working directory
DEST_DIR="$HOME/Scripts"

# Clear and recreate destination directory
mkdir -p "$DEST_DIR"

# Find and move files without extensions
find "$SOURCE_DIR" -type f -not -name "*.*" -exec cp "{}" "$DEST_DIR" \;

echo "Done!"