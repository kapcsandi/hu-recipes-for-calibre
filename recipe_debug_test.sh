#!/bin/bash
find debugdir -exec rm -rf \{\} \;
RECIPE_NAME=`basename "${1}" .recipe`
ebook-convert "${1}" "debugdir/${RECIPE_NAME}/" \
 --smarten-punctuation \
 --change-justification justify \
 -vv \
 --debug-pipeline debugdir \
 --test \
 | tee debug.log