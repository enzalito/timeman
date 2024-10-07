FROM bitwalker/alpine-elixir-phoenix:1.14

# Set exposed ports
ENV PORT=4000 MIX_ENV=dev

ADD . . 

# Cache elixir deps
RUN mix do deps.get, deps.compile

# Same with npm deps
# ADD assets/package.json assets/
# RUN cd assets && \
#     npm install

# Run frontend build, compile, and digest assets
RUN mix do compile, phx.digest

CMD ["mix", "phx.server"]
