#!/bin/sh

MONTH=$(date +%m)
YEAR=$(date +%Y)

while true; do
  clear
  cal -m "$MONTH" "$YEAR"
  echo
  echo "← prev | → next | q quit"

  read -rsn1 key
  case "$key" in
    q) exit ;;
    h) key="[D" ;;
    l) key="[C" ;;
    $'\e')
      read -rsn2 key
      ;;
  esac

  case "$key" in
    "[D")
      MONTH=$((MONTH - 1))
      if [ "$MONTH" -eq 0 ]; then
        MONTH=12
        YEAR=$((YEAR - 1))
      fi
      ;;
    "[C")
      MONTH=$((MONTH + 1))
      if [ "$MONTH" -eq 13 ]; then
        MONTH=1
        YEAR=$((YEAR + 1))
      fi
      ;;
  esac
done
