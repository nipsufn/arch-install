#!/usr/bin/env python3
"""Module printing wireless device battery status"""

import dbus
import json
import sys

batteryDischarge = [
    "󰁺  ",
    "󰁻  ",
    "󰁼  ",
    "󰁽  ",
    "󰁾  ",
    "󰁿  ",
    "󰂀  ",
    "󰂁  ",
    "󰂂  ",
    "󰁹  "
]
batteryCharge = [
    "󰢜  ",
    "󰂆  ",
    "󰂇  ",
    "󰂈  ",
    "󰢝  ",
    "󰂉  ",
    "󰢞  ",
    "󰂊  ",
    "󰂋  ",
    "󰂅  "
]

icons = {
    5: "󰍽 ",    # mouse
    6: " ",     # keyboard
    12: "󰊴 ",   # gaming input
    17: "󰋋 ",   # headset
    19: "󰋋 ",   # headphones
}

level_to_percent = {3: 10, 4: 5, 6: 50, 7: 75, 8: 100}

excluded_devices = [
    "BAT"
]

def battery_glyph(percentage: float, charging: bool) -> str:
    """Convert percentage to battery glyph"""
    idx = min(max(int(percentage) // 10, 0), 9)
    return (batteryCharge if charging else batteryDischarge)[idx]


def dbus_hid(text: str, tooltip: str) -> tuple[str, str]:
    """Generate battery status for wireless peripherals via UPower"""
    bus = dbus.SystemBus()
    manager = dbus.Interface(
        bus.get_object("org.freedesktop.UPower", "/org/freedesktop/UPower"),
        "org.freedesktop.UPower",
    )
    for path in manager.EnumerateDevices():
        try:
            props = dbus.Interface(
                bus.get_object("org.freedesktop.UPower", path),
                "org.freedesktop.DBus.Properties",
            )
            status = props.GetAll("org.freedesktop.UPower.Device")

            # skip laptop battery, line power, absent devices
            if status["PowerSupply"] or not status["IsPresent"]:
                continue
            if status["Model"] == "" or status["Model"] in excluded_devices:
                continue

            percentage = float(status["Percentage"])
            level = int(status.get("BatteryLevel", 1))
            if percentage == 0 and level in level_to_percent:
                percentage = level_to_percent[level]

            charging = int(status["State"]) in (1, 4)
            text += icons.get(int(status["Type"]), "? ")
            text += battery_glyph(percentage, charging)
            tooltip += f"{status['Model']}: {percentage:.0f}%\n"
        except dbus.DBusException:
            continue
    return text, tooltip

def main():
    """main"""

    json_out = {}
    json_out['text'] = ""
    json_out['tooltip'] = ""

    json_out["text"], json_out["tooltip"] \
        = dbus_hid(json_out["text"], json_out["tooltip"])

    json_out['text'] = json_out['text'].strip() + " "
    json_out['tooltip'] = json_out['tooltip'].strip()
    print(json.dumps(json_out))

if __name__ == "__main__":
    try:
        main()
    # pylint: disable-next=broad-exception-caught
    except Exception as e:  # pylint: disable=broad-exception-caught
        print(f"hid battery script failed: {e}", file=sys.stderr)
        print('{"text": " ", "tooltip": "HID device battery script fails!"}')
