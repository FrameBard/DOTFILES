#!/bin/bash

# Прерываем скрипт при ошибках
set -e

echo "🚀 Начинаем настройку системы..."

# 1. Обновление и установка пакетов
echo "📦 Устанавливаем базовые пакеты..."
sudo apt update && sudo apt upgrade -y

# Обязательно добавляем zsh в список пакетов
PACKAGES=(
    "curl"
    "git"
    "zsh"
    "vim"
    "tmux"
)

sudo apt install -y "${PACKAGES[@]}"

# 2. Клонирование репозитория с конфигами
DOTFILES_DIR="$HOME/dotfiles"
# ЗАМЕНИ НА СВОЙ URL:
REPO_URL="https://github.com/ТВОЙ_GITHUB/dotfiles.git" 

if [ -d "$DOTFILES_DIR" ]; then
    echo "📂 Обновляем dotfiles..."
    cd "$DOTFILES_DIR"
    git pull origin main
else
    echo "📥 Клонируем dotfiles..."
    git clone "$REPO_URL" "$DOTFILES_DIR"
fi

# 3. Установка Oh My Zsh (в тихом режиме)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "🌈 Устанавливаем Oh My Zsh..."
    # Флаг --unattended ставит OMZ без изменения шелла по умолчанию и без запуска zsh,
    # что позволяет нашему скрипту продолжить работу.
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo "✅ Oh My Zsh уже установлен."
fi

# [ОПЦИОНАЛЬНО] Установка популярных плагинов (раскомментируй, если используешь)
echo "🔌 Устанавливаем плагины для Zsh..."
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions || true
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting || true

# 4. Создание симлинков (Делаем СТРОГО ПОСЛЕ установки Oh My Zsh)
echo "🔗 Создаем символические ссылки..."

create_symlink() {
    local source_file="$1"
    local target_file="$2"

    # Если файл существует и это не симлинк, делаем бэкап
    if [ -e "$target_file" ] && [ ! -L "$target_file" ]; then
        echo "Делаем бэкап $target_file -> ${target_file}.backup"
        mv "$target_file" "${target_file}.backup"
    fi
    ln -sf "$source_file" "$target_file"
    echo "Симлинк $target_file установлен."
}

# Линкуем наш .zshrc
create_symlink "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"

# 5. Смена оболочки по умолчанию на Zsh
# Проверяем, не является ли Zsh уже оболочкой по умолчанию
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "🔄 Меняем стандартную оболочку на Zsh..."
    # Для смены оболочки может потребоваться ввести пароль пользователя
    chsh -s $(which zsh)
fi

echo "✅ Настройка успешно завершена!"
echo "⚠️  ВАЖНО: Чтобы zsh стал оболочкой по умолчанию, закрой терминал и открой его заново (или перезайди в систему)."