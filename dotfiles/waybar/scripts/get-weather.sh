#!/bin/bash

# --- CONFIGURATION ---
CITY="${1:-}"
CACHE_FILE="$HOME/.cache/waybar-weather.json"
# ---------------------

URL="https://wttr.in/${CITY}?format=j1"

# Create the cache directory if it doesn't exist
mkdir -p "$(dirname "$CACHE_FILE")"

# Try to fetch new weather data with a 5-second timeout
LIVE_WEATHER_DATA=$(curl -s --max-time 5 "$URL")

# Check if curl was successful and returned valid JSON
if [ $? -eq 0 ] && echo "$LIVE_WEATHER_DATA" | jq -e . > /dev/null 2>&1; then
    # Success: Save to cache and use live data
    echo "$LIVE_WEATHER_DATA" > "$CACHE_FILE"
    WEATHER_DATA="$LIVE_WEATHER_DATA"
else
    # Failure: Try to use cache
    if [ -f "$CACHE_FILE" ]; then
        WEATHER_DATA=$(cat "$CACHE_FILE")
    else
        # No network and no cache
        echo '{"text": "Weather N/A", "tooltip": "Network error, no cache"}'
        exit 1
    fi
fi

# --- Parse data (from live or cache) ---
if [ -z "$WEATHER_DATA" ]; then
    echo '{"text": "Weather N/A", "tooltip": "Failed to read data"}'
    exit 1
fi

CITY_NAME=$(echo "$WEATHER_DATA" | jq -r '.nearest_area[0].areaName[0].value')
WEATHER_CODE=$(echo "$WEATHER_DATA" | jq -r '.current_condition[0].weatherCode')
DESCRIPTION=$(echo "$WEATHER_DATA" | jq -r '.current_condition[0].weatherDesc[0].value')
TEMPERATURE=$(echo "$WEATHER_DATA" | jq -r '.current_condition[0].temp_C')
FEELS_LIKE=$(echo "$WEATHER_DATA" | jq -r '.current_condition[0].FeelsLikeC')
WIND_SPEED=$(echo "$WEATHER_DATA" | jq -r '.current_condition[0].windspeedKmph')
HUMIDITY=$(echo "$WEATHER_DATA" | jq -r '.current_condition[0].humidity')

# --- Get Last Updated Time ---
LAST_UPDATED_TEXT=""
if [ -f "$CACHE_FILE" ]; then
    LAST_UPDATED=$(date -r "$CACHE_FILE" +"%a %b %d, %I:%M %p")
    # Format with Pango for small and italic text
    LAST_UPDATED_TEXT="\n\nLast updated:\n<small><i>$LAST_UPDATED</i></small>"
fi

# Build the tooltip
CITY_HEADER=""
if [ -n "$CITY_NAME" ]; then
    # Format with Pango for bold text
    CITY_HEADER="<b>Weather for $CITY_NAME</b>\n\n"
fi

TOOLTIP_TEXT=$(printf "%sFeels Like: %s°C\n%s\nWind: %s km/h\nHumidity: %s%%%s" \
    "$CITY_HEADER" "$FEELS_LIKE" "$DESCRIPTION" "$WIND_SPEED" "$HUMIDITY" "$LAST_UPDATED_TEXT")


# --- Icon Mapping (using weatherCode) ---
ICON="✨"
ICON_COLOR="#FFFFFF" # Default color (white)
case "$WEATHER_CODE" in
    "113") ICON="☀️"; ICON_COLOR="#FFD700";; # Sunny
    "116") ICON="🌤️"; ICON_COLOR="#CCCCCC";; # Partly Cloudy
    "119") ICON="☁️"; ICON_COLOR="#AAAAAA";; # Cloudy
    "122") ICON="🌥️"; ICON_COLOR="#AAAAAA";; # Overcast
    "143"|"248"|"260") ICON="🌫️"; ICON_COLOR="#AAAAAA";; # Mist / Fog
    "176"|"293"|"296"|"353") ICON="🌦️"; ICON_COLOR="#6495ED";; # Light Rain
    "302"|"308"|"356"|"359") ICON="🌧️"; ICON_COLOR="#6495ED";; # Heavy Rain
    "200"|"386"|"389") ICON="🌩️"; ICON_COLOR="#9370DB";; # Thunderstorm
    "323"|"326"|"368") ICON="🌨️"; ICON_COLOR="#FFFFFF";; # Light Snow
    "332"|"335"|"338"|"371") ICON="❄️"; ICON_COLOR="#FFFFFF";; # Heavy Snow
    "227"|"230") ICON="🌬️"; ICON_COLOR="#FFFFFF";; # Blizzard
    *) ICON="✨"; ICON_COLOR="#FFFFFF";;
esac

# --- Format for Waybar ---
# Build the Pango-formatted text with the colored icon
PANGO_TEXT="<span foreground='${ICON_COLOR}'>${ICON}</span> ${TEMPERATURE}°C"

# Use jq to safely build the JSON output.
jq -n \
  --arg text "$PANGO_TEXT" \
  --arg tooltip "$TOOLTIP_TEXT" \
  '{"text": $text, "tooltip": $tooltip}'
