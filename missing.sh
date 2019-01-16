#!/usr/bin/env bash

# Find utils needed
if ! [ -x "$(command -v jq)" ]; then
  echo 'Error: jq is not installed.' >&2
  exit 1
fi

# Parse command arguments
while getopts p:l:h: opt; do
    case $opt in
    p)
        SOURCEPATH=$OPTARG
    ;;
    l)
        LANGUAGEFILE=$OPTARG
    ;;
    h)
        echo >&2 "Usage: -p srcpath/ -l lang.json"
        exit 1
    ;;
    *)
        echo >&2 "Usage: -p srcpath/ -l lang.json"
        exit 1
    ;;
  esac
done
shift $((OPTIND - 1))

# Check that args are set
if [ -z "$SOURCEPATH" ]; then
    echo "-p is blank, please set source code path"
    exit 1
fi
if [ -z "$LANGUAGEFILE" ]; then
    echo "-l is blank, please set translation JSON file"
    exit 1
fi


# Get all contexts from language file
GETKEYS='jq -r "keys []"'
CONTEXT=`eval ${GETKEYS} < ${LANGUAGEFILE}`
ALL=()

# Compile all translation terms with context
while read -r key; do
    GETTERM="jq -r \".${key}|keys[]\""
    TERMS=`eval ${GETTERM} < ${LANGUAGEFILE}`
    while read -r term; do
        ALL+=("${key}.${term}")
    done <<< "${TERMS}"
done <<< "${CONTEXT}"

# Search source code tree for term
for term in "${ALL[@]}"; do
    CMD="grep -R \"${term}\" ${SOURCEPATH}"
    foo=`eval ${CMD}`
    if [ $? -eq 1 ]; then
        echo "${term} not found in source tree"
    fi
done
