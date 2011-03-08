#!/bin/bash
ebook-convert es.recipe es.mobi \
 --output-profile kindle \
 --smarten-punctuation \
 --change-justification justify \
 --comments "Élet e's Irodalom" \
 --title "Élet e's Irodalom" \
 -vv \
 --debug-pipeline mobidebugdir \
 | tee mobidebug.log

ebook-convert es.recipe es.pdf \
 --smarten-punctuation  \
 --change-justification justify \
 --paper-size a4  \
 --pretty-print  \
 --preserve-cover-aspect-ratio  \
 --insert-blank-line  \
 --margin-bottom 72.0  \
 --margin-top 72.0  \
 --margin-left 72.0  \
 --margin-right 72.0  \
 -vv \
 --debug-pipeline pdfdebugdir \
 | tee pdfdebug.log
