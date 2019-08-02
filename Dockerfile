FROM docker:stable

LABEL "com.github.actions.name"="Velociraptor"
LABEL "com.github.actions.description"="Builds and pushes images to Google Cloud"
LABEL "com.github.actions.icon"="cloud-lightning"
LABEL "com.github.actions.color"="purple"

LABEL "repository"="http://github.com/sevenmind/velociraptor"
LABEL "homepage"="http://github.com/sevenmind/velociraptor"
LABEL "maintainer"="Sequoia Snow <the1codemaster@gmail.com>"

# A nice space to do some work
WORKDIR /velociraptor

# Install blackbox and dependencies
RUN apk add -U gnupg openssh git make bash && \
  git clone https://github.com/StackExchange/blackbox.git && \
  cd blackbox && make copy-install  && \
  rm -rf *

COPY deploy.sh /deploy.sh
COPY entrypoint.sh /entrypoint.sh

# Ensure scripts are executable.
RUN chmod +x /deploy.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
