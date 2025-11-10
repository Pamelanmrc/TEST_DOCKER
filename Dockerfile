# FastQC + STAR + RSEM + samtools + Nextflow + Java 17 (non-root)
FROM mambaorg/micromamba:1.5.8

USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
      bash coreutils findutils gawk tar unzip bzip2 pigz procps \
      ca-certificates curl wget git \
    && rm -rf /var/lib/apt/lists/*

# Bio tools + Java 17
RUN micromamba install -y -n base -c conda-forge -c bioconda \
      openjdk=17 \
      fastqc=0.12.1 \
      star=2.7.11b \
      rsem=1.3.3 \
      samtools=1.20 \
    && micromamba clean -a -y

# Install Nextflow
RUN curl -s https://get.nextflow.io | bash && \
    mv nextflow /usr/local/bin/ && chmod +x /usr/local/bin/nextflow

ENV PATH=/opt/conda/bin:$PATH

# Non-root user
ARG UID=1000 GID=1000 USERNAME=nfuser
RUN groupadd -g ${GID} ${USERNAME} \
 && useradd -m -u ${UID} -g ${GID} -s /bin/bash ${USERNAME} \
 && mkdir -p /workspace \
 && chown -R ${USERNAME}:${USERNAME} /workspace /home/${USERNAME} \
 && chmod 1777 /tmp

ENV HOME=/home/${USERNAME} \
    XDG_CACHE_HOME=/tmp \
    TMPDIR=/tmp \
    UMASK=0002

USER ${USERNAME}
WORKDIR /workspace
SHELL ["/bin/bash","-lc"]
CMD ["bash"]

