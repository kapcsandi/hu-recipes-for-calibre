#!/bin/bash

usage()
{
cat << EOF
Usage: $0 -r my.recipe [-m] [-p] [-R] [-t "Title"]

This script converts the supplied recipe to ebook format(s).
The recipe file should be named like "desired_name.recipe".

If -m or -p is specified, only the desired output will be generated.
The default is: both.

The -t option is a must if you are generating Mobi files. If you're 
not specifying it, the recipe name will be used.

OPTIONS:
   -h      Show this message
   -r      Recipe file (like "-r my.recipe". 
   -t      Recipe title (string, e.g. "-t 'Élet és Irodalom'")
   -m      Mobi output will be generated
   -p      PDF output will be generated
   -R      RTF output will be generated
EOF
}

chk_conv_source () {
    if [[ -s debugdir/${RECIPE_NAME}/processed/index.html ]] ; then
        export FROMHTM=debugdir/${RECIPE_NAME}/processed/index.html
    else
        export FROMHTM=${RECIPE}
    fi
}

RECIPE=
TITLE=
MOBI=0
PDF=0
RTF=0
while getopts “hr:t:mpR” OPTION
do
     case "${OPTION}" in
         h)
             usage
             exit 1
             ;;
         r)
             RECIPE="${OPTARG}"
             ;;
         t)
             TITLE="${OPTARG}"
             ;;
         m)
             MOBI=1
             ;;
         p)
             PDF=1
             ;;
         R)
             RTF=1
             ;;
         ?)
             usage
             exit 1
             ;;
     esac
done

[[ -z "${RECIPE}" || ! -f "${RECIPE}" || ! -r "${RECIPE}" || ! -s "${RECIPE}" ]] && \
    { usage ; exit 1 ; }

[[ ${MOBI} -eq 0 && ${PDF} -eq 0 && ${RTF} -eq 0 ]] && { MOBI=1 ; PDF=1 ; RTF=1 ; }   

[[ -z "${TITLE}" ]] && TITLE="${RECIPE}"

RECIPE_NAME=`basename "${RECIPE}" .recipe`

chk_conv_source && \
[[ ${MOBI} -eq 1 ]] && \
ebook-convert "${RECIPE}" "${RECIPE_NAME}.mobi" \
 --output-profile kindle \
 --smarten-punctuation \
 --change-justification justify \
 --comments "${TITLE}" \
 --title "${TITLE}" \
 -v \
 --debug-pipeline debugdir/${RECIPE_NAME} \
 | tee debugdir/mobidebug.log


chk_conv_source && \
[[ ${PDF} -eq 1 ]] && \
ebook-convert "${FROMHTM}" "${RECIPE_NAME}.pdf" \
 --smarten-punctuation  \
 --change-justification justify \
 --extra-css 'body { background-color: white; color: black; }' \
 --paper-size a4  \
 --pretty-print  \
 --preserve-cover-aspect-ratio \
 --insert-blank-line  \
 --margin-bottom 72.0  \
 --margin-top 72.0  \
 --margin-left 72.0  \
 --margin-right 72.0  \
 -v \
 | tee debugdir/pdfdebug.log

chk_conv_source && \
[[ ${RTF} -eq 1 ]] && \
ebook-convert ${FROMHTM} "${RECIPE_NAME}.rtf" \
     --pretty-print \
     --smarten-punctuation \
     --change-justification justify \
     --extra-css 'body { background-color: white; color: black; }' \
     --insert-blank-line \
     -v \
     | tee debugdir/pdfdebug.log

