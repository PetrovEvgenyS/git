#!/bin/bash

# Функция для установки Git на Ubuntu
install_git_ubuntu() {
    sudo apt update
    sudo apt install -y git
}

# Функция для установки Git на AlmaLinux
install_git_almalinux() {
    sudo dnf update -y
    sudo dnf install -y git
}

# Функция для установки глобальных настроек Git
configure_git() {
    local username="$1"
    local email="$2"

    #задать свой логин (имя)
    git config --global user.name "$username"
    #задать свою почту
    git config --global user.email "$email"
    #включение подсветки Git в терминале
    git config --global color.ui auto
    #задать текстовый редактор по умолчанию
    git config --global core.editor vim
}

# Функция для определения дистрибутива и установки Git
install_git() {
    if [ -f /etc/lsb-release ]; then
        # Ubuntu
        install_git_ubuntu
    elif [ -f /etc/almalinux-release ]; then
        # AlmaLinux
        install_git_almalinux
    else
        printf "Unsupported Linux distribution.\n" >&2
        return 1
    fi
}

# Основная функция
main() {
    if [ $# -ne 2 ]; then
        printf "Usage: $0 <git-username> <git-email>\n" >&2
        return 1
    fi

    install_git
    configure_git "$1" "$2"
    printf "Git installation and configuration complete.\n"
    # Вывести заданные изменения в конфигурации
    git config --list
    git --version
}

# Запуск основной функции
main "$@"
