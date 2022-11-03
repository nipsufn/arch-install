#!/usr/bin/env python3

import dbus
import json
from solaar import cli
from logitech_receiver import hidpp10 as _hidpp10
from logitech_receiver import hidpp20 as _hidpp20

def main():
    #for bluetooth
    bus = dbus.SystemBus()
    proxy_object = bus.get_object("org.bluez","/")
    manager = dbus.Interface(proxy_object, "org.freedesktop.DBus.ObjectManager")
    objects = manager.GetManagedObjects()
    battery = [
        "  ",
        "  ",
        "  ",
        "  ",
        "  "
    ]
    json_out = {}
    json_out['text'] = ""
    json_out['tooltip'] = ""
    for object in objects.items():
        if 'org.bluez.Device1' in object[1] and 'org.bluez.Battery1' in object[1]:
            dbus_icon = object[1]['org.bluez.Device1']['Icon']
            if dbus_icon == "input-mouse":
                json_out['text'] += " "
            if dbus_icon == "input-keyboard":
                json_out['text'] += " "
            elif dbus_icon == "audio-headset":
                json_out['text'] += " "
            else:
                json_out['text'] += " "
            
            dbus_battery = object[1]['org.bluez.Battery1']['Percentage']
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
            json_out['tooltip'] += f"{object[1]['org.bluez.Device1']['Name']}: {json.dumps(object[1]['org.bluez.Battery1']['Percentage'])}%\n"

    #logitech mouse
    recv = list(cli._receivers())
    recv += list(cli._receivers_and_devices())
    dev = next(cli._find_device(recv, "1"), None)
    if dev:
        dev.ping()
        if dev.kind == 'mouse':
            json_out['text'] += " "
            logibattery = _hidpp20.get_battery(dev, None)
            if logibattery is None:
                logibattery = _hidpp10.get_battery(dev)
                level, _, _ = logibattery
            else:
                level = logibattery[1]
            if level <= 10:
                json_out['text'] += battery[0]
            elif level <= 30:
                json_out['text'] += battery[1]
            elif level <= 60:
                json_out['text'] += battery[2]
            elif level <= 80:
                json_out['text'] += battery[3]
            else:
                json_out['text'] += battery[4]
            json_out['tooltip'] += dev.codename + ": " + str(level) + "%"
    json_out['text'] = json_out['text'].strip()
    print(json.dumps(json_out))

if __name__ == "__main__":
    main()
