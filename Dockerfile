# Dockerfile (no environment.yml required)
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Core tools you almost always want in a Nextflow container
RUN apt-get update && apt-get install -y --no-install-recommends \
    bash coreutils findutils gawk tar unzip bzip2 pigz \
    ca-certificates curl wget git \
    python3 python3-pip \
    openjdk-11-jre-headless \
    procps \
    && rm -rf /var/lib/apt/lists/*

# (Optional) Python packages — uncomment if you add requirements.txt
# COPY requirements.txt /tmp/requirements.txt
# RUN python3 -m pip install --no-cache-dir -r /tmp/requirements.txt

# Make a non-root user so outputs aren’t root-owned
RUN useradd -m -u 1000 nfuser
USER nfuser
WORKDIR /workspace

# Use bash for RUN/CMD
SHELL ["/bin/bash","-lc"]
CMD ["bash"]

