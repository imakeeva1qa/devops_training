ARG RUBY_VERSION=2.7.2
ARG RUBY_PATH=/usr/local

FROM ubuntu:20.04 AS builder
ARG RUBY_PATH
ARG RUBY_VERSION
RUN apt-get update && \
    apt-get install -y \
        git \
        curl \
        gcc \
        make \
        wget \
        libssl-dev \
        zlib1g-dev \
        libmysqlclient-dev \
        redis-server \
        libsqlite3-dev \
        libreadline-dev
RUN wget https://github.com/rbenv/ruby-build/archive/refs/tags/v20221101.tar.gz -P $RUBY_PATH/plugins/ruby-build/ && \
    tar -xzf $RUBY_PATH/plugins/ruby-build/*.tar.gz -C $RUBY_PATH/plugins/ruby-build/ && \
    $RUBY_PATH/plugins/ruby-build/ruby-build-*/install.sh
RUN ruby-build $RUBY_VERSION $RUBY_PATH

FROM ubuntu:20.04
ARG RUBY_PATH
ENV PATH $RUBY_PATH/bin:$PATH

COPY --from=builder $RUBY_PATH $RUBY_PATH

CMD [ "irb" ]