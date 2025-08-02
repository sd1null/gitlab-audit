FROM python:3.11.3-bullseye

ARG TOKEN
ARG PASSWD
ENV TOKEN=${TOKEN}
ENV PASSWD=${PASSWD}

WORKDIR /usr/src/app

RUN apt-get update && apt-get -y install locales git jq openssh-client locales-all && pip install --no-cache-dir python-gitlab openpyxl GitPython pandas && \
    wget https://github.com/gitleaks/gitleaks/releases/download/v8.18.0/gitleaks_8.18.0_linux_x64.tar.gz && \
    tar xvzf gitleaks_8.18.0_linux_x64.tar.gz && \
    chmod +x gitleaks && \
    curl  --header "PRIVATE-TOKEN:${TOKEN}" https://gitlab.example.com/api/v4/projects/729/variables/ID_RSA | jq -r '.value' > id_rsa && \
    curl  --header "PRIVATE-TOKEN:${TOKEN}" https://gitlab.example.com/api/v4/projects/729/variables/KN_HOST | jq -r '.value' > known_hosts
    
COPY main.py gitleaks.toml exclusion.rules .
