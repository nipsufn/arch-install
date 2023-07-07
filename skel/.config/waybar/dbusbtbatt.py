#!/usr/bin/env python3

import dbus
import json
from solaar import cli
from logitech_receiver import hidpp10 as _hidpp10
from logitech_receiver import hidpp20 as _hidpp20
from logitech_receiver import Device as Device

battery = [
    "  ",
    "  ",
    "  ",
    "  ",
    "  "
]

excluded_devices = [
    "BAT"
]


def logi(dev: Device, text: str, tooltip: str) -> tuple [str, str]:
    if dev:
        dev.ping()
        if dev.kind == 'mouse':
            logibattery = _hidpp20.get_battery(dev, None)
            if logibattery is None:
                logibattery = _hidpp10.get_battery(dev)
                level, _, _ = logibattery
            else:
                try:
                    level = logibattery[1]
                except TypeError:
                    return ""

            #text += " "
            #if level <= 10:
            #    text += battery[0]
            #elif level <= 30:
            #    text += battery[1]
            #elif level <= 60:
            #    text += battery[2]
            #elif level <= 80:
            #    text += battery[3]
            #else:
            #    text += battery[4]
            tooltip += dev.codename + " (Solaar): " + str(level) + "%\n"
    return text, tooltip

def main():
    #for bluetooth
    #TODO: check if experimental is uncommented in /etc/bluetooth/main.conf 
    bus = dbus.SystemBus()
    proxy_object = bus.get_object("org.freedesktop.UPower","/org/freedesktop/UPower")
    manager = dbus.Interface(proxy_object, "org.freedesktop.UPower")
    paths = manager.EnumerateDevices()
    json_out = {}
    json_out['text'] = ""
    json_out['tooltip'] = ""
    for path in paths:

        battery_proxy = bus.get_object("org.freedesktop.UPower", path)
        battery_proxy_interface = dbus.Interface(battery_proxy, "org.freedesktop.DBus.Properties")
        status = battery_proxy_interface.GetAll("org.freedesktop.UPower" + ".Device")

        if status['Model'] != '' and status['Model'] not in excluded_devices:
            # https://upower.freedesktop.org/docs/Device.html#Device:Type
            # https://www.nerdfonts.com/cheat-sheet
            dbus_icon = status['Type']
            if dbus_icon == 5:
                json_out['text'] += "󰍽 "
            elif dbus_icon == 6:
                json_out['text'] += " "
            elif dbus_icon == 17:
                json_out['text'] += "󰋋 "
            else:
                json_out['text'] += "? "
            
            dbus_battery = status['Percentage']
            if dbus_battery <= 10:
                json_out['text'] += battery[0]
            elif dbus_battery <= 30:
                json_out['text'] += battery[1]
            elif dbus_battery <= 60:
                json_out['text'] += battery[2]
            elif dbus_battery <= 80:
                json_out['text'] += battery[3]
            else:
                json_out['text'] += battery[4]
            json_out['tooltip'] += f"{status['Model']}: {status['Percentage']}%\n"

    #logitech mouse
    recv = list(cli._receivers())
    recv += list(cli._receivers_and_devices())
    dev = next(cli._find_device(recv, "1"), None)
    json_out["text"], json_out["tooltip"] = logi(dev, json_out["text"], json_out["tooltip"])
    json_out['text'] = json_out['text'].strip() + " "
    json_out['tooltip'] = json_out['tooltip'].strip()
    print(json.dumps(json_out))

if __name__ == "__main__":
    main()
