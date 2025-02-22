FROM alpine:latest

# Install Zsh, FZF, and dependencies
RUN apk add --no-cache zsh fzf bash

# Set the working directory to /root
WORKDIR /root

RUN echo "source scripts/ev.sh" >> /root/.zshrc
RUN echo "export PS1='zsh test shell (docker): '" >> /root/.zshrc

# Start Zsh and source the script
CMD ["zsh", "-i"]

