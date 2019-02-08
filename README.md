# Installation instructions

`bundle install` will install the dependencies for the project

# How to run

There needs to be a file called `config` in the root directory.
This file is functionally a .env file, with the following keys:

```
discord=<Your discord api key>
google=<A google api key>
search_id=<The search engine id for your custom search engine>
reddit_secret=<Reddit secret for .. reddit>
reddit_clientid=<Reddit api client id>
reddit_user=<Your reddit username>
reddit_pass=<Your reddit password>
admins=<A comma delimited list of discord user ids, who can do administration tasks on the bot>
open_weather_key=<An open weather map api key>
```

The following keys are optional, and are only used for proxying chat.stackoverflow.com to a discord channel:

```
room_id=<The so chat room id>
channel_id=<The discord channel ID you want to proxy the SO chat to>
so_user=<A SO chat user>
so_pass=<The password for the SO chat user>
```

Once the file is there, you can run the bot with:

`bundle exec ruby main.rb`

# Debugging

You can pause executation at any line by calling `byebug`.

You can read byebug's documentation here: https://github.com/deivid-rodriguez/byebug

Basically it pauses executation and drops you in a console in the executation context for you to fuck around in
