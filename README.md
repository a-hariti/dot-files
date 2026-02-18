# Dot files

make sure you have `stow` installed then, run `./setup.sh` to link files to their appropriate location.

The home config files/folders try to mimic their target structrue to make it easier to `stow` them.

## Kanata as a service (macOS)

Run VirtualHID + Kanata via `launchd` (VirtualHID in `system`, Kanata in your login
session) so you do not need a terminal/tray app.

```bash
./kanata/daemon.sh install-sudoers
./kanata/daemon.sh install
```

The `install-sudoers` step is required so login-started Kanata can run `sudo -n`
without a password prompt. Re-run it after `kanata` upgrades.

Useful commands:

```bash
./kanata/daemon.sh start
./kanata/daemon.sh stop
./kanata/daemon.sh status
./kanata/daemon.sh logs
./kanata/daemon.sh restart
./kanata/daemon.sh uninstall
./kanata/daemon.sh uninstall-sudoers
```

This script is aliased as `kbd` and `kanata-manager` into `~/local/bin` by `./setup.sh`.

## VirtualHID setup

Kanata depends on [Karabiner-DriverKit-VirtualHIDDevice](https://github.com/pqrs-org/Karabiner-DriverKit-VirtualHIDDevice), so install it first.
