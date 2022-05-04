FROM codercom/code-server

USER root

RUN apt update && \
    apt -y install vim zsh wget curl git tree rsync openssh-client zip default-mysql-client dnsutils \
        nodejs npm yarn \
        imagemagick graphicsmagick libvips libvips-dev \
        libssl-dev libreadline-dev zlib1g-dev \
        autoconf bison build-essential libyaml-dev \
        libreadline-dev libncurses5-dev libffi-dev libgdbm-dev \
        sudo

RUN npm install -g gulp-cli bower gh-pages
# remove orphans
RUN rm -rf $HOME/.npm
#RUN rm $HOME/.wget-hsts

ENV TERM=xterm-256color

RUN curl https://raw.githubusercontent.com/shyd/dotfiles/main/run-once.sh | bash

RUN rm -rf /var/lib/apt/lists/*

# add Nerd Font
# thanks https://github.com/demyxsh/code-server/blob/master/tag-latest/Dockerfile
RUN set -ex; \
    # Custom fonts
    cd /usr/lib/code-server/src/browser/pages; \
    curl -O "https://cdnjs.schuett.link/fonts/{meslolgs-nf-regular.woff,meslolgs-nf-bold.woff,meslolgs-nf-italic.woff,meslolgs-nf-bold-italic.woff}"; \
    \
    CODE_WORKBENCH="$(find /usr/lib/code-server -name "*workbench.html")"; \
    sed -i "s|</head>|\
    <style> \n\
        @font-face { \n\
        font-family: 'MesloLGS NF'; \n\
        font-style: normal; \n\
        src: url('_static/src/browser/pages/meslolgs-nf-regular.woff') format('woff'), \n\
        url('_static/src/browser/pages/meslolgs-nf-bold.woff') format('woff'), \n\
        url('_static/src/browser/pages/meslolgs-nf-italic.woff') format('woff'), \n\
        url('_static/src/browser/pages/meslolgs-nf-bold-italic.woff') format('woff'); \n\
    } \n\
    \n\</style></head>|g" "$CODE_WORKBENCH";

RUN chsh -s $(which zsh)
RUN chsh -s $(which zsh) $(id -un 1000)

USER 1000
RUN mkdir ~/projects
RUN mkdir ~/.ssh
RUN chmod 700 ~/.ssh
RUN mkdir ~/.aws

RUN code-server --install-extension github.github-vscode-theme
RUN code-server --install-extension amazonwebservices.aws-toolkit-vscode
#RUN code-server --install-extension rangav.vscode-thunder-client

RUN curl https://raw.githubusercontent.com/shyd/dotfiles/main/run-once.sh | bash
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
        unzip awscliv2.zip && \
        sudo ./aws/install && \
        rm awscliv2.zip && \
        rm -r aws

# install ruby in rbenv
SHELL ["/bin/bash", "-c"]
RUN curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash

RUN export PATH="$HOME/.rbenv/bin:$PATH"
RUN eval "$($HOME/.rbenv/bin/rbenv init -)"

RUN $HOME/.rbenv/bin/rbenv install 2.6.0
RUN $HOME/.rbenv/bin/rbenv global 2.6.0

RUN echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.zshrc
RUN echo 'eval "$(rbenv init -)"' >> ~/.zshrc

#TODO add nvm https://github.com/nvm-sh/nvm#installing-and-updating

VOLUME /home/coder/projects
VOLUME /home/coder/.ssh
VOLUME /home/coder/.aws
VOLUME /home/coder/.local/share/code-server/User/

# some devel ports
EXPOSE 3000
EXPOSE 3001
EXPOSE 3002
EXPOSE 3003
