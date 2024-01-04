#!/bin/bash

local_dir=$(pwd)
local_user=$(echo $USER)

Error(){
    echo "[-] Ha ocurrido un error"
    exit 2
}

Update(){
    sudo pacman -Syu
}

Install(){
    sudo pacman -S zsh gedit lsd bat dunst rofi xorg-server xorg-xinit xf86-video-qxl bspwm sxhkd dmenu nitrogen picom terminator chromium arandr polybar lxappearance
    pamac install python-pywal
}

Fonts(){
    cp -r $local_dir/fonts/* /usr/share/fonts
}

BSPWM_SXHKD(){
    mkdir ~/.config/bspwm
    mkdir ~/.config/sxhkd

    cp $local_dir/config/bspwmrc ~/.config/bspwm
    cp $local_dir/config/sxhkdrc ~/.config/sxhkd
}

NVIDIA(){
    echo -e "¿Quiere isntalar los controladores de Nvidia? \n"
    echo "[1]: SI"
    echo -e "[2]: INO \n"

    read n
        case $n in
        1) 
            sudo pacman -S nvidia nvidia-settings nvidia-utils lib32-nvidia-utils cuda opencl-nvidia  lib32-opencl-nvidia vdpauinfo clinfo
        ;;
        2) 
            echo "[-] Continuando con la instalación."
            sleep 1
        ;;
        *) 
            Error
        ;;
    esac
}

Repos(){
    while IFS= read -r line
    do
        git clone --depth=1  "$line"
    done < $local_dir/repositorios/repo.txt
    mv $local_dir/repositorios/zsh* /usr/share/zsh/plugins
}

Polybar(){
    cd $local_dir/repositorios/polybar-themes
    chmod +x setup.sh
    echo "Se procede a instalar Polybar."
    sleep 1
    echo "Por favor, a continuación seleccione la opción [1]"
    sleep 1
    bash setup.sh
    mv $local_dir/config/material ~/.config/polybar
    bash ~/.config/polybar/material/scripts/pywal.sh /usr/share/backgrounds/manjaro-wallpapers-18.0/light-stripe-maia.jpg
}

ZSH(){
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    chsh -s $(which zsh)
    chmood --shell /usr/bin/zsh root
    mv $local_dir/config/zsh/user/.zshrc ~/.zshrc
    sudo su
    chsh -s /usr/bin/zsh
    chmood --shell /usr/bin/zsh root
    mv $local_dir/config/zsh/su/.zshrc ~/.zshrc
    su $local_user
    cd ~
        mv .zsh_history .zsh_history_bad
        strings .zsh_history_bad > .zsh_history
        fc -R .zsh_history
        rm ~/.zsh_history_bad
}

MAIN(){
    echo -e "[-] Actualizando dispositivo \n"
    sleep 1
    Update
    echo -e "[-] Instalando dependencias \n"
    sleep 1
    Install
    echo -e "[-] Cargando fuentes \n"
    sleep 1
    Fonts
    NVIDIA
    echo -e "[-] Generando repositorios \n"
    sleep 1
    Repos
    echo -e "[-] Instalando ZSH \n"
    sleep 1
    ZSH
    echo -e "[-] Instalando BSPWN y SXHKD \n"
    sleep 1
    BSPWM_SXHKD
    echo -e "[-] Instalando Polybar \n"
    sleep 1
    Polybar
}

MAIN