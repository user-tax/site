#!/usr/bin/env bash

DIR=$(dirname $(realpath "$0"))
cd $DIR
set -ex
rm -rf dist/*.js
bun run cep -- -c index_htm -o dist
