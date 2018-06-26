FROM ubuntu:16.04
MAINTAINER Juan Pablo Royo <juanpablo.royo@gmail.com>

ENV HOME /root
ENV PATH $HOME/.rbenv/bin:$HOME/.rbenv/shims:$PATH
ENV SHELL /bin/bash

RUN apt-get -q update && DEBIAN_FRONTEND=noninteractive apt-get -q -y install wget curl locales

RUN locale-gen en_US.UTF-8

ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN echo "deb http://packages.couchbase.com/ubuntu trusty trusty/main" > /etc/apt/sources.list.d/couchbase.list

RUN wget -O- http://packages.couchbase.com/ubuntu/couchbase.key | apt-key add -

RUN wget -O - https://github.com/sstephenson/rbenv/archive/master.tar.gz \
  | tar zxf - \
  && mv rbenv-master $HOME/.rbenv
RUN wget -O - https://github.com/sstephenson/ruby-build/archive/master.tar.gz \
  | tar zxf - \
  && mkdir -p $HOME/.rbenv/plugins \
  && mv ruby-build-master $HOME/.rbenv/plugins/ruby-build

RUN echo 'eval "$(rbenv init -)"' >> $HOME/.profile
RUN echo 'eval "$(rbenv init -)"' >> $HOME/.bashrc

ENV RUBY_VERSION 2.3.0

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -

RUN apt-get update -q \
  && apt-get -q -y install autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev gcc g++ libcouchbase2-libevent libcouchbase-dev nodejs git\
  && apt-get autoremove -y \
  && rm -rf /var/lib/apt/lists

RUN wget -O - http://www.python.org/ftp/python/2.7.3/Python-2.7.3.tgz | tar zxf - \
  && ./Python-2.7.3/configure \
  && make \
  && make install

RUN rbenv install $RUBY_VERSION
RUN rbenv global $RUBY_VERSION

RUN rbenv rehash
