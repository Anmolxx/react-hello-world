# Use stable LTS
FROM jenkins/jenkins:lts

USER root

# Install essential tools ONLY
RUN apt-get update && \
    apt-get install -y \
    git \
    curl \
    wget \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Add Jenkins user to docker group (for socket access)
RUN groupadd -f docker && usermod -aG docker jenkins

USER jenkins

# Copy plugin list (BEST PRACTICE)
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt

# Install plugins safely
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt