#!/bin/bash
[[ -s '/usr/local/lib/rvm' ]] && source '/usr/local/lib/rvm'
rvm use ree-1.8.7
rake production db:create
rake production db:migrate
rake production db:migrate:extensions
rake production radiant:extensions:reorder:update
