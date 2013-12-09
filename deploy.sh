#!/bin/bash
git pull
RAILS_ENV=production rake assets:precompile
touch tmp/restart.txt
