from ruby:2.5

run apt update && apt -y install libsodium-dev
copy Gemfile Gemfile.lock ./
run bundle install

copy . .

cmd ["bundle", "exec", "ruby", "main.rb"]
