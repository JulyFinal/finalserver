FROM archlinux:latest

LABEL maintainer="final" email="julyfinal@outlook.com"

ENV LANG en_US.UTF-8
# ENV LANGUAGE=en_US.UTF-8
# ENV LC_ALL=en_US.UTF-8

RUN sed -ie 's/^#\(en_US\.UTF-8 UTF-8\)/\1/' /etc/locale.gen \
  && locale-gen

RUN echo "Server = https://mirrors.ustc.edu.cn/archlinux/$repo/os/$arch\n\
Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch\n\
Server = https://mirror.archlinux.tw/ArchLinux/$repo/os/$arch\n\
Server = https://mirror.aktkn.sg/archlinux/$repo/os/$arch\n\
Server = https://mirrors.cat.net/archlinux/$repo/os/$arch" >> /etc/pacman.d/mirrorlist

RUN pacman -Syu --noconfirm --needed base-devel zsh git lazygit vim neovim go sudo python python-pip bat fd bottom lsd ripgrep sd zoxide openssh \
  && pacman -Sc --noconfirm

RUN sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/g' /etc/sudoers

# create user
RUN useradd -m -G wheel -s /bin/zsh final \
  && echo "final:4188" | chpasswd

RUN echo "AllowUsers final" >> /etc/ssh/sshd_config

USER final

# RUN git clone https://aur.archlinux.org/yay ~/yay && cd ~/yay && echo "4188" | makepkg -si && rm -rf ~/yay
RUN git clone https://github.com/JulyFinal/.config.git ~/.config
RUN git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 
RUN git clone https://github.com/JulyFinal/nvim_custom.git ~/.config/nvim/lua/custom

RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

EXPOSE 22

CMD [ ! -f /etc/ssh/ssh_host_rsa_key ] && ssh-keygen -A; /bin/sshd -D
