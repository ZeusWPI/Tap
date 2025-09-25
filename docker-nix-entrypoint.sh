#!/bin/sh
cd /tap

if [ $# -gt 0 ]; then
    exec nix develop --command "$@"
else
    nix develop --command bundle exec rake db:migrate
    exec nix develop --command bundle exec rails server -b 0.0.0.0 -p 80
fi
