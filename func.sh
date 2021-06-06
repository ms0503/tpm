#!/bin/bash

function getOSArch () {
    case "$(uname -p)" in
        x86_64)
            ARCH=64
            ;;
        i[3-6]86)
            ARCH=32
            ;;
        *)
            ARCH=unsupported
            ;;
    esac
    echo $ARCH
}

function getOSName () {
    if [ "$(uname)" == "Darwin" ]; then
        OS="mac"
    elif [ "$(expr substr $(uname) 1 10)" == "MINGW32_NT" ] || [ "$(expr substr $(uname) 1 10)" == "MINGW64_NT" ]; then
        OS="winlinux"
    elif [ -e /etc/debian_version ] || [ -e /etc/debian_release ]; then
        if [ -e /etc/lsb-release ]; then
            OS="ubuntu"
        else
            OS="debian"
        fi
    elif [ -e /etc/fedora-release ]; then
        OS="fedora"
    elif [ -e /etc/redhat-release ]; then
        if [ -e /etc/oracle-release ]; then
            OS="oracle"
        else
            OS="redhat"
        fi
    elif [ -e /etc/arch-release ]; then
        OS="arch"
    elif [ -e /etc/turbolinux-release ]; then
        OS="turbo"
    elif [ -e /etc/SuSE-release ]; then
        OS="suse"
    elif [ -e /etc/mandriva-release ]; then
        OS="mandriva"
    elif [ -e /etc/vine-release ]; then
        OS="vine"
    elif [ -e /etc/gentoo-release ]; then
        OS="gentoo"
    fi
    echo $OS
}
