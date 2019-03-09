#!/bin/bash

# Test running danger locally
if [ $# = 1 ] ; then
    bundle exec danger pr https://github.com/jessesquires/JSQDataSourcesKit/pull/$1
else
    echo "No arguments given. Provide a valid GitHub PR number."
    echo "Example usage: sh $0 120"
    exit 0
fi
