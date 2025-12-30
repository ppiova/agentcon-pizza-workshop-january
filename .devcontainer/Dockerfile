# syntax=docker/dockerfile:1
FROM mcr.microsoft.com/devcontainers/python:3.10

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Install Azure Developer CLI (azd)
RUN curl -fsSL https://aka.ms/install-azd.sh | bash

# Install Bicep CLI (used by azd for provisioning)
RUN curl -fsSL https://downloads.bicep.azure.com/v0.39.26/bicep-linux-x64 -o /usr/local/bin/bicep \
    && chmod +x /usr/local/bin/bicep

# Install Node.js (using NodeSource for latest LTS)
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash && \
    apt-get install -y nodejs

# Verify installs
RUN az version && azd version && bicep --version && node --version && npm --version
