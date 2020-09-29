#!/usr/bin/env bash

set -eu
set -o pipefail

# Settings passed to OpenSCAD:
OPENSCAD_IMGSIZE=${OPENSCAD_IMGSIZE:-1920,1080}
OPENSCAD_COLORSCHEME=${OPENSCAD_COLORSCHEME:-Starnight}
OPENSCAD_CAMERA=${OPENSCAD_CAMERA:-}

files=()
png_options=(
  "--imgsize"
  "$OPENSCAD_IMGSIZE"
  "--colorscheme"
  "$OPENSCAD_COLORSCHEME"
)

if [ -n "$OPENSCAD_CAMERA" ]; then
  png_options+=("--camera" "$OPENSCAD_CAMERA")
fi

if [ $# -eq 0 ]; then
  readarray -t files < <(find . -type f -name '*.scad')
else
  files=("$@")
fi

for file in "${files[@]}"; do
  echo "==> STL: $file"
  openscad \
    -o "$(dirname "$file")/$(basename "$file" .scad).stl" \
    "$file"

  # This doesn't work yet.  OpenSCAD needs a running X server and I'm
  # not able to get xvfb working correctly during a nix-build.
  #
  # echo "==> PNG: $file"
  # openscad \
  #   "${png_options[@]}" \
  #   -o "$(dirname "$file")/$(basename "$file" .scad).png" \
  #   "$file"
done
