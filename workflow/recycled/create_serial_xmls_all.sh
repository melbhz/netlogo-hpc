#!/bin/bash
XML_HEAD='exp_head.xml'
XML_SEED='exp_seed.xml'
XML_TAIL='exp_tail.xml'
OUTPUT_DIR='xmls_serial_all'
PREFIX='num_of_seeds_'
FILE_EXTENTION='.xml'

mkdir -p $OUTPUT_DIR

TMP_FOLDER='tmpfiles'
mkdir -p $TMP_FOLDER

echo "head: $XML_HEAD"
echo "tail: $XML_TAIL"
echo "seed: $XML_SEED"

echo "num_of_seeds in list:"
for n in 1 4 8 16 24 32 40 48 56 64 72 80 88 96 100
do
 echo "$((i++)): $n"
 tmpfile="${TMP_FOLDER}/tmpfile_$n.txt"
 head -n $n $XML_SEED > $tmpfile
 #echo "The head $n seeds are:"
 #cat $tmpfile

 output=${OUTPUT_DIR}/${PREFIX}$n$FILE_EXTENTION
 cat $XML_HEAD  > $output
 cat $tmpfile >> $output
 cat $XML_TAIL >> $output

 echo "$output created!" 
 
done

echo "temporary files in folder $TMP_FOLDER for your reference, and can all be deleted."
