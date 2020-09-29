#!/usr/bin/env bash

set -eu
set -o pipefail

out=$1
ext=$2

files=()
mkdir -p "$out"

readarray -t files < <(find . -type f -name "*.$ext")

for file in "${files[@]}"; do
  install -m 0444 "$file" "$out"
done
