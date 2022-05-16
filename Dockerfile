FROM debian:bullseye-slim AS build

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y git python2 g++ make
RUN git clone https://github.com/dwservice/agent.git /app
WORKDIR /app/make
RUN git checkout 7514dbfbff77fba8d5ad343277825da25b82bac8
RUN apt-get install -y libx11-dev libxpm-dev libxext-dev libxtst-dev libxdamage-dev
RUN python2.7 compile_all.py

FROM debian:bullseye-slim
ARG PKGS=
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y python2 jq libpulse0 ${PKGS} && rm -rf /var/lib/apt/lists/*
COPY --from=build /app /app
WORKDIR /app/core

COPY entrypoint.sh /entrypoint.sh

CMD ["/entrypoint.sh"]

