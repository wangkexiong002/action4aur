FROM archlinux:latest

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh
RUN pacman -Syu base-devel git dos2unix --noconfirm --overwrite '*'
RUN useradd -m build && usermod -aG wheel build && echo '%wheel ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
RUN su - build -c 'git clone https://aur.archlinux.org/yay.git; cd yay; makepkg -si --noconfirm; cd ..; rm -rf yay'

COPY makepkg.conf  /home/build/.config/pacman/makepkg.conf

ENTRYPOINT ["/entrypoint.sh"]

