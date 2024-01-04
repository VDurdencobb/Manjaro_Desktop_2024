#!/bin/bash


Update(){
    sudo pacman -Syu
}

Install(){
    sudo pacman -S zsh git gedit lsd bat dunst rofi xorg-server xorg-xinit xf86-video-qxl bspwm sxhkd dmenu nitrogen picom terminator chromium arandr polybar lxappearance
}

Fonts(){
    cp -r /fonts/* /usr/share/fonts
}

BSPWM_SXHKD(){
    mkdir ~/.config/bspwm
    mkdir ~/.config/sxhkd

    cp ./config/bspwmrc ~/.config/bspwm
    cp ./config/sxhkdrc ~/.config/sxhkd
}

NVIDIA(){
    sudo pacman -S nvidia nvidia-settings nvidia-utils lib32-nvidia-utils cuda opencl-nvidia  lib32-opencl-nvidia vdpauinfo clinfo
}