#!/bin/sh

### CHROME EXTENSION BUILD SCRIPT ###
# Requirements:
# * Closure Compiler - Download from https://docs.google.com/viewer?url=http%3A%2F%2Fclosure-compiler.googlecode.com%2Ffiles%2Fcompiler-latest.zip and extract full folder to lib/
# * Coffeescript
# * SASS - http://sass-lang.com/

if [ "$1" == "-d" ]; then
	echo "Compiling DEV extension"
else
	echo "Compiling extension"
fi

#Exit Shell Script on fail
set -e

echo "Checking for errors and compiling progress.js..."
rm -rf extension/js/
mkdir -p extension/js/

if [ "$1" != "-d" ]; then
	sed -i.bak 's/"name"\: "\[DEV\]/"name"\: "/g' extension/manifest.json
else
	sed -i.bak 's/"name"\: "/"name"\: "\[DEV\]/g' extension/manifest.json
fi
rm extension/manifest.json.bak

echo "Compiling Coffeescript"
coffee -c js/

echo "Moving background.js"
cp js/background.js extension/js/background.js

echo "Compiling Javascript files..."
javascripts=(js/lib/jquery-1.8.3.js js/lib/jquery-ui-1.9.2.custom.js js/lib/json2.js js/googly.js)
commands=$(for file in "${javascripts[@]}"; do echo "--js $file"; done)
java -jar lib/compiler-latest/compiler.jar --jscomp_off=suspiciousCode --js_output_file extension/js/inject.js $commands

echo "Compiling SCSS to CSS..."
mkdir -p extension/css/images
sass --style compressed css/googly.scss:extension/css/googly.css --style compressed

echo "Moving Libraries for option page"
cp css/chrome-bootstrap/chrome-bootstrap.css extension/css/
cp js/lib/jquery-1.8.3.js extension/js/

echo "Moving CSS files to extension folder..."
rm -rf extension/css/images/*
cp -r css/images/* extension/css/images

#echo "Moving images to extension folder..."
#rm -rf extension/images/*
#cp -r images extension/

echo "Cleaning filesystem..."
rm -f extension/.DS_Store
rm -f extension/manifest.json~

#echo "Compressing extension to googly.zip..."
#zip -r googly extension/*

#echo "Chrome extension compiled successfully to googly.zip."
exit 0

