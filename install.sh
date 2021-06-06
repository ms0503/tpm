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
    INSTDIR="/home/$USER/.local/tpm"
else
    printf "Installing Mode: All users\n"
    INSTDIR="/usr/local/tpm"
fi

printf "Are you sure installing? [Y/n] "
read -n 1
case "$REPLY" in
    [Nn]|[Nn][Oo])
        printf "Aborted.\n"
        exit 1
        ;;
    *)
        ;;
esac

printf "Phase 1: System Detection\n"
printf "OS : "
OS="$(getOSName)"
printf "%s\n" "$OS"
printf "Bit : "
ARCH="$(getOSArch)"
printf "%s\n" "$ARCH"
ls "$INSTDIR" > /dev/null 2>&1
if [ $? = 2 ]; then
    printf "Target directory is not found.\n"
    printf "Creating...\n"
    mkdir "$INSTDIR" > /dev/null 2>&1
    if [ $? = 1 ]; then
        printf "Target directory cannot be creating.\n"
        printf "Permission denied.\n"
        printf "Aborted.\n"
        exit 2
    fi
fi

printf "Phase 2: Installing Dependencies\n"
printf "Node.js : "
if [ -z "$(which node)" ]; then
    printf "not installed\n"
    printf "Installing...\n"
    case "$OS" in
        debian)
        ubuntu)
            if [ ${EUID:-$UID} != 0 ]; then
                curl -fsSL https://deb.nodesource.com/setup_current.x | sudo -E bash -
                sudo apt install nodejs build-essential -y
            else
                curl -fsSL https://deb.nodesource.com/setup_current.x | bash -
                apt install nodejs build-essential -y
            fi
            ;;
        fedora)
        redhat)
            if [ ${EUID:-$UID} != 0 ]; then
                curl -fsSL https://rpm.nodesource.com/setup_current.x | sudo bash -
                sudo yum groupinstall 'Development Tools'
            else
                curl -fsSL https://rpm.nodesource.com/setup_current.x | bash -
                yum groupinstall 'Development Tools'
            fi
            ;;
        arch)
            [ ${EUID:-$UID} != 0 ] && sudo pacman -Syy nodejs npm || pacman -Syy nodejs npm
            ;;
        mac)
            curl "https://nodejs.org/dist/latest/node-${VERSION:-$(wget -qO- https://nodejs.org/dist/latest/ | sed -nE 's|.*>node-(.*)\.pkg</a>.*|\1|p')}.pkg" > "$HOME/Downloads/node-latest.pkg" && sudo installer -store -pkg "$HOME/Downloads/node-latest.pkg" -target "/"
            ;;
        *)
            printf "Your system is not supported.\n"
            printf "Aborted.\n"
            exit 3
            ;;
    esac
else
    printf "%s\n" "$(node -v)"
fi
printf "Installing build dependencies...\n"
npm install

printf "Phase 3: Installing tpm\n"
printf "Building tpm...\n"
npm run build
printf "Copying files into %s ...\n" "$INSTDIR"
if [ ${EUID:-$UID} != 0 ]; then
    sudo cp -r ./bin $INSTDIR
    sudo cp -r ./lang $INSTDIR
else
    cp -r ./bin $INSTDIR
    cp -r ./lang $INSTDIR
fi
export PATH="$PATH:$INSTDIR/bin"
if [ -f $HOME/.bash_profile ]; then
    printf 'export PATH="$PATH:%s/bin"' "$INSTDIR" >> $HOME/.bash_profile
elif [ -f $HOME/.profile ]; then
    printf 'export PATH="$PATH:%s/bin"' "$INSTDIR" >> $HOME/.profile
elif [ -f $HOME/.bashrc ]; then
    printf 'export PATH="$PATH:%s/bin"' "$INSTDIR" >> $HOME/.bashrc
elif [ -f $HOME/.zshrc ]; then
    printf 'export PATH="$PATH:%s/bin"' "$INSTDIR" >> $HOME/.zshrc
else
    printf 'export PATH="$PATH:%s/bin"' "$INSTDIR" > $HOME/.bash_profile
fi
printf "Install Complete!\n"
exit 0
