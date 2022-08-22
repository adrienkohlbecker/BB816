#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

FILE=${1:-}
if [ -z "$FILE" ]; then echo "Usage: $0 FILE"; fi

acme --format plain --outfile main.bin --color --report report.txt --strict-segments -v -Wtype-mismatch "$FILE"
python checksum.py main.bin
python bin2hex.py main.bin main.hex
