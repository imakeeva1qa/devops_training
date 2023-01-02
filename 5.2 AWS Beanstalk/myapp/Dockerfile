# syntax=docker/dockerfile:1
# https://github.com/docker/awesome-compose/tree/master/official-documentation-samples/rails/
FROM ruby:3.2.0

WORKDIR /myapp

COPY . /myapp

RUN \
  curl -sL https://deb.nodesource.com/setup_12.x | bash - \
  && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | \
    apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | \
    tee /etc/apt/sources.list.d/yarn.list \
  && apt-get update \
  && apt-get install -y \
  build-essential \
  nodejs \
  yarn \
  && cd /myapp \
  && gem install bundler \
  && bundle install \
  && yarn install 

EXPOSE 3000

# Configure the main process to run when running the image
#CMD ["rails", "server", "-b", "0.0.0.0"]
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
