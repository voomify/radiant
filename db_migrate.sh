#!/bin/bash
[[ -s '/usr/local/lib/rvm' ]] && source '/usr/local/lib/rvm'
rake radiant:extensions:migrate
rake radiant:extensions:reorder:update
