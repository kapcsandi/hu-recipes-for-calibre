#!/bin/bash

usage()
{
cat << EOF
Usage: $0 -r my.recipe [-m] [-p]

This script converts the supplied recipe to ebook format(s).
The recipe file should be named like "desired_name.recipe".

If -m or -p is specified, only the desired output will be generated.
The default is: both.

OPTIONS:
   -h      Show this message
   -r      Recipe file (like "-r my.recipe". 
   -m      Mobi output will be generated
   -p      PDF output will be generated
EOF
}

RECIPE=
MOBI=0
PDF=0
while getopts “hr:mp” OPTION
do
     case "${OPTION}" in
         h)
             usage
             exit 1
             ;;
         r)
             RECIPE="${OPTARG}"
             ;;
         m)
             MOBI=1
             ;;
         p)
             PDF=1
             ;;
         ?)
             usage
             exit 1
             ;;
     esac
done

[[ -z "${RECIPE}" || ! -f "${RECIPE}" || ! -r "${RECIPE}" || ! -s "${RECIPE}" ]] && \
    { usage ; exit 1 ; }

[[ ${MOBI} -eq 0 && ${PDF} -eq 0 ]] && { MOBI=1 ; PDF=1 ; }   

RECIPE_NAME=`basename "${RECIPE}" .recipe`

[[ ${MOBI} -eq 1 ]] && \
ebook-convert "${RECIPE}" "${RECIPE_NAME}.mobi" \
 --output-profile kindle \
 --smarten-punctuation \
 --change-justification justify \
 --comments "Élet és Irodalom" \
 --title "Élet és Irodalom" \
 -vv \
 --debug-pipeline debugdir/mobi \
 | tee mobidebug.log

[[ ${PDF} -eq 1 ]] && \
ebook-convert "${RECIPE}" "${RECIPE_NAME}.pdf" \
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
 --debug-pipeline debugdir/pdf \
 | tee pdfdebug.log
