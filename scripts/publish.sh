#!/bin/bash
set -euo pipefail

PUBLISH_BRANCH=gh-pages

BRANCH=$(git symbolic-ref --short HEAD)
REMOTE=$(git config "branch.$BRANCH.remote")
REMOTE_URL=$(git config "remote.$REMOTE.url")

mkdir public || true
cd public

git init
git remote add "$REMOTE" "$REMOTE_URL" || true

git fetch --depth=1 $REMOTE $PUBLISH_BRANCH
git checkout $PUBLISH_BRANCH || git checkout -b $PUBLISH_BRANCH

git rm -rf .
git reset -- CNAME
git checkout -- CNAME

cd .. && hugo && cd public
git add .

STATUS=$(git status --porcelain)
MSG=$(echo -e "$0: Updated deployment\n\n$STATUS")
git commit -m "$MSG"

git push "$REMOTE" "$PUBLISH_BRANCH"
