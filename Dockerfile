# Use a secure base image
FROM ubuntu:22.04

# Implement security best practices
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    gnupg \
    lsb-release && \
    rm -rf /var/lib/apt/lists/*

# Add Docker’s official GPG key
RUN mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Set up the Docker repository
RUN echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    docker-ce docker-ce-cli containerd.io && \
    rm -rf /var/lib/apt/lists/*

# Create a non-root user
RUN useradd -m -s /bin/bash nodeuser

# Switch to the non-root user
USER nodeuser

# Set the working directory
WORKDIR /home/nodeuser/app

# Copy the application files
COPY . .

# Set the entrypoint
ENTRYPOINT ["./entrypoint.sh"]
