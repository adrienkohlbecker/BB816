#!/usr/bin/env bash
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
IFS=$'\n\t'
set -euo pipefail

TEENSY=$(ioreg -r -c IOUSBHostDevice -l -n "USB Serial" | grep -w 'IOCalloutDevice' | awk -F'=' '{print $2}' | sed -E -e 's/[ "]//g' | head -1)
echo "Uploading main.hex to $TEENSY..."
cat main.hex > "$TEENSY"
