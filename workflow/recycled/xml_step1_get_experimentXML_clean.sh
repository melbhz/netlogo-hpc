#!/bin/bash
BEHAVIORSPACE_NAME='MainRun' #THIS ASSUME THE NAME IS UNIQUE
NETLOGO_MODEL='/data/gpfs/projects/punim1439/workflow/Test_23Mar/Vic TB Elim Economic Models/VIC JAN/headless.nlogo'
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