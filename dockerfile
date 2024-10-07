FROM bitwalker/alpine-elixir-phoenix:latest

# Set exposed ports
ENV PORT=4000 MIX_ENV=dev

# Cache elixir deps
ADD mix.exs mix.lock ./
RUN mix do deps.get, deps.compile

# Same with npm deps
# ADD assets/package.json assets/
# RUN cd assets && \
#     npm install

ADD . .

# Run frontend build, compile, and digest assets
RUN mix do compile, phx.digest

CMD ["mix", "phx.server"]
