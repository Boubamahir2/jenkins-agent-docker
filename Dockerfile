

FROM jenkins/ssh-agent

# USER root
USER root

RUN apt-get update && \
  apt-get install -y openjdk-11-jdk


# # Allow Jenkins user to access /var/lib/apt/lists
RUN chown -R jenkins:jenkins /var/lib/apt/lists


# Install required packages for Docker installation
RUN apt-get update && \
  apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common

# Add Docker's official GPG key
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -

# Add Docker repository
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"

# Install Docker
RUN apt-get update && \
  apt-get install -y docker-ce docker-ce-cli containerd.io

# Allow Jenkins user to run Docker commands
RUN usermod -aG docker jenkins


USER jenkins   











# # Option 1: Use Docker-in-Docker (DinD) for Jenkins Agents
# # Start with the official Jenkins/ssh-agent image
# FROM jenkins/ssh-agent

# # Switch to the root user to install packages and modify permissions
# USER root

# # Install required packages for JDK installation
# RUN apt-get update && \
#   apt-get install -y openjdk-8-jdk

# # Allow Jenkins user to access /var/lib/apt/lists
# RUN chown -R jenkins:jenkins /var/lib/apt/lists

# # Install Docker (Docker-in-Docker support)
# RUN apt-get update && \
#   apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common && \
#   curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
#   add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" && \
#   apt-get update && \
#   apt-get install -y docker-ce docker-ce-cli containerd.io && \
#   usermod -aG docker jenkins

# # Switch back to the Jenkins user
# USER jenkins



# For Jenkins agents (Dockerized Slave Containers), you can use the official Jenkins agent image and extend it with Docker:
# Start with the official Jenkins agent image
# FROM jenkins/inbound-agent

# # Switch to the root user to install packages and modify permissions
# USER root

# # Install required packages for Docker installation
# RUN apt-get update && \
#   apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common && \
#   curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
#   add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" && \
#   apt-get update && \
#   apt-get install -y docker-ce docker-ce-cli containerd.io

# # Switch back to the Jenkins agent user
# USER jenkins



# Option 2: Docker-outside-of-Docker for Jenkins Agents
# If you prefer to avoid using DinD and want to share the Docker daemon from the host with Jenkins agents, you can use "Docker-outside-of-Docker" (DooD)
# Start with the official Jenkins agent image
# FROM jenkins/inbound-agent

# # Switch to the root user to install packages and modify permissions
# USER root

# # Install required packages for Docker installation
# RUN apt-get update && \
#   apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common && \
#   curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - && \
#   add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" && \
#   apt-get update && \
#   apt-get install -y docker-ce docker-ce-cli containerd.io

# # Switch back to the Jenkins agent user
# USER jenkins

# # Allow Jenkins user to access Docker socket on the host
# ARG docker_gid=999  # Default Docker group ID on the host
# USER root
# RUN groupadd -g ${docker_gid} docker_host && \
#   usermod -aG docker_host jenkins
# USER jenkins
