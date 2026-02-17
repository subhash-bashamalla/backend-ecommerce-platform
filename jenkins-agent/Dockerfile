# First Build

FROM debian:stable-slim AS build
USER root

RUN groupadd -g 989 docker || true \
    && usermod -aG docker jenkins

RUN apt-get update && apt-get install -y \
    wget \
    curl \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release

RUN wget https://github.com/aquasecurity/trivy/releases/download/v0.68.2/trivy_0.68.2_Linux-64bit.tar.gz \
    && tar zxvf trivy_0.68.2_Linux-64bit.tar.gz trivy \
    && mv trivy /usr/local/bin/trivy \
    && rm -rf trivy_0.68.2_Linux-64bit.tar.gz

RUN apt-get update && apt-get-install -y \
    install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | \
      gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    chmod a+r /etc/apt/keyrings/docker.gpg && \
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
      https://download.docker.com/linux/debian \
      $(. /etc/os-release && echo $VERSION_CODENAME) stable" | \
      tee /etc/apt/sources.list.d/docker.list > /dev/null


RUN wget https://releases.hashicorp.com/terraform/1.9.0/terraform_1.9.0_linux_amd64.zip \ 
    && unzip terraform_1.9.0_linux_amd64.zip \ 
    && mv terraform /usr/local/bin/terraform \ 
    && rm terraform_1.9.0_linux_amd64.zip


RUN python3 -m venv /opt/venv

COPY requirements.txt .
RUN /opt/venv/bin/pip install --no-cache-dir -r requirements.txt

# Final Image

FROM jenkins/inbound-agent:latest
USER root

RUN apt-get update && apt-get install -y \
    wget \
    curl \
    git \
    python3 \
    python3-pip \
    python3-venv \
    docker.io \
    docker-cli \
    docker-compose-plugin \
    ansible

COPY --from=build /usr/local/bin/trivy /usr/local/bin/trivy
COPY --from=build /usr/local/bin/terraform /usr/local/bin/terraform
COPY --from=build /opt/venv /opt/venv

ENV PATH="/opt/venv/bin:$PATH"
RUN ln -s /usr/bin/python3 /usr/bin/python || true

USER jenkins
WORKDIR /home/jenkins






