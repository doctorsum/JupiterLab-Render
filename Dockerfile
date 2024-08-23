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
RUN pacman -Sy --noconfirm wget base-devel

# تحميل ملف chrome-remote-desktop
RUN wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb -O /tmp/chrome-remote-desktop.deb

# تثبيت ملف .deb باستخدام ar و tar
RUN pacman -Sy --noconfirm ar tar && \
    mkdir /tmp/chrome-remote-desktop && \
    cd /tmp/chrome-remote-desktop && \
    ar x /tmp/chrome-remote-desktop.deb && \
    tar -xvf data.tar.xz && \
    pacman -U --noconfirm *.pkg.tar.zst

# تنظيف الملفات المؤقتة
RUN rm -rf /tmp/chrome-remote-desktop /tmp/chrome-remote-desktop.deb

# إعداد البيئة أو أي خطوات إضافية
# Set the working directory
WORKDIR /app

# Install JupyterLab
RUN pip3 install jupyterlab --break-system-packages

# Expose port 8080
EXPOSE 8080

# Start JupyterLab on port 8080 without authentication
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8080", "--no-browser", "--allow-root", "--NotebookApp.token=''"]
