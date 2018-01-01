#!/bin/bash

# Docs by jazzy
# https://github.com/realm/jazzy
# ------------------------------

jazzy \
    --clean \
    --author 'Jesse Squires' \
    --author_url 'https://twitter.com/jesse_squires' \
    --github_url 'https://github.com/jessesquires/JSQDataSourcesKit' \
    --module 'JSQDataSourcesKit' \
    --source-directory . \
    --readme 'README.md' \
    --documentation 'Guides/*.md' \
    --output docs/ \
