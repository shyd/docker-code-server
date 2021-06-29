FROM codercom/code-server

USER root

RUN apt update && \
    apt -y install curl

ENV TERM=xterm-256color

RUN curl https://raw.githubusercontent.com/shyd/dotfiles/main/run-once.sh | bash

RUN rm -rf /var/lib/apt/lists/*

RUN chsh -s $(which zsh)
RUN chsh -s $(which zsh) $(id -un 1000)

USER 1000

RUN curl https://raw.githubusercontent.com/shyd/dotfiles/main/run-once.sh | bash
