#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "This script needs to be run as root!"
  exit
fi

script_dir="$(dirname "$(realpath $0)")"

update_system(){
    sudo pacman -Syu

    sudo pacman -S git base-devel
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
}

install_chrome(){
    sudo pacman -S google-chrome
}

install_vscode(){
    yay -S visual-studio-code-bin
}

install_zed(){
    yay -S zed-git
}

install_librewolf(){
    yay -S librewolf
}

clean_up(){
    sudo pacman -Scc
    trash ${script_dir}
}

main(){
    update_system
    install_chrome 
    install_vscode 
    install_zed
    install_librewolf 
    clean_up
}

main

