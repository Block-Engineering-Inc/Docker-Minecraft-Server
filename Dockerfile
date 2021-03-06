FROM openjdk:8-slim

WORKDIR /minecraft

RUN apt-get update && apt-get install -y wget

# Install rcon
RUN wget https://github.com/itzg/rcon-cli/releases/download/1.4.7/rcon-cli_1.4.7_linux_amd64.tar.gz && \
  tar -xzf rcon-cli_1.4.7_linux_amd64.tar.gz && \
  rm rcon-cli_1.4.7_linux_amd64.tar.gz && \
  mv rcon-cli /usr/local/bin

# Setup the server
RUN wget https://github.com/nicholasjackson/mc/releases/download/v0.0.0/forge-1.12.2-14.23.5.2768-installer.tar.gz && \
  tar -xzf forge-1.12.2-14.23.5.2768-installer.tar.gz && \
  rm forge-1.12.2-14.23.5.2768-installer.tar.gz && \
  java -jar forge-1.12.2-14.23.5.2768-installer.jar --installServer

# Copy the signed eula
COPY ./eula.txt eula.txt

# Add the entrypoint
COPY ./entrypoint.sh /minecraft/entrypoint.sh
COPY ./server.properties /server.properties

# Set defaults for environment variables
ENV MINECRAFT_PORT 25565
ENV RCON_PORT 27015
ENV JAVA_MEMORY 1G
ENV RCON_ENABLED false
ENV WHITELIST_ENABLED true
ENV ALLOW_NETHER false

ENTRYPOINT [ "/minecraft/entrypoint.sh" ]