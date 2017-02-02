#!/usr/bin/env bash
org="lean-ide"
repo="2plus2equals2times2"
set -e
# 1. Check NPM and minify
hash npm 2>/dev/null || { echo >&2 "npm is not found. Visit https://nodejs.org/ and install node and npm."; exit 1; }

MINIFY=`npm root`/minify/bin/minify.js
if [ ! -f ${MINIFY} ] ; then
    echo ${MINIFY}
    echo >&2 "minify is not found at ${MINIFY}. Run 'npm install minify' to install it."
    exit 1
fi

# 2. Build
make

# 3. Deploy
rm -fr deploy
mkdir deploy
cd deploy
rm -rf *
git init
cp ../*.html . #../theorem_proving_in_lean.pdf .
cp -r ../css ../images ../fonts ../js .
for CSS in css/*.css
do
    ${MINIFY} ${CSS} > ${CSS}.min
    mv ${CSS}.min ${CSS}
done
for JS in js/*.js
do
    ${MINIFY} ${JS} > ${JS}.min
    mv ${JS}.min ${JS}
done
git add -f *.html #theorem_proving_in_lean.pdf
git add -f css/*
git add -f images/*
git add -f fonts/*
git add -f js/*
git commit -m "Update `date`"
git push git@github.com:$org/$repo +HEAD:gh-pages
cd ../
