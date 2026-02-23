#!/usr/bin/env bash

set -euo pipefail

# VirtualHID daemon (system domain)
VHID_LABEL="com.local.karabiner-vhid-daemon"
VHID_PLIST_PATH="/Library/LaunchDaemons/${VHID_LABEL}.plist"
VHID_BIN_DEFAULT="/Library/Application Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice/Applications/Karabiner-VirtualHIDDevice-Daemon.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Daemon"

# Kanata daemon (user GUI domain; started via sudo -n)
KANATA_LABEL="com.local.kanata"
KANATA_PLIST_PATH="${HOME}/Library/LaunchAgents/${KANATA_LABEL}.plist"
KANATA_BIN_DEFAULT="$(command -v kanata || true)"
KANATA_LOG_DEFAULT="/tmp/${KANATA_LABEL}.log"
KANATA_PORT_DEFAULT="5371"
KANATA_CFG_DEFAULT_HOME="${HOME}/.config/kanata/kanata.kbd"
KANATA_SUDOERS_PATH="/private/etc/sudoers.d/kanata"
KANATA_BIN_VALUE=""
KANATA_CFG_VALUE=""
KANATA_LOG_VALUE="$KANATA_LOG_DEFAULT"
KANATA_PORT_VALUE="$KANATA_PORT_DEFAULT"
VHID_BIN_VALUE="$VHID_BIN_DEFAULT"

usage() {
  cat <<EOF
Usage: ./kanata/daemon.sh [options] <command>

Commands:
  setup             Set up + start services (also installs/updates sudoers rule)
  start             Start both jobs
  stop              Stop both jobs
  restart           Restart both jobs
  status            Show status for both jobs
  logs              Follow merged kanata log
  uninstall         Stop + remove services (also removes sudoers rule if present)

EOF

  local default_kanata_bin default_cfg
  default_kanata_bin='$(command -v kanata)'
  default_cfg='$HOME/.config/kanata/kanata.kbd'

  cat <<EOF
Options (with defaults):
  --kanata-bin PATH Path to kanata binary
                    default: $default_kanata_bin
  --kanata-cfg PATH Path to kanata.kbd
                    default: $default_cfg
  --kanata-log PATH kanata merged stdout/stderr log path
                    default: $KANATA_LOG_DEFAULT
  --port N          Kanata TCP port (1-65535)
                    default: $KANATA_PORT_DEFAULT
  --vhid-bin PATH   Path to VirtualHID daemon binary
                    default: $VHID_BIN_DEFAULT
  -h, --help        Show this help
EOF
}

gui_uid() {
  if [[ -n "${SUDO_USER:-}" ]]; then
    id -u "${SUDO_USER}"
  else
    id -u
  fi
}

require_sudo_session() {
  if sudo -n true >/dev/null 2>&1; then
    return
  fi
  echo "Administrator password is required for VirtualHID operations."
  sudo -v
}

detect_cfg() {
  if [[ -n "${KANATA_CFG_VALUE:-}" ]]; then
    printf '%s\n' "$KANATA_CFG_VALUE"
    return
  fi
  printf '%s\n' "$KANATA_CFG_DEFAULT_HOME"
}

render_vhid_plist() {
  local vhid_bin="$1"

  cat <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>${VHID_LABEL}</string>

  <key>ProgramArguments</key>
  <array>
    <string>${vhid_bin}</string>
  </array>

  <key>RunAtLoad</key>
  <true/>

  <key>KeepAlive</key>
  <dict>
    <key>SuccessfulExit</key>
    <false/>
  </dict>

  <key>Umask</key>
  <integer>18</integer>
</dict>
</plist>
EOF
}

render_kanata_plist() {
  local kanata_bin="$1"
  local kanata_cfg="$2"
  local log_file="$3"
  local port="$4"

  cat <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>${KANATA_LABEL}</string>

  <key>ProgramArguments</key>
  <array>
    <string>/usr/bin/sudo</string>
    <string>-n</string>
    <string>${kanata_bin}</string>
    <string>--no-wait</string>
    <string>--nodelay</string>
    <string>--cfg</string>
    <string>${kanata_cfg}</string>
    <string>--port</string>
    <string>${port}</string>
  </array>

  <key>RunAtLoad</key>
  <true/>

  <key>KeepAlive</key>
  <true/>

  <key>LimitLoadToSessionType</key>
  <string>Aqua</string>

  <key>ProcessType</key>
  <string>Interactive</string>

  <key>ThrottleInterval</key>
  <integer>10</integer>

  <key>Umask</key>
  <integer>18</integer>

  <key>EnvironmentVariables</key>
  <dict>
    <key>PATH</key>
    <string>/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin</string>
  </dict>

  <key>StandardOutPath</key>
  <string>${log_file}</string>
  <key>StandardErrorPath</key>
  <string>${log_file}</string>
</dict>
</plist>
EOF
}

bootout_vhid() {
  sudo launchctl bootout system/"${VHID_LABEL}" >/dev/null 2>&1 || true
}

bootout_kanata() {
  local uid
  uid="$(gui_uid)"
  launchctl bootout "gui/${uid}/${KANATA_LABEL}" >/dev/null 2>&1 || true
}

start_vhid() {
  sudo launchctl enable system/"${VHID_LABEL}" >/dev/null 2>&1 || true
  sudo launchctl bootstrap system "${VHID_PLIST_PATH}" >/dev/null 2>&1 || true
  sudo launchctl kickstart -k system/"${VHID_LABEL}"
}

start_kanata() {
  local uid
  uid="$(gui_uid)"
  launchctl enable "gui/${uid}/${KANATA_LABEL}" >/dev/null 2>&1 || true
  launchctl bootstrap "gui/${uid}" "${KANATA_PLIST_PATH}" >/dev/null 2>&1 || true
  launchctl kickstart -k "gui/${uid}/${KANATA_LABEL}"
}

install_daemon() {
  local kanata_bin
  kanata_bin="$(resolve_kanata_bin)"
  local kanata_cfg kanata_log kanata_port
  kanata_cfg="$(detect_cfg)"
  kanata_log="$(resolve_kanata_log)"
  kanata_port="$(resolve_kanata_port)"
  local vhid_bin
  vhid_bin="$(resolve_vhid_bin)"

  validate_kanata_bin "$kanata_bin"
  validate_kanata_cfg "$kanata_cfg"
  validate_kanata_log "$kanata_log"
  validate_kanata_port "$kanata_port"
  validate_vhid_bin "$vhid_bin"

  require_sudo_session
  ensure_sudoers_installed "$kanata_bin"

  mkdir -p "${HOME}/Library/LaunchAgents"

  local tmp_vhid tmp_kanata
  tmp_vhid="$(mktemp /tmp/${VHID_LABEL}.XXXXXX)"
  tmp_kanata="$(mktemp /tmp/${KANATA_LABEL}.XXXXXX)"
  trap '[[ -n "${tmp_vhid:-}" ]] && rm -f "$tmp_vhid"; [[ -n "${tmp_kanata:-}" ]] && rm -f "$tmp_kanata"' EXIT

  render_vhid_plist "$vhid_bin" >"$tmp_vhid"
  render_kanata_plist "$kanata_bin" "$kanata_cfg" "$kanata_log" "$kanata_port" >"$tmp_kanata"

  sudo install -o root -g wheel -m 644 "$tmp_vhid" "$VHID_PLIST_PATH"
  install -m 644 "$tmp_kanata" "$KANATA_PLIST_PATH"
  sudo rm -f "/tmp/${VHID_LABEL}.out.log" "/tmp/${VHID_LABEL}.err.log" >/dev/null 2>&1 || true

  # Clean up old system-domain kanata job from previous setup, if present.
  sudo launchctl bootout system/"${KANATA_LABEL}" >/dev/null 2>&1 || true
  sudo rm -f "/Library/LaunchDaemons/${KANATA_LABEL}.plist" >/dev/null 2>&1 || true

  bootout_kanata
  bootout_vhid
  start_vhid
  start_kanata

  echo "Installed and started:"
  echo "  system/${VHID_LABEL}"
  echo "  gui/$(gui_uid)/${KANATA_LABEL}"
  echo "Config: $kanata_cfg"
  echo "Log: $kanata_log"

  rm -f "$tmp_vhid" "$tmp_kanata"
  trap - EXIT
}

start_daemon() {
  if [[ ! -f "$VHID_PLIST_PATH" || ! -f "$KANATA_PLIST_PATH" ]]; then
    echo "Missing plist(s). Run install first." >&2
    exit 1
  fi
  require_sudo_session
  echo "Starting VirtualHID + Kanata (this may take a while)..."
  start_vhid
  start_kanata
  echo "Started:"
  echo "  system/${VHID_LABEL}"
  echo "  gui/$(gui_uid)/${KANATA_LABEL}"
}

stop_daemon() {
  require_sudo_session
  bootout_kanata
  bootout_vhid
  echo "Stopped VirtualHID + Kanata."
}

restart_daemon() {
  if [[ ! -f "$VHID_PLIST_PATH" || ! -f "$KANATA_PLIST_PATH" ]]; then
    echo "Missing plist(s). Run install first." >&2
    exit 1
  fi
  require_sudo_session
  echo "Restarting VirtualHID + Kanata (this may take a while)..."
  bootout_kanata
  bootout_vhid
  start_vhid
  start_kanata
  echo "Restarted:"
  echo "  system/${VHID_LABEL}"
  echo "  gui/$(gui_uid)/${KANATA_LABEL}"
}

status_daemon() {
  local uid
  uid="$(gui_uid)"
  echo "== system/${VHID_LABEL} =="
  if sudo -n true >/dev/null 2>&1; then
    sudo launchctl print system/"${VHID_LABEL}" 2>&1 || true
  else
    echo "(sudo required for system-domain status)"
  fi
  echo
  echo "== gui/${uid}/${KANATA_LABEL} =="
  launchctl print "gui/${uid}/${KANATA_LABEL}" 2>&1 || true
}

logs_daemon() {
  local kanata_log
  kanata_log="$(resolve_kanata_log)"
  validate_kanata_log "$kanata_log"
  mkdir -p "$(dirname "$kanata_log")"
  touch "$kanata_log"
  echo "Following ${kanata_log} (Ctrl+C to stop)"
  tail -n 120 -f "$kanata_log"
}

uninstall_daemon() {
  require_sudo_session
  stop_daemon
  sudo launchctl disable system/"${VHID_LABEL}" >/dev/null 2>&1 || true
  local uid
  uid="$(gui_uid)"
  launchctl disable "gui/${uid}/${KANATA_LABEL}" >/dev/null 2>&1 || true
  sudo rm -f "$VHID_PLIST_PATH"
  rm -f "$KANATA_PLIST_PATH"
  remove_sudoers_if_present
  echo "Removed:"
  echo "  $VHID_PLIST_PATH"
  echo "  $KANATA_PLIST_PATH"
}

sudoers_line() {
  local kanata_bin="${1:-$(resolve_kanata_bin)}"
  validate_kanata_bin "$kanata_bin"
  local hash
  hash="$(shasum -a 256 "$kanata_bin" | awk '{print $1}')"
  printf '%s ALL=(root) NOPASSWD:SETENV: sha256:%s %s\n' "$(id -un)" "$hash" "$kanata_bin"
}

install_sudoers() {
  local kanata_bin="${1:-${KANATA_BIN_VALUE:-$KANATA_BIN_DEFAULT}}"
  local tmp
  tmp="$(mktemp /tmp/kanata.sudoers.XXXXXX)"
  trap '[[ -n "${tmp:-}" ]] && rm -f "$tmp"' EXIT
  sudoers_line "$kanata_bin" >"$tmp"
  sudo install -o root -g wheel -m 440 "$tmp" "$KANATA_SUDOERS_PATH"
  sudo visudo -cf "$KANATA_SUDOERS_PATH"
  echo "Installed $KANATA_SUDOERS_PATH"
  echo "Re-run after kanata upgrades (hash changes)."
  rm -f "$tmp"
  trap - EXIT
}

uninstall_sudoers() {
  sudo rm -f "$KANATA_SUDOERS_PATH"
  echo "Removed $KANATA_SUDOERS_PATH"
}

ensure_sudoers_installed() {
  local kanata_bin="$1"
  local expected current
  expected="$(sudoers_line "$kanata_bin")"
  if sudo test -f "$KANATA_SUDOERS_PATH"; then
    current="$(sudo cat "$KANATA_SUDOERS_PATH" 2>/dev/null || true)"
    if [[ "$current" == "$expected" ]]; then
      echo "Sudoers rule is already up to date: $KANATA_SUDOERS_PATH"
      return
    fi
  fi
  install_sudoers "$kanata_bin"
}

remove_sudoers_if_present() {
  if sudo test -f "$KANATA_SUDOERS_PATH"; then
    uninstall_sudoers
  else
    echo "Sudoers rule already absent: $KANATA_SUDOERS_PATH"
  fi
}

die() {
  echo "error: $*" >&2
  exit 1
}

resolve_kanata_bin() {
  printf '%s\n' "${KANATA_BIN_VALUE:-$KANATA_BIN_DEFAULT}"
}

resolve_vhid_bin() {
  printf '%s\n' "${VHID_BIN_VALUE}"
}

resolve_kanata_log() {
  printf '%s\n' "${KANATA_LOG_VALUE}"
}

resolve_kanata_port() {
  printf '%s\n' "${KANATA_PORT_VALUE}"
}

validate_kanata_bin() {
  local kanata_bin="$1"
  [[ -n "$kanata_bin" ]] || die "kanata binary not found. Install kanata or pass --kanata-bin PATH."
  [[ -x "$kanata_bin" ]] || die "kanata binary not executable: ${kanata_bin}"
}

validate_vhid_bin() {
  local vhid_bin="$1"
  [[ -n "$vhid_bin" ]] || die "VirtualHID daemon binary path is empty. Pass --vhid-bin PATH."
  [[ -x "$vhid_bin" ]] || die "VirtualHID daemon binary not executable: ${vhid_bin}"
}

validate_kanata_cfg() {
  local kanata_cfg="$1"
  [[ -n "$kanata_cfg" ]] || die "kanata config path is empty. Pass --kanata-cfg PATH."
  [[ -f "$kanata_cfg" ]] || die "kanata config not found: ${kanata_cfg}"
}

validate_kanata_log() {
  local kanata_log="$1"
  [[ -n "$kanata_log" ]] || die "kanata log path is empty. Pass --kanata-log PATH."
}

validate_kanata_port() {
  local kanata_port="$1"
  [[ "$kanata_port" =~ ^[0-9]+$ ]] || die "kanata port must be numeric: ${kanata_port}"
  (( kanata_port >= 1 && kanata_port <= 65535 )) || die "kanata port out of range (1-65535): ${kanata_port}"
}

cmd=""
while [[ $# -gt 0 ]]; do
  case "$1" in
  --kanata-bin)
    [[ $# -ge 2 ]] || { echo "missing value for --kanata-bin" >&2; exit 1; }
    [[ -n "$2" ]] || die "--kanata-bin cannot be empty"
    KANATA_BIN_VALUE="$2"
    shift 2
    ;;
  --kanata-cfg)
    [[ $# -ge 2 ]] || { echo "missing value for --kanata-cfg" >&2; exit 1; }
    [[ -n "$2" ]] || die "--kanata-cfg cannot be empty"
    KANATA_CFG_VALUE="$2"
    shift 2
    ;;
  --kanata-log)
    [[ $# -ge 2 ]] || { echo "missing value for --kanata-log" >&2; exit 1; }
    [[ -n "$2" ]] || die "--kanata-log cannot be empty"
    KANATA_LOG_VALUE="$2"
    shift 2
    ;;
  --port)
    [[ $# -ge 2 ]] || { echo "missing value for --port" >&2; exit 1; }
    [[ -n "$2" ]] || die "--port cannot be empty"
    KANATA_PORT_VALUE="$2"
    shift 2
    ;;
  --vhid-bin)
    [[ $# -ge 2 ]] || { echo "missing value for --vhid-bin" >&2; exit 1; }
    [[ -n "$2" ]] || die "--vhid-bin cannot be empty"
    VHID_BIN_VALUE="$2"
    shift 2
    ;;
  -h | --help)
    usage
    exit 0
    ;;
  --)
    shift
    while [[ $# -gt 0 ]]; do
      if [[ -z "$cmd" ]]; then
        cmd="$1"
        shift
        continue
      fi
      echo "unexpected arguments: $*" >&2
      usage
      exit 1
    done
    break
    ;;
  -*)
    echo "unknown option: $1" >&2
    usage
    exit 1
    ;;
  *)
    if [[ -z "$cmd" ]]; then
      cmd="$1"
      shift
      continue
    fi
    echo "unexpected arguments: $*" >&2
    usage
    exit 1
    ;;
  esac
done

if [[ -z "$cmd" ]]; then
  usage
  exit 1
fi

case "$cmd" in
setup)
  install_daemon
  ;;
start)
  start_daemon
  ;;
stop)
  stop_daemon
  ;;
restart)
  restart_daemon
  ;;
status)
  status_daemon
  ;;
logs)
  logs_daemon
  ;;
uninstall)
  uninstall_daemon
  ;;
install-sudoers)
  install_sudoers
  ;;
uninstall-sudoers)
  uninstall_sudoers
  ;;
show-sudoers)
  sudoers_line
  ;;
*)
  usage
  exit 1
  ;;
esac
