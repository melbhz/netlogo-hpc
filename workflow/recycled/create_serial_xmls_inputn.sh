#!/bin/bash
XML_HEAD='exp_head.xml'
XML_SEED='exp_seed.xml'
XML_TAIL='exp_tail.xml'
OUTPUT_DIR='xmls_serial'
PREFIX='num_of_seeds_'
FILE_EXTENTION='.xml'

mkdir -p $OUTPUT_DIR
#n = $1
tmpfile='tmpfile.txt'

echo "head: $XML_HEAD"
echo "tail: $XML_TAIL"
echo "seed: $XML_SEED"

echo "Enter the number of seeds to extract from $XML_SEED:"
read n
head -n $n $XML_SEED > $tmpfile
echo "The head $n seeds are:"
cat $tmpfile

output=${OUTPUT_DIR}/${PREFIX}$n$FILE_EXTENTION
cat $XML_HEAD  > $output
cat $tmpfile >> $output
cat $XML_TAIL >> $output

echo "$output created!"