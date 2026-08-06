#!/bin/bash

COLOR_GREEN="#44e068"
COLOR_RED="#e04444"
SERVER_ICON=""

if ping -c 1 -W 1 darkpi &> /dev/null; then
  echo "{\"text\": \"<span color='${COLOR_GREEN}'>$SERVER_ICON</span>\", \"tooltip\": \"darkpi is Online\"}"
else
  echo "{\"text\": \"<span color='${COLOR_RED}'>$SERVER_ICON</span>\", \"tooltip\": \"darkpi is Offline\"}"
fi
