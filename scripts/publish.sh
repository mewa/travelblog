#!/bin/sh

BRANCH=$(git branch --list | grep '*' | cut -d' ' -f2)

hugo

git checkout gh-pages
git pull

find . ! -path './.git*' ! -path './public*' -delete
mv public/* .
rmdir public

git add .

MSG=$(echo -e "$0: Updated deployment")
git commit -m "$MSG"

git push
git checkout "$BRANCH"
