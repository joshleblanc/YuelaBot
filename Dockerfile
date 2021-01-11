FROM ruby:2.7

RUN mkdir /app
WORKDIR /app

RUN apt-get update && apt-get -y install libsodium-dev python lbzip2
ADD Gemfile ./Gemfile
ADD Gemfile.lock ./Gemfile.lock
RUN gem update --system
RUN gem install bundler
RUN bundle install

ADD . .

CMD ["bundle", "exec", "ruby", "main.rb"]
