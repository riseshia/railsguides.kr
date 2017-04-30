#!/usr/bin/env bash
# Save some useful information
REPO=`git config remote.origin.url`
SSH_REPO=${REPO/https:\/\/github.com\//git@github.com:}
SHA=`git rev-parse --verify HEAD`

git config user.email "bot@travis-ci.org"
git config user.name "Chino"

git checkout -b gh-pages
cd guides
bundle exec rake guides:generate:html
mv output/${GUIDES_LANGUAGE}/* ../
cd ..

git rm README.md
git add *.html images javascripts stylesheets
git commit -n -m "deploy to gh-pages ${SHA}"

# Get the deploy key by using Travis's stored variables to decrypt deploy_key.enc
openssl aes-256-cbc -K $encrypted_e3541fee2a9a_key -iv $encrypted_e3541fee2a9a_iv -in deploy_key.enc -out deploy_key -d
chmod 600 deploy_key
eval `ssh-agent -s`
ssh-add deploy_key

git push $SSH_REPO gh-pages -f
