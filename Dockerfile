FROM ubuntu:20.10

RUN apt update -qq && \
    apt install -y postgresql-client ruby ruby-dev ruby-bundler libgeos-3.8.1 libgeos-dev nodejs 
RUN apt install -y pkg-config
RUN apt install -y build-essential 
RUN apt install -y patch
RUN apt install -y zlib1g-dev 
RUN apt install -y liblzma-dev
RUN apt install -y libpq-dev
RUN gem install bundler:1.16.0 
RUN mkdir /myapp
WORKDIR /myapp

#COPY Gemfile /myapp/Gemfile
#COPY Gemfile.lock /myapp/Gemfile.lock

COPY . /myapp
RUN rm -rf /myapp/tmp/*

RUN bundle install

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

#Start the main process
CMD ["rails", "server", "-b", "0.0.0.0"]


