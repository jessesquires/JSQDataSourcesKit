#!/bin/bash

# automatically build and publish updated docs to gh-pages

./build_docs.sh
./copy_docs.sh
cd ~/Sites/jsqdatasourceskit/
git add .
git commit -am "auto-update docs"
git push
git status
cd ~/GitHub/JSQDataSourcesKit/
