#!/usr/bin/env python3

import subprocess
import json
from sys import stdout
from time import sleep

# --- Configuration ---
COLOR_GREEN = "#44e068"
COLOR_RED = "#e04444"
SERVER_ICON = ""
HOST_TO_PING = "darkpi"
# ---------------------

def check_server_status(host):
    """
    Pings a host and returns its status.
    Returns True if the host is reachable, False otherwise.
    """
    # -c 1: send 1 packet
    # -W 1: wait 1 second for a response
    try:
        # Use subprocess.run to execute the ping command.
        # stdout=subprocess.PIPE and stderr=subprocess.PIPE suppress output.
        # check=False prevents an exception if ping fails (non-zero return code).
        result = subprocess.run(
            ['ping', '-c', '1', '-W', '1', host],
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            check=False
        )
        # ping returns 0 on success (online), non-zero otherwise (offline)
        return result.returncode == 0
    except FileNotFoundError:
        # Handle case where the 'ping' command might not be found
        return False

def generate_output(is_online):
    """
    Generates the JSON string output based on the server's online status.
    """
    if is_online:
        color = COLOR_GREEN
        tooltip = f"{HOST_TO_PING} is Online"
    else:
        color = COLOR_RED
        tooltip = f"{HOST_TO_PING} is Offline"

    # The 'text' value is a Pango markup span for colored output
    text_content = f"<span color='{color}'>{SERVER_ICON}</span>"

    # Create the dictionary that will be converted to JSON
    output_dict = {
        "text": text_content,
        "tooltip": tooltip
    }

    stdout.write(json.dumps(output_dict))
    stdout.write("\n")
    stdout.flush()



if __name__ == "__main__":
    while True:
        is_online = check_server_status(HOST_TO_PING)
        generate_output(is_online)
        if is_online:
            sleep_time = 30
        else:
            sleep_time = 5
        sleep(sleep_time)
