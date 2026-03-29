[![Maintainability](https://api.codeclimate.com/v1/badges/5c5616b0415f4470e44d/maintainability)](https://codeclimate.com/github/HorizonShadow/YuelaBot/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/5c5616b0415f4470e44d/test_coverage)](https://codeclimate.com/github/HorizonShadow/YuelaBot/test_coverage)

#### 🌏  Open in the Cloud 

Click any of the buttons below to start a new development environment to demo or contribute to the codebase without having to install anything on your machine:

[![Open in VS Code](https://img.shields.io/badge/Open%20in-VS%20Code-blue?logo=visualstudiocode)](https://vscode.dev/github/joshleblanc/yuelabot)
[![Open in Glitch](https://img.shields.io/badge/Open%20in-Glitch-blue?logo=glitch)](https://glitch.com/edit/#!/import/github/joshleblanc/yuelabot)
[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/joshleblanc/yuelabot)
[![Open in StackBlitz](https://developer.stackblitz.com/img/open_in_stackblitz.svg)](https://stackblitz.com/github/joshleblanc/yuelabot)
[![Edit in Codesandbox](https://codesandbox.io/static/img/play-codesandbox.svg)](https://codesandbox.io/s/github/joshleblanc/yuelabot)
[![Open in Repl.it](https://replit.com/badge/github/withastro/astro)](https://replit.com/github/joshleblanc/yuelabot)
[![Open in Codeanywhere](https://codeanywhere.com/img/open-in-codeanywhere-btn.svg)](https://app.codeanywhere.com/#https://github.com/joshleblanc/yuelabot)
[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/joshleblanc/yuelabot)

# Quick Start

Click the gitpod button above to launch into a pre-configured cloud IDE. All you have to do is setup your bot token in .env, then run `bundle exec ruby main.rb`

# Prerequisites

* Ruby
* Postgres*

\* You can change the database driver in ./config/database.yml if you so desire. You'll need to include the
associated gem in the Gemfile as well.

# Installation instructions

`bundle install` will install the dependencies for the project

`rake db:create` will create the database

`rake db:migrate` will run the database migrations

# How to run

There needs to be a file called `config` in the `config` directory.
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
wordnik_key=<API key for wordnik>
github_access_token=<Access token for github, for submitting issues>
```


Once the file is there, you can run the bot with:

`bundle exec foreman start`


# Debugging

You can pause executation at any line by calling `byebug`.

You can read byebug's documentation here: https://github.com/deivid-rodriguez/byebug

Basically it pauses executation and drops you in a console in the execution context for you to play around in

# Support me

<a href="https://www.buymeacoffee.com/jleblanc" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" height="40"></a>
