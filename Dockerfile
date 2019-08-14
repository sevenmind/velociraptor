FROM docker:stable

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
