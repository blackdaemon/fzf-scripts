FROM alpine:latest

# Install Zsh, FZF, and dependencies
RUN apk add --no-cache zsh fzf bash

#COPY ../ev.sh /root/ev.sh

# Ensure the script is executable
#RUN chmod +x /root/ev.sh

# Set the working directory to /root
WORKDIR /root

# Set Zsh as the default shell
#SHELL ["/bin/zsh", "-c"]

RUN echo "source scripts/ev.sh" >> /root/.zshrc
RUN echo "export PS1='zsh test shell (docker): '" >> /root/.zshrc

# Start Zsh and source the script
CMD ["zsh", "-i"]


