#!/bin/bash
[[ -s '/usr/local/lib/rvm' ]] && source '/usr/local/lib/rvm'
rake radiant:extensions:reorder:migrate
rake radiant:extensions:reorder:update
