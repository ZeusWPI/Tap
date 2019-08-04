# [Tap](https://zeus.ugent.be/tap) [![Code Climate](https://codeclimate.com/github/ZeusWPI/Tap/badges/gpa.svg)](https://codeclimate.com/github/ZeusWPI/Tap) [![Travis CI](https://travis-ci.org/ZeusWPI/Tap.svg)](https://travis-ci.org/ZeusWPI/Tap) [![Coverage Status](https://coveralls.io/repos/ZeusWPI/Tap/badge.svg?branch=master&service=github)](https://coveralls.io/github/ZeusWPI/Tap?branch=master)

Yes. We have to drink. But we also have to pay. This is the drinking part.

## Installation

1. Make sure Ruby version 2.4.0 is installed by running `rbenv version`. If it isn't, install by running `rbenv install`
2. Run `bundle update` and `bundle install`
3. Migrate the db using `bundle exec rake db:migrate`
4. Seed the db using `bundle exec rake db:seed`
5. Start Tap by running `bundle exec rails s`

## Windows installation

[klik hier](README_WINDOWS.md)

## Wat als de delayed job kapot is waardoor er geen transacties van tap naar tab gaan?

```
sudo -u tap RAILS_ENV=production /home/tap/production/current/bin/delayed_job start
```
