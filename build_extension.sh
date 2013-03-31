#!/bin/sh

### CHROME EXTENSION BUILD SCRIPT ###
# Requirements:
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
coffee --compile --output scripts scripts

echo "Moving background.js and option.js"
cp js/background.js extension/js/background.js
cp js/options.js extension/js/options.js

echo "Compiling RequireJS files with Uglify and r.js..."
if [ "$1" != "-d" ]; then
	node lib/r.js -o build.js
else
	node lib/r.js -o build.js optimize=none
fi

echo "Compiling SCSS to CSS..."
mkdir -p extension/css/images
if [ "$1" != "-d" ]; then
	sass css/googly.scss:extension/css/googly.css
else
	sass css/googly.scss:extension/css/googly.css --style compressed
fi

echo "Moving Libraries for option page"
cp css/chrome-bootstrap/chrome-bootstrap.css extension/css/
cp js/lib/jquery-1.8.3.js extension/js/
#cp -r  js/lib extension/js

echo "Moving CSS files to extension folder..."
rm -rf extension/css/images/*
cp -r css/images/* extension/css/images

#echo "Moving images to extension folder..."
#rm -rf extension/images/*
#cp -r images extension/

echo "Cleaning filesystem..."
rm -f extension/.DS_Store
rm -f extension/manifest.json~

echo "Compressing extension to googly.zip..."
zip -r googly extension/*

#echo "Chrome extension compiled successfully to googly.zip."
exit 0

