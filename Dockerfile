FROM ruby:2.5


RUN mkdir /app
WORKDIR /app

RUN apt update && apt -y install libsodium-dev
ADD Gemfile ./Gemfile
ADD Gemfile.lock ./Gemfile.lock
RUN bundle install

ADD . .

CMD ["bundle", "exec", "ruby", "main.rb"]