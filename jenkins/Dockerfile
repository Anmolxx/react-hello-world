FROM jenkins/jenkins:lts

USER root

# Install Docker CLI ONLY (lightweight)
RUN apt-get update && \
    apt-get install -y docker.io && \
    apt-get install -y git curl wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Add Jenkins user to docker group
RUN groupadd -f docker && usermod -aG docker jenkins

USER jenkins

# Install plugins
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt
