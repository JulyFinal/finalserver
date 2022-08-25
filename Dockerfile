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
  && pacman -Sc --noconfirm \
  && rm -f /etc/ssh/ssh_*_key \
  && ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key \
  && ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key \
  && ssh-keygen -q -N "" -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key \
  && /usr/bin/ssh-keygen -A \
  && sed -i "s/#*UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config \
  && sed -i "s/#*UsePAM.*/UsePAM no/g" /etc/ssh/sshd_config \
  && sed -i "s/#*PermitRootLogin.*/PermitRootLogin yes/g" /etc/ssh/sshd_config

RUN useradd -d /home/final -m -s /bin/zsh final \
  && echo "final:4188" | chpasswd \
  && echo 'final ALL=(ALL) ALL' >> /etc/sudoers

CMD ["/usr/bin/sshd", "-D"]

EXPOSE 22

USER final

# RUN git clone https://aur.archlinux.org/yay ~/yay && cd ~/yay && echo "4188" | makepkg -si && rm -rf ~/yay
RUN git clone https://github.com/JulyFinal/.config.git ~/.config \
  && git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 \
  && git clone https://github.com/JulyFinal/nvim_custom.git ~/.config/nvim/lua/custom \
  && echo "source ~/.config/zshrc"

RUN pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple

