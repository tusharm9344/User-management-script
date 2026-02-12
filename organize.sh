#!/usr/bin/env bash
set -Eeuo pipefail

checkroot(){
if [[ "$EUID" -ne 0 ]]; then
echo "Run in sudo"
exit 1
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="$SCRIPT_DIR/log"
FILE_DIR="$LOG_DIR/report.log"
mkdir -p "$LOG_DIR"

report(){
echo "$(date '+%F %T')|$1" >> "$FILE_DIR"
}

on_error(){
local line="$1"
local cmd="$2"
echo "Error on line $1 (cmd $2)" >> "$FILE_DIR"
exit 1
}

trap 'on_error "$LINENO" "$BASH_COMMAND" ' ERR

user_check(){
id "$1" &>/dev/null
}

group_check(){
getent group "$1" &>/dev/null
}

usage(){
echo "add $0 <user> <group>"
echo "delete $0 <user>"
echo "lock $0 <user>"
echo "unlock $0 <user>"
echo "info $0 <user>"
exit 1
}

checkroot
[[ $# -lt 2 ]] && usage

ACTION="$1"
USER="$2"
GROUP="${3:-}"

case "$ACTION" in 
add)

[[ -z "$GROUP" ]] && usage
if user_check "$USER" ; then
echo "USER EXISTS : $USER" >> "$FILE_DIR"
exit 0
fi

if ! group_check "$GROUP" ; then
groupadd "$GROUP"
echo "GROUP ADDED: $GROUP" >> "$FILE_DIR"
fi

useradd -m -s /bin/bash -g "$GROUP" "$USER"
echo "USER ADDED : $USER ($GROUP)"  >> "$FILE_DIR"
;;

delete)
userdel -r "$USER" &>/dev/null
report "USER DELETED : $USER"
;;

lock)
passwd -l "$USER" &>/dev/null
report "USER LOCKED : $USER"
;;

unlock)
passwd -u "$USER" &>/dev/null
report "USER UNLOCKED : $USER"
;;

info)
id "USER"
report "INFO CHECKED:$USER"
;;

*)
usage
;;

esac
