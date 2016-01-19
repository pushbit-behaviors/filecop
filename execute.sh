#!/bin/bash 

echo "Finding problem files"
OUTPUT_JSON="$(filecop --json ${CHANGED_FILES})"

echo ${OUTPUT_JSON} | ruby ../execute.rb 
