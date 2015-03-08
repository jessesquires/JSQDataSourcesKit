#!/bin/bash

# Docs by jazzy
#
# https://github.com/realm/jazzy
# ------------------------------

cd JSQDataSourcesKit
jazzy -o ../_docs -a 'Jesse Squires' -u 'https://twitter.com/jesse_squires' -m 'JSQDataSourcesKit' -g 'https://github.com/jessesquires/JSQDataSourcesKit'
cd ..
open _docs/
