#!/bin/bash
[[ -s '/usr/local/lib/rvm' ]] && source '/usr/local/lib/rvm'
rake production db:migrate:extensions
rake production radiant:extensions:reorder:update
