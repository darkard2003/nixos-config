#!/usr/bin/env python3
import glob
import json
import os
import sys
import time

def get_core_temps():
    # Scan hwmon for coretemp, k10temp, zenpower
    for h in glob.glob("/sys/class/hwmon/hwmon*"):
        name_file = os.path.join(h, "name")
        if os.path.exists(name_file):
            try:
                with open(name_file) as f:
                    hname = f.read().strip()
                if hname in ["coretemp", "k10temp", "zenpower"]:
                    cores = []
                    pkg_temp = None
                    for input_file in sorted(glob.glob(os.path.join(h, "temp*_input"))):
                        label_file = input_file.replace("_input", "_label")
                        label = os.path.basename(input_file)
                        if os.path.exists(label_file):
                            with open(label_file) as lf:
                                label = lf.read().strip()
                        with open(input_file) as tf:
                            temp = int(tf.read().strip()) // 1000
                        if "Package" in label or label in ["Tctl", "temp1_input"]:
                            if pkg_temp is None:
                                pkg_temp = temp
                        cores.append((label, temp))
                    if cores:
                        return hname, pkg_temp if pkg_temp is not None else cores[0][1], cores
            except Exception:
                pass

    # Fallback to thermal_zone
    zones = glob.glob("/sys/class/thermal/thermal_zone*")
    priority_types = ["x86_pkg_temp", "k10temp", "cpu-thermal", "cpu_thermal", "TCPU", "acpitz"]
    for z in zones:
        type_file = os.path.join(z, "type")
        temp_file = os.path.join(z, "temp")
        if os.path.exists(type_file) and os.path.exists(temp_file):
            try:
                with open(type_file) as f:
                    ztype = f.read().strip()
                with open(temp_file) as f:
                    ztemp = int(f.read().strip()) // 1000
                if ztype in priority_types:
                    return ztype, ztemp, [(ztype, ztemp)]
            except Exception:
                pass

    return "unknown", 0, []

def main():
    while True:
        hname, pkg_temp, cores = get_core_temps()
        
        if pkg_temp >= 80:
            icon, cls = "", "critical"
        elif pkg_temp >= 60:
            icon, cls = "", "warning"
        else:
            icon, cls = "", "normal"

        if cores:
            tooltip_lines = [f"CPU Temperature: {pkg_temp}°C ({hname})", "-" * 32]
            for label, temp in cores:
                tooltip_lines.append(f"{label:<16}: {temp}°C")
            tooltip = "\n".join(tooltip_lines)
        else:
            tooltip = f"CPU Temp: {pkg_temp}°C"

        out = {
            "text": f"{pkg_temp}°C {icon}",
            "tooltip": tooltip,
            "class": cls
        }
        print(json.dumps(out), flush=True)
        time.sleep(2)

if __name__ == "__main__":
    main()
