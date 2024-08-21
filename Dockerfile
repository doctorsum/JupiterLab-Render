# Use the latest Ubuntu image
FROM archlinux:latest

# Update and install required packages
RUN pacman -Sy --noconfirm && pacman -S --noconfirm \
    python \
    python-pip

# Set the working directory
WORKDIR /app

# Install JupyterLab
RUN pip3 install jupyterlab --break-system-packages

# Expose port 8080
EXPOSE 8080

# Start JupyterLab on port 8080 without authentication
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--port=8080", "--no-browser", "--allow-root", "--NotebookApp.token=''"]
