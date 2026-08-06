#!/usr/bin/env python

import sys
import os
import json
import subprocess
from pathlib import Path
from datetime import datetime, timedelta
from sys import stdout
import time

CACHE_FILE = Path(os.path.expanduser("~/.cache/waybar-weather.json"))
URL_TEMPLATE = "https://wttr.in/{}?format=j1"
DEFAULT_PIN_CODE="741234"

SUN_COLOR = "#FFD700"  # Gold
MOON_COLOR = "#D8BFD8"  # Thistle (Pale Purple)
CLOUD_COLOR = "#AAAAAA"  # Grey
RAIN_COLOR = "#6495ED"  # Cornflower Blue
SNOW_COLOR = "#FFFFFF"  # White
THUNDER_COLOR = "#E0E000"  # Yellow-ish


def get_icon_and_color(weather_code, is_night=False):
    code = int(weather_code)

    match code:
        case 113:
            return ("", MOON_COLOR) if is_night else ("󰖙", SUN_COLOR)
        case 116:
            return "󰖕", "#CCCCCC"
        case 119:
            return "󰖐", "#AAAAAA"
        case 122:
            return "󰖐", "#AAAAAA"
        case 143 | 248 | 260:
            return "󰖑", "#AAAAAA"
        case 176 | 293 | 296 | 353:
            return "󰖖", "#6495ED"
        case 302 | 308 | 356 | 359:
            return "󰖖", "#6495ED"
        case 200 | 386 | 389:
            return "󰖓", "#9370DB"
        case 323 | 326 | 368:
            return "󰖘", "#FFFFFF"
        case 332 | 335 | 338 | 371:
            return "󰼶", "#FFFFFF"
        case 227 | 230:
            return "󰖝", "#FFFFFF"
        case _:
            return "󰖙", "#FFFFFF"


def get_weather_data(city):
    url = URL_TEMPLATE.format(city)
    now = datetime.now()

    try:
        if CACHE_FILE.exists():
            cache_mod_time = datetime.fromtimestamp(CACHE_FILE.stat().st_mtime)
            if cache_mod_time > now - timedelta(minutes=5):
                with open(CACHE_FILE, "r") as f:
                    return json.load(f), "cached_live", cache_mod_time
    except (json.JSONDecodeError, IOError):
        try:
            os.remove(CACHE_FILE)
        except OSError:
            pass

    try:
        result = subprocess.run(
            ["curl", "-s", "--max-time", "10", url],
            capture_output=True,
            text=True,
            check=True,
        )
        live_data = json.loads(result.stdout)

        try:
            CACHE_FILE.parent.mkdir(parents=True, exist_ok=True)
            with open(CACHE_FILE, "w") as f:
                json.dump(live_data, f)
        except (IOError, OSError):
            pass

        return live_data, "live", now

    except (
        subprocess.CalledProcessError,
        subprocess.TimeoutExpired,
        json.JSONDecodeError,
    ):
        if CACHE_FILE.exists():
            try:
                cache_mod_time = datetime.fromtimestamp(CACHE_FILE.stat().st_mtime)
                with open(CACHE_FILE, "r") as f:
                    return json.load(f), "cached", cache_mod_time
            except (json.JSONDecodeError, IOError):
                pass

    return None, "error", None


def get_area_name(weather_data):
    areas = weather_data["nearest_area"]
    if len(areas) == 0:
        return "Unknown"
    cities = areas[0]["areaName"]
    if len(cities) == 0:
        return "Unknown"
    city_name = cities[0]["value"]
    return city_name


def get_weather_description(condition):
    weather_desc = condition["weatherDesc"]
    if len(weather_desc) == 0:
        return "Unknown"
    return weather_desc[0]["value"]


def get_sunrise_and_sunset(weather_data):
    weather = weather_data["weather"]

    if len(weather) == 0:
        return None, None

    weather = weather[0]
    astronomy = weather["astronomy"]

    if len(astronomy) == 0:
        return None, None

    astronomy = astronomy[0]
    sunrise = astronomy["sunrise"]
    sunset = astronomy["sunset"]

    return sunrise, sunset


def is_night(sunrise, sunset):
    if sunrise is None or sunset is None:
        return False

    time_format = "%I:%M %p"

    now = datetime.now()
    sunrise = datetime.strptime(sunrise, time_format).replace(
        year=now.year, month=now.month, day=now.day
    )
    sunset = datetime.strptime(sunset, time_format).replace(
        year=now.year, month=now.month, day=now.day
    )

    if now > sunrise and now < sunset:
        return False

    return True


def output_weather_data(weather_data, last_updated, cached=False):
    try:
        if len(weather_data["current_condition"]) == 0:
            raise KeyError("No current_condition")

        current_condition = weather_data["current_condition"][0]
        # nearest_area = weather_data["nearest_area"][0]

        sunrise, sunset = get_sunrise_and_sunset(weather_data)
        city_name = get_area_name(weather_data)
        weather_code = current_condition["weatherCode"]
        description = get_weather_description(current_condition)
        temperature = current_condition["temp_C"]
        feels_like = current_condition["FeelsLikeC"]
        wind_speed = current_condition["windspeedKmph"]
        humidity = current_condition["humidity"]

        night = is_night(sunrise, sunset)

        icon, icon_color = get_icon_and_color(weather_code, is_night=night)

        if cached:
            last_updated_formatted = last_updated.strftime("%a %b %d, %I:%M %p")
            last_updated_text = f"\n\nLast updated:\n<small><i>{last_updated_formatted} (cached)</i></small>"
        else:
            last_updated_formatted = last_updated.strftime("%a %b %d, %I:%M %p")
            last_updated_text = (
                f"\n\nLast updated:\n<small><i>{last_updated_formatted}</i></small>"
            )

        city_header = f"<b>Weather for {city_name}</b>\n\n"

        tooltip_parts = [
            city_header,
            f"Feels Like: {feels_like}°C",
            f"{description}",
            f"Wind: {wind_speed} km/h",
            f"Humidity: {humidity}%",
            last_updated_text,
        ]

        tooltip = "\n".join(tooltip_parts)

        text = f"<span foreground='{icon_color}'>{icon}</span>  {temperature}°C"

        stdout.write(json.dumps({"text": text, "tooltip": tooltip}))
        stdout.write("\n")
        stdout.flush()

    except (KeyError, IndexError, TypeError) as e:
        if CACHE_FILE.exists():
            try:
                os.remove(CACHE_FILE)
            except OSError:
                pass

        stdout.write(
            json.dumps({"text": "Weather N/A", "tooltip": f"Error parsing data: {e}"})
        )
        stdout.write("\n")
        stdout.flush()


def main():
    # city = sys.argv[1] if len(sys.argv) > 1 else ""
    # get the city from env or use default
    city = os.environ.get("WAYBAR_WEATHER_CITY", DEFAULT_PIN_CODE)
    

    while True:
        weather_data, status, last_updated = get_weather_data(city)

        if status == "error":
            stdout.write(
                json.dumps(
                    {"text": "Weather N/A", "tooltip": "Network error, no cache"}
                )
            )
            stdout.write("\n")
            stdout.flush()
            time.sleep(5)
            continue

        if status == "cached":
            output_weather_data(weather_data, last_updated, cached=True)
            time.sleep(5)
            continue

        if status == "cached_live":
            output_weather_data(weather_data, last_updated, cached=True)
            if last_updated is None:
                time_to_wait = 600
            else:
                time_to_wait = 600 - int(last_updated.timestamp()) % 600
            time.sleep(time_to_wait + 1)
            continue

        output_weather_data(weather_data, last_updated)
        time.sleep(600)


if __name__ == "__main__":
    main()
