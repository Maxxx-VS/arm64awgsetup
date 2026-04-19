#!/bin/sh
# Скачиваем то чё надо
sudo apt update
sudo apt update && sudo apt install -y \
  build-essential \
  git \
  pkg-config \
  resolvconf \
  iproute2 \
  systemd \
  bash\
  golang-go\
  make\

# Сборка amneziawg-go
git clone https://github.com/amnezia-vpn/amneziawg-go /tmp/amneziawg-go
cd /tmp/amneziawg-go
go build -v -o amneziawg-go
# Переносим бинарник в системную папку
sudo cp amneziawg-go /usr/local/bin/

# Сборка awg-quick
git clone https://github.com/amnezia-vpn/amneziawg-tools.git /tmp/amnezia-tools
cd /tmp/amneziawg-tools/src
make
sudo make install

# Убираем сбивающие dns настройки домашних сетей
sudo sed -i '/nameserver 192.168.0.1/d' /etc/resolv.conf
sudo sed -i '/nameserver 192.168.1.1/d' /etc/resolv.conf
sudo sed -i '/nameserver 10.10.4.1/d' /etc/resolv.conf

echo "А теперь нужно добавить свой конфигурационный файл в /etc/amnezia/amneziawg/<ИМЯ>.conf\nЗапускать командой: 'sudo WG_QUICK_USERSPACE_IMPLEMENTATION=amnezia-go awg-quick up <ИМЯ>'"
