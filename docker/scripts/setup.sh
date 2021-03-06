#!/bin/bash
set -e
cd $HOME

# enable therubyracer gem
sed -i "s/# gem 'therubyracer'/gem 'therubyracer'/" Gemfile

bundle config path "$HOME/bundler"
bundle install

./bin/rake db:migrate