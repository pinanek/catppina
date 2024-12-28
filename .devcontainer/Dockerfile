# -------------------------------------------------------- #
# ------------------ System and runtimes ----------------- #
# -------------------------------------------------------- #

ARG DENO_VERSION=2.1.4
ARG WHISKERS_VERSION=2.5.1

ARG USERNAME=pinanek
ARG USER_UID=1000
ARG USER_GID=${USER_UID}
ARG USER_HOME=/home/${USERNAME}

FROM debian:trixie

ARG USERNAME
ARG USER_UID
ARG USER_GID
ARG USER_HOME

# ------------------------ System ----------------------- #

# Create non-root user
RUN DEBIAN_FRONTEND=noninteractive groupadd --gid ${USER_GID} ${USERNAME} \
  && useradd --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME} \
  && apt update \
  && apt install -y sudo \
  && echo ${USERNAME} ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${USERNAME} \
  && chmod 0440 /etc/sudoers.d/${USERNAME}

# Install additional packages
RUN DEBIAN_FRONTEND=noninteractive apt install -y python3 curl git unzip gzip xz-utils

USER ${USERNAME}
WORKDIR ${USER_HOME}

RUN mkdir -p ${USER_HOME}/.local/bin
ENV PATH="${USER_HOME}/.local/bin:$PATH"

ARG DENO_VERSION
RUN curl -fsSL https://deno.land/install.sh | sh -s -- -y v${DENO_VERSION}
ENV PATH="${USER_HOME}/.deno/bin:$PATH"

RUN curl -fsSL https://dprint.dev/install.sh | sh
ENV DPRINT_INSTALL="${USER_HOME}/.dprint"
ENV PATH="$DPRINT_INSTALL/bin:$PATH"

ARG WHISKERS_VERSION
RUN curl -fsSL https://github.com/catppuccin/whiskers/releases/download/v${WHISKERS_VERSION}/whiskers-x86_64-unknown-linux-gnu \
  -o ${USER_HOME}/.local/bin/whiskers \
  && chmod +x ${USER_HOME}/.local/bin/whiskers

RUN curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to ${USER_HOME}/.local/bin \
  && chmod +x ${USER_HOME}/.local/bin/just
