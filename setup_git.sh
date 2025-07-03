#!/bin/bash

### ЦВЕТА ##
ESC=$(printf '\033') RESET="${ESC}[0m" MAGENTA="${ESC}[35m" RED="${ESC}[31m" GREEN="${ESC}[32m"

### Функции цветного вывода ##
magentaprint() { printf "${MAGENTA}%s${RESET}\n" "$1"; }
errorprint() { printf "${RED}%s${RESET}\n" "$1"; }
greenprint() { printf "${GREEN}%s${RESET}\n" "$1"; }


# Функция для установки Git на Ubuntu
install_git_ubuntu() {
    echo; magentaprint "Installing Git on Ubuntu..."
    sudo apt update
    sudo apt install -y git
}

# Функция для установки Git на AlmaLinux
install_git_almalinux() {
    echo; magentaprint "Installing Git on AlmaLinux..."
    sudo dnf update -y
    sudo dnf install -y git
}

# Функция для установки глобальных настроек Git
configure_git() {
    echo; magentaprint "Configuring Git with provided username and email..."
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
        errorprint "Unsupported Linux distribution. Only Ubuntu and AlmaLinux are supported."
        return 1
    fi
}

# Основная функция
main() {
    # Проверка наличия аргументов
    if [ $# -ne 2 ]; then
        echo; magentaprint "Usage: $0 <git-username> <git-email>"; echo
        return 1
    fi

    install_git
    configure_git "$1" "$2"
    echo; greenprint "Git installation and configuration complete."
    
    echo; magentaprint "Current Git configuration:"
    # Вывод текущих настроек Git
    git config --list
    echo; magentaprint "Git version:"
    # Вывод версии Git
    git --version
}

# Запуск основной функции
main "$@"
