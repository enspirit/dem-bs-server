FROM ocaml/opam2:debian-stable

LABEL maintainer="yoann.guyot@enspirit.be"

ENV LANG C.UTF-8
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Set correct environment variables and workdir
ENV HOME /home/opam
WORKDIR /home/opam

USER root

RUN apt-get update -qq && \
    apt-get install -qq --no-install-recommends curl vim libsasl2-dev m4 && \
    apt-get clean

RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV NVM_DIR /home/opam/.nvm
ENV NODE_VERSION 12.18.3

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash -
RUN source .nvm/nvm.sh && \
    nvm install $NODE_VERSION && \
    nvm alias default $NODE_VERSION && \
    nvm use default

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH

RUN chown -Rh opam:opam /home/opam/.nvm

# opam install merlin # IDE features
# oasis # build system and more

USER opam

# RUN chown -R opam /usr/lib/node_modules

RUN npm install -g esy@latest

COPY --chown=opam:opam . /home/opam

RUN esy

CMD esy start
