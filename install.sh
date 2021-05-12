#!/bin/bash
TPM_DIR=$(cd $(dirname $0); pwd)
if [ ! -f $TPM_DIR/func.sh ]; then
    printf "Error: func.sh file not found.\n"
    printf "Downloading...\n"
    wget https://raw.githubusercontent.com/ms0503/tpm/master/func.sh -O $TPM_DIR/func.sh
fi
. $TPM_DIR/func.sh

VERSION="1.0.0"
INSTDIR=""
OS=""

printf "tpm installer $VERSION\n"
printf "Copyright (C) 2021 Sora Tonami\n"
printf "\n"

if [ ${EUID:-$UID} != 0 ]; then
    printf "Installing Mode: $USER only\n"
    INSTDIR="/home/$USER/.local/bin"
else
    printf "Installing Mode: All users\n"
    INSTDIR="/usr/local/bin"
fi

printf "Are you sure installing? [Y/n] "
read -n 1
case "$REPLY" in
    [Nn]|[Nn][Oo])
        printf "Aborted.\n"
        exit 2
        ;;
    *)
        ;;
esac

printf "Phase 1: System Detection\n"
OS="$(getOSName)"

printf "Phase 2: Dependencies Installing\n"

printf "Phase 3: tpm Installing\n"
exit 0
