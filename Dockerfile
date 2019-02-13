from ruby:2.5

run apt update && apt -y install libsodium-dev

RUN useradd -rm -d /home/app -s /bin/bash -g root -G sudo -u 1001 app
USER 1001
WORKDIR /home/app

COPY Gemfile Gemfile.lock ./
RUN bundle install --deployment

COPY . .

CMD ["bundle", "exec", "ruby", "main.rb"]
