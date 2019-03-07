#!/bin/bash

# Get the PR number provided or set the default to 1. 
function get_pr_value {
    if [ $# = 1 ] ; then
        echo $1
    else
        echo "1"
    fi
}

function run_against_pr {
    cd ..; bundle install

    # Use the provided PR to run danger against.
    bundle exec danger pr https://github.com/kevnm67/JSQDataSourcesKit/pull/$(get_pr_value $1)
}

######################
# Run danger locally #
######################

run_against_pr 1