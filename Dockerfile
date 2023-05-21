FROM jenkins/jenkins:lts

USER root

# Create the /etc/sudoers.d directory
RUN mkdir -p /etc/sudoers.d

# Add Jenkins user to have sudo privileges
RUN echo "jenkins ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/alex

# Install sudo for further use
RUN apt-get update && apt-get install -y sudo

USER jenkins