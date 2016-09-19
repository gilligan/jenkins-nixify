#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl -p nodePackages.jsonlint -p jq

set -e

UPDATE_CENTER_JSON_URL=http://updates.jenkins-ci.org/update-center.json
curl -L $UPDATE_CENTER_JSON_URL | sed -n '2p' | jsonlint | jq ".plugins | map (.)" > jenkins-plugins.json
