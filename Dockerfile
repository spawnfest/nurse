FROM elixir:alpine

RUN mkdir /app
COPY . /app
WORKDIR /app

RUN mix local.hex --force

RUN mix deps.get

ENTRYPOINT ["/app/entrypoint.sh"]
