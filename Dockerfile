FROM codercom/code-server

USER root

RUN apt update && \
    apt -y install curl

ENV TERM=xterm-256color

RUN curl https://raw.githubusercontent.com/shyd/dotfiles/main/run-once.sh | bash

RUN rm -rf /var/lib/apt/lists/*

# add Hack Nerd Font
RUN sed -i 's/<\/head>/<link rel="stylesheet" href="https:\/\/cdnjs.schuett.link\/Hack%20Nerd%20Font.css"><\/head>/g' /usr/lib/code-server/src/browser/pages/vscode.html

RUN chsh -s $(which zsh)
RUN chsh -s $(which zsh) $(id -un 1000)

USER 1000
RUN mkdir ~/projects
RUN curl https://raw.githubusercontent.com/shyd/dotfiles/main/run-once.sh | bash

VOLUME /home/coder
