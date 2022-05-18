FROM debian:bullseye-slim AS build

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y git python3 g++ make
RUN git clone --depth=1 https://github.com/dwservice/agent.git /app
WORKDIR /app/make
RUN apt-get install -y libx11-dev libxpm-dev libxext-dev libxtst-dev libxdamage-dev
RUN python3 compile_all.py

FROM debian:bullseye-slim
ARG PKGS=
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y python3 jq libpulse0 ${PKGS} && rm -rf /var/lib/apt/lists/*
COPY --from=build /app /app
WORKDIR /app/core

COPY entrypoint.sh /entrypoint.sh

CMD ["/entrypoint.sh"]

