#!/bin/bash
XML_HEAD='head.xml'
XML_SEED='seed.xml'
XML_TAIL='tail.xml'
OUTPUT_DIR='xmls'
PREFIX='exp_'
FILE_EXTENTION='.xml'

mkdir -p $OUTPUT_DIR

n=1

while IFS= read -r line || [ -n "$line" ]; do 
#same as: while IFS= read -r line || [[ -n $line ]]; do
# reading each line
#cat $XML_HEAD $line $XML_TAIL > xmls/n.xml
output=${OUTPUT_DIR}/${PREFIX}$n$FILE_EXTENTION
cat $XML_HEAD  > $output
echo "$line" >> $output
cat $XML_TAIL >> $output
echo $output
n=$((n+1))
done < $XML_SEED
echo 'created!'
