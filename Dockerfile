# syntax = docker/dockerfile:1

# Base image for Ruby.
FROM ruby:3.2-alpine as base

ENV RAILS_ENV="production"

RUN adduser -D app


# Throw-away build stage to reduce size of final image
FROM base as builder

ARG NODE_VERSION=18.13.0
ARG YARN_VERSION=1.22.19

ENV BUNDLE_FROZEN=true
ENV BUNDLE_JOBS=4
ENV BUNDLE_RETRY=3
ENV BUNDLE_TIMEOUT=10
ENV BUNDLE_WITHOUT="development,test"

RUN apk --no-cache --update add \
    build-base \
    curl \
    git \
    libc6-compat \
    nodejs \
    tzdata \
    postgresql-dev \
    libxslt-dev \
    libxml2-dev \
    vips-dev \
    yarn \
    && mkdir -p /app
WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install --jobs=$BUNDLE_JOBS \
    && bundle exec bootsnap precompile --gemfile \
    && rm -rf /usr/local/bundle/cache/*.gem \
    && find /usr/local/bundle/gems/ -name "*.c" -delete \
    && find /usr/local/bundle/gems/ -name "*.o" -delete

COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

COPY . .

RUN bundle exec bootsnap precompile app/ lib/ \
    && SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile


# Final stage for app image
FROM base

ENV RAILS_MAX_THREADS=5
ENV RAILS_MIN_THREADS=5
ENV RUBY_YJIT_ENABLE=1

RUN apk --no-cache --update add \
    libc6-compat \
    postgresql-client \
    redis \
    tzdata \
    && mkdir -p /app

COPY --from=builder /usr/local/bundle /usr/local/bundle
COPY --from=builder /app /app

WORKDIR /app
RUN mkdir -p log storage tmp/{cache,pids,sockets} \
    && chown -R app log storage tmp

USER app

EXPOSE 3000

ENTRYPOINT ["/app/bin/docker-entrypoint.sh"]
CMD ["./bin/rails", "server"]
