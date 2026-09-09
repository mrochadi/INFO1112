#!/bin/bash
if [ $# -eq 0 ]; then
    DIR="$PWD"
elif [ $# -gt 1 ]; then 
    echo -e "usage: more than 1 arg is not allowed.\n"
    exit 2  
elif [ ! -d "$1" ]; then
    echo -e "usage: arg needs to be a directory.\n"
    exit 1
else
    DIR="$1"
fi

highest_error=0
total_error=0

> analysisData.log

for log in $(find "$DIR" -maxdepth 1 -type f -mtime -7 \( -name "*log*" -o -name "*.log" \))
do
    error=$(grep -ci "error" "$log" 2>/dev/null)
    total_error=$((total_error + error))
    if [ $error -gt $highest_error ]; then
        highest_error=$error
        highest_error_file=$log
    fi
    echo -e "******************\nFilename ${log} <No. of errors found = ${error}>" | tee -a "analysisData.log"
done

echo "------------------"

echo -e "Total errors found:${total_error}\nFile with the max_errors: ${highest_error_file}, <error-count:${highest_error}>" | tee "summary.log"

