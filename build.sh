#! /bin/bash

set -o xtrace
set -eu

cd electron
npm install

cd ../lbrynet
pyinstaller lbry.py -y --windowed --onefile --icon=../../lbry/packaging/osx/lbry-osx-app/app.icns

cd ../../lbry-web-ui
git checkout master
git pull --rebase
git cherry-pick 06224b1d2cf4bf1f63d95031502260dd9c3ec5c1
node_modules/.bin/node-sass --output dist/css --sourcemap=none scss/
webpack
git reset --hard origin/master

cd ../lbry-electron/
cp -R ../lbry-web-ui/dist electron/

mv lbrynet/dist/lbry electron/dist

echo 'Build complete. Run `electron electron` to launch the app'