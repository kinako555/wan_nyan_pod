FROM ruby:2.6.3
ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -qq && apt-get install -y \
    apt-utils \
    build-essential \
    nodejs \
 && rm -rf /var/lib/apt/lists/*

RUN wget https://nginx.org/keys/nginx_signing.key
RUN apt-key add nginx_signing.key
RUN apt-get install nginx
ADD wan_nyan_pod.conf /etc/nginx/conf.d/wan_nyan_pod.conf

RUN gem install bundler

WORKDIR /tmp
ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
RUN bundle install

ENV APP_HOME /wan_nyan_pod
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME
ADD . $APP_HOME