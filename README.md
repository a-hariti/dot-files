# Dot files

make sure you have `stow` installed then, run `./setup.sh` to link files to their appropriate location.

The home config files/folders try to mimic their target structrue to make it easier to `stow` them.

## Kanata as a service (macOS)

Run VirtualHID + Kanata via `launchd` (VirtualHID in `system`, Kanata in your login
session) so you do not need a terminal/tray app.

```bash
./kanata/kbd.sh setup
```

`setup` manages the sudoers rule automatically so login-started Kanata can run
`sudo -n` without interactive prompts.

Useful commands:

```bash
./kanata/kbd.sh start
./kanata/kbd.sh stop
./kanata/kbd.sh status
./kanata/kbd.sh logs
./kanata/kbd.sh restart
./kanata/kbd.sh connection
./kanata/kbd.sh config
./kanata/kbd.sh uninstall
```

This script is aliased as `kbd` and `kanata-manager` into `~/local/bin` by `./setup.sh`.

## VirtualHID setup

Kanata depends on [Karabiner-DriverKit-VirtualHIDDevice](https://github.com/pqrs-org/Karabiner-DriverKit-VirtualHIDDevice), so install it first.
