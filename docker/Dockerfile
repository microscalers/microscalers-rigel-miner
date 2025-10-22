FROM ubuntu:24.04

WORKDIR /opt/rigel

RUN apt update && \
    apt install -y wget curl unzip sudo ca-certificates gnupg && \
    rm -rf /var/lib/apt/lists/*

# Copy miner binary & scripts
COPY scripts/start_rvn.sh /opt/rigel/start_rvn.sh
RUN chmod +x /opt/rigel/start_rvn.sh

# Add a non-root user for running inside container
RUN useradd -m miner && \
    chown -R miner:miner /opt/rigel
USER miner

ENTRYPOINT ["/opt/rigel/start_rvn.sh"]
