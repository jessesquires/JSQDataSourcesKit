#!/bin/bash

function run_against_pr {
    cd ..; bundle install
    
    # Use the provided PR to run danger against.
    bundle exec danger pr https://github.com/jessesquires/JSQDataSourcesKit/pull/$1
}

######################
# Run danger locally #
######################

if [ $# = 1 ] ; then
    run_against_pr $1
else
    echo "No arguments given... You MUST provide a valid github PR number."
    echo "Example usage: sh $0 120"
    exit 0
fi
