#!/bin/bash
#rm -rf debugdir
RECIPE_NAME=`basename "${1}" .recipe`
ebook-convert "${1}" "debugdir/test/${RECIPE_NAME}/" \
 --smarten-punctuation \
 --change-justification justify \
 -vv \
 --debug-pipeline debugdir/test/debug \
 | tee debugdir/debug.log
