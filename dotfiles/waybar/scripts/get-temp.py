#!/usr/bin/env python3
import glob
import json
import os
import signal
import sys
import time

def sigterm_handler(signum, frame):
    sys.exit(0)

signal.signal(signal.SIGTERM, sigterm_handler)

def read_sysfs(path):
    """Safely read and strip content from a sysfs file."""
    try:
        with open(path, "r") as f:
            return f.read().strip()
    except OSError:
        return None

def read_temp_input(path):
    """Read millidegree temperature and convert to integer Celsius."""
    raw = read_sysfs(path)
    if raw is None:
        return None
    try:
        temp = int(raw) // 1000
        # Filter out hardware disconnect or fault values
        if -50 <= temp <= 150:
            return temp
    except ValueError:
        pass
    return None

def get_sensors():
    hname = "unknown"
    pkg_temp = None
    cores = []
    gpu_sensors = []
    ram_sensors = []
    storage_sensors = []
    fans = []

    # Single-pass scan over hwmon
    hwmon_dirs = sorted(glob.glob("/sys/class/hwmon/hwmon*"))
    for h in hwmon_dirs:
        name = read_sysfs(os.path.join(h, "name"))
        if not name:
            continue

        # 1. CPU Sensors (coretemp, k10temp, zenpower)
        if name in ["coretemp", "k10temp", "zenpower"] and not cores:
            hname = name
            p_temp = None
            found_cores = []
            for input_file in sorted(glob.glob(os.path.join(h, "temp*_input"))):
                temp = read_temp_input(input_file)
                if temp is None:
                    continue
                label_file = input_file.replace("_input", "_label")
                label = read_sysfs(label_file) or os.path.basename(input_file)
                if "Package" in label or label in ["Tctl", "temp1_input"]:
                    if p_temp is None:
                        p_temp = temp
                found_cores.append((label, temp))

            if found_cores:
                cores = found_cores
                pkg_temp = p_temp if p_temp is not None else cores[0][1]

        # 2. GPU Sensors (amdgpu, nouveau, nvidia, i915, xe)
        elif name in ["amdgpu", "nouveau", "nvidia", "i915", "xe"]:
            tag = "GPU"
            if name == "amdgpu":
                tag = "GPU (AMD)"
            elif name in ["nvidia", "nouveau"]:
                tag = "GPU (NVIDIA)"
            elif name in ["i915", "xe"]:
                tag = "GPU (Intel)"

            for input_file in sorted(glob.glob(os.path.join(h, "temp*_input"))):
                temp = read_temp_input(input_file)
                if temp is not None:
                    gpu_sensors.append((tag, f"{temp}°C"))
                    break

        # 3. RAM (SPD modules)
        elif name.startswith("spd"):
            for input_file in sorted(glob.glob(os.path.join(h, "temp*_input"))):
                temp = read_temp_input(input_file)
                if temp is not None:
                    slot_id = len(ram_sensors) + 1
                    ram_sensors.append((f"RAM {slot_id}", f"{temp}°C"))
                    break

        # 4. Storage (NVMe)
        elif name == "nvme":
            for input_file in sorted(glob.glob(os.path.join(h, "temp*_input"))):
                label_file = input_file.replace("_input", "_label")
                lbl = read_sysfs(label_file) or ""
                if lbl in ["Composite", "Sensor 1", ""] or "Composite" in lbl:
                    temp = read_temp_input(input_file)
                    if temp is not None:
                        nvme_id = len(storage_sensors) + 1
                        label_name = "NVMe SSD" if nvme_id == 1 else f"NVMe SSD {nvme_id}"
                        storage_sensors.append((label_name, f"{temp}°C"))
                        break

        # 5. Cooling Fans
        h_fans = []
        for fan_input in sorted(glob.glob(os.path.join(h, "fan*_input"))):
            raw = read_sysfs(fan_input)
            if raw is not None:
                try:
                    rpm = int(raw)
                    fan_idx = os.path.basename(fan_input).replace("_input", "").replace("fan", "")
                    h_fans.append((f"Fan {fan_idx}", f"{rpm} RPM"))
                except ValueError:
                    pass

        if name == "thinkpad" and len(h_fans) == 2 and h_fans[0][1] == h_fans[1][1]:
            fans.append(("Fan", h_fans[0][1]))
        elif len(h_fans) == 1:
            fans.append(("Fan", h_fans[0][1]))
        else:
            fans.extend(h_fans)

    # Fallback to thermal_zone if no CPU hwmon was found (respecting priority)
    if not cores:
        priority_types = ["x86_pkg_temp", "k10temp", "cpu-thermal", "cpu_thermal", "TCPU", "acpitz"]
        candidates = []
        for z in glob.glob("/sys/class/thermal/thermal_zone*"):
            ztype = read_sysfs(os.path.join(z, "type"))
            temp = read_temp_input(os.path.join(z, "temp"))
            if ztype and temp is not None and ztype in priority_types:
                candidates.append((priority_types.index(ztype), ztype, temp))
        if candidates:
            candidates.sort(key=lambda c: c[0])
            _, best_type, best_temp = candidates[0]
            hname = best_type
            pkg_temp = best_temp
            cores = [(best_type, best_temp)]

    if pkg_temp is None:
        pkg_temp = 0

    aux_sensors = gpu_sensors + storage_sensors + ram_sensors
    return hname, pkg_temp, cores, aux_sensors, fans

def main():
    while True:
        hname, pkg_temp, cores, aux_sensors, fans = get_sensors()

        if pkg_temp >= 80:
            icon, cls = "", "critical"
        elif pkg_temp >= 60:
            icon, cls = "", "warning"
        else:
            icon, cls = "", "normal"

        tooltip_lines = [f"CPU Temperature: {pkg_temp}°C ({hname})", "-" * 32]

        if len(cores) > 1:
            for label, temp in cores:
                tooltip_lines.append(f"{label:<16}: {temp}°C")
        elif cores:
            cpu_label = "CPU (Tctl)" if hname == "k10temp" else "CPU"
            tooltip_lines.append(f"{cpu_label:<16}: {pkg_temp}°C")

        # Auxiliary sensors (GPU, NVMe, RAM) shown consistently across all architectures
        if aux_sensors:
            if len(cores) > 1:
                tooltip_lines.append("-" * 32)
            for label, val in aux_sensors:
                tooltip_lines.append(f"{label:<16}: {val}")

        if fans:
            tooltip_lines.append("-" * 32)
            for label, val in fans:
                tooltip_lines.append(f"{label:<16}: {val}")

        out = {
            "text": f"{pkg_temp}°C {icon}",
            "tooltip": "\n".join(tooltip_lines),
            "class": cls
        }
        try:
            print(json.dumps(out), flush=True)
            time.sleep(2)
        except (BrokenPipeError, KeyboardInterrupt):
            sys.exit(0)

if __name__ == "__main__":
    main()
