#!/usr/bin/env bash

DIR=$(dirname $(realpath "$0"))
cd $DIR
set -ex

rm -rf dist
./build.sh
rm -rf dist/i18n
./sh/i18n.upload.coffee
./sh/filename_min.coffee
./sh/sw.coffee
cp sh/dist/* dist
#./sh/qiniu.unload.coffee
