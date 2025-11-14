ARG PYTHON_VERSION=3.11
FROM python:${PYTHON_VERSION}-slim

ARG ANSIBLE_VERSION

# System dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    openssh-client \
    sshpass \
    rsync \
    && rm -rf /var/lib/apt/lists/*

# Copy appropriate requirements file based on version
COPY requirements-${ANSIBLE_VERSION}.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt && \
    rm /tmp/requirements.txt

# Copy and install Ansible collections
COPY requirements-collections.yml /tmp/
RUN ansible-galaxy collection install -r /tmp/requirements-collections.yml && \
    rm /tmp/requirements-collections.yml

# Working directory
WORKDIR /workspace

ARG URL
ARG SOURCE
ARG BUILD_DATE
ARG AUTHORS
ARG VENDOR
ARG REVISION
ARG ANSIBLE_VERSION
ARG PYTHON_VERSION=3.11

# https://github.com/opencontainers/image-spec/blob/master/annotations.md
LABEL \
    "maintainer"="laszlo@optimode.hu" \
    "org.opencontainers.image.title"="Ansible Core" \
    "org.opencontainers.image.description"="Ansible Core ${ANSIBLE_VERSION} with HashiCorp Vault support and commonly used collections" \
    "org.opencontainers.image.url"="$URL" \
    "org.opencontainers.image.source"="$SOURCE" \
    "org.opencontainers.image.version"="${ANSIBLE_VERSION}" \
    "org.opencontainers.image.revision"="$REVISION" \
    "org.opencontainers.image.licenses"="MIT" \
    "org.opencontainers.image.created"="$BUILD_DATE" \
    "org.opencontainers.image.authors"="$AUTHORS" \
    "org.opencontainers.image.vendor"="$VENDOR" \
    "org.opencontainers.image.base.name"="python:${PYTHON_VERSION}-slim" \
    "org.opencontainers.image.ref.name"="python:${PYTHON_VERSION}-slim"


CMD ["/bin/bash"]
