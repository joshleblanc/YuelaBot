from ruby:2.5

run apt update && apt -y install libsodium-dev

RUN mkdir ./yuela

WORKDIR ./yuela
COPY Gemfile Gemfile.lock ./
RUN bundle install --deployment

COPY . .

USER 1001


CMD ["bundle", "exec", "ruby", "main.rb"]
