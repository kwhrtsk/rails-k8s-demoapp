### image for build
FROM ruby:2.5.1-alpine AS build-env

ARG RAILS_ROOT=/app
ARG BUILD_PACKAGES="build-base curl-dev git"
ARG DEV_PACKAGES="libxml2-dev libxslt-dev mysql-dev yaml-dev zlib-dev nodejs yarn"
ARG RUBY_PACKAGES="tzdata yaml"

WORKDIR $RAILS_ROOT

# install packages
RUN apk update \
 && apk upgrade \
 && apk add --update --no-cache $BUILD_PACKAGES $DEV_PACKAGES $RUBY_PACKAGES

# install rubygem
COPY Gemfile Gemfile.lock $RAILS_ROOT/
RUN bundle install -j4 --path=vendor/bundle

# install npm
COPY package.json yarn.lock $RAILS_ROOT/
RUN yarn install

# build assets
COPY . $RAILS_ROOT
RUN bundle exec rake webpacker:compile
RUN bundle exec rake assets:precompile

### image for execution
FROM ruby:2.5.1-alpine
LABEL maintainer 'Kawahara Taisuke <kwhrtsk@gmail.com>'

ARG RAILS_ROOT=/app
ARG PACKAGES="tzdata yaml mariadb-client-libs bash"

ENV RAILS_ENV=production
ENV BUNDLE_APP_CONFIG="$RAILS_ROOT/.bundle"

WORKDIR $RAILS_ROOT

# install packages
RUN apk update \
 && apk upgrade \
 && apk add --update --no-cache $PACKAGES

COPY --from=build-env $RAILS_ROOT $RAILS_ROOT
