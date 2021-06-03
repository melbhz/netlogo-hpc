#!/bin/bash
BEHAVIORSPACE_NAME='MainRun' #REVISE HERE (THIS ASSUME THE NAME IS UNIQUE)
NETLOGO_MODEL='/data/gpfs/projects/punim1439/workflow/Test_23Mar/Vic TB Elim Economic Models/VIC JAN/headless.nlogo' #REVISE HERE
OUTPUT_FILE='Experiment_auto.xml'

#<?xml version="1.0" encoding="UTF-8"?>
#<!DOCTYPE experiments SYSTEM "behaviorspace.dtd">
echo '<?xml version="1.0" encoding="UTF-8"?>' > $OUTPUT_FILE
echo '<!DOCTYPE experiments SYSTEM "behaviorspace.dtd">' >> $OUTPUT_FILE

echo '<experiments>' >> $OUTPUT_FILE
sed -n -e "/<experiment name=\"$BEHAVIORSPACE_NAME\"/,/<\/experiment>/p" "$NETLOGO_MODEL" >> $OUTPUT_FILE
echo '</experiments>' >> $OUTPUT_FILE

echo "$OUTPUT_FILE created!"
#echo 'done!'




XML_HEAD='head.xml'
XML_SEED='seed.xml'
XML_TAIL='tail.xml'
tmp_seedtail_file='tmp_seedtail.txt'

sed -n -e '/<?xml version="1.0" encoding="UTF-8"?>/,/<enumeratedValueSet variable="rand_seed">/p' "$OUTPUT_FILE" > $XML_HEAD
sed '/<?xml version="1.0" encoding="UTF-8"?>/,/<enumeratedValueSet variable="rand_seed">/d' "$OUTPUT_FILE" > $tmp_seedtail_file

sed -n -e '/<\/enumeratedValueSet>/,/<\/experiments>/p' "$tmp_seedtail_file" > $XML_TAIL
sed '/<\/enumeratedValueSet>/,/<\/experiments>/d' "$tmp_seedtail_file" > $XML_SEED

echo "$XML_HEAD, $XML_SEED, $XML_TAIL created!"




#XML_HEAD='head.xml'
#XML_SEED='seed.xml'
#XML_TAIL='tail.xml'
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
echo 'in the xmls folder created!'
