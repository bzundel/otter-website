#FROM elixir:1.18-otp-27-alpine AS build
FROM hexpm/elixir:1.18.3-erlang-27.2.4-debian-bullseye-20250428-slim as build

RUN apt-get update -y && apt-get install -y build-essential git && apt-get clean && rm -f /var/lib/apt/lists/*_*
WORKDIR /app
RUN mix local.hex --force && mix local.rebar --force

ENV MIX_ENV="prod"

COPY mix.exs mix.lock ./
RUN mix deps.get --only prod

RUN mkdir config

COPY config/config.exs config/prod.exs config/
COPY lib lib
COPY priv priv
COPY assets assets

RUN mix assets.deploy

COPY config/runtime.exs config/

RUN mix release

FROM debian:bullseye-20250428-slim

RUN apt-get update -y && apt-get install -y libstdc++6 openssl libncurses5 locales ca-certificates postgresql-client && apt-get clean && rm -f /var/lib/apt/lists/*_*

RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

WORKDIR /app
RUN chown nobody /app

COPY --from=build --chown=nobody:root /app/_build/prod/rel/otter_website ./

ENV MIX_ENV="prod"

COPY docker_entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

USER nobody

ENTRYPOINT ["/app/entrypoint.sh"]
