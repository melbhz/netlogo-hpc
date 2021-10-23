#!/bin/bash
BEHAVIORSPACE_NAME='HPC_Experiment' #REVISE HERE
NETLOGO_MODEL='/data/gpfs/projects/punim1439/workflow/netlogo_hpc/Wolf_Sheep_Predation/Wolf Sheep Predation HPC.nlogo' #REVISE HERE
declare -a SPLIT_BY_VARIABLES=("wolf-gain-from-food" "wolf-reproduce") #REVISE HERE: variable(s) to use to split experiment


#1. creating an experiment setup-file - Experiment.xml for NetLogo running in headless mode
function CreateExperimentXML ()
{
    local BEHAVIORSPACE_NAME=$1
    local NETLOGO_MODEL=$2
    local OUTPUT_FILE=$3
    
    echo '<?xml version="1.0" encoding="UTF-8"?>' > "$OUTPUT_FILE"
    echo '<!DOCTYPE experiments SYSTEM "behaviorspace.dtd">' >> "$OUTPUT_FILE"
    
    echo '<experiments>' >> "$OUTPUT_FILE"
    sed -n -e "/<experiment name=\"$BEHAVIORSPACE_NAME\"/,/<\/experiment>/p" "$NETLOGO_MODEL" >> "$OUTPUT_FILE"
    echo '</experiments>' >> "$OUTPUT_FILE"
    
    echo "$OUTPUT_FILE created!"
}

#####
OUTPUT_FILE='Experiment.xml'
CreateExperimentXML "$BEHAVIORSPACE_NAME" "$NETLOGO_MODEL" "$OUTPUT_FILE"
OUTPUT_DIR='xmls'
mkdir -p $OUTPUT_DIR
echo "move $OUTPUT_FILE to $OUTPUT_DIR"
mv "$OUTPUT_FILE" "$OUTPUT_DIR"

#2. split Experiment.xml by a variable
function CreateXMLbyParameter(){
    local INPUT_FILE=$1
    local OUTPUT_DIR=$2
    local split_by_var=$3
    local n=$4
    
    local XML_HEAD='head.xml'
    local XML_SEED='seed.xml'
    local XML_TAIL='tail.xml'
    local tmp_seedtail_file='tmp_seedtail.txt'
    
    #sed -n -e '/<?xml version="1.0" encoding="UTF-8"?>/,/<enumeratedValueSet variable="repetitions">/p' "$INPUT_FILE" > $XML_HEAD
    #sed '/<?xml version="1.0" encoding="UTF-8"?>/,/<enumeratedValueSet variable="repetitions">/d' "$INPUT_FILE" > $tmp_seedtail_file
    sed -n -e '/<?xml version="1.0" encoding="UTF-8"?>/,/<enumeratedValueSet variable="'"$split_by_var"'">/p' "$INPUT_FILE" > $XML_HEAD
    sed '/<?xml version="1.0" encoding="UTF-8"?>/,/<enumeratedValueSet variable="'"$split_by_var"'">/d' "$INPUT_FILE" > $tmp_seedtail_file
    sed -n -e '/<\/enumeratedValueSet>/,/<\/experiments>/p' "$tmp_seedtail_file" > $XML_TAIL
    sed '/<\/enumeratedValueSet>/,/<\/experiments>/d' "$tmp_seedtail_file" > $XML_SEED
    
    #echo "$XML_HEAD, $XML_SEED, $XML_TAIL created!"
    
    #3. combine files to create exp_[i].xml files where each exp_[i].xml have only one rand_seed value 
    #OUTPUT_DIR='xmls'
    local PREFIX='exp_'
    local FILE_EXTENTION='.xml'
    #mkdir -p $OUTPUT_DIR
    #n=1
    
    while IFS= read -r line || [ -n "$line" ]; do
    #same as: while IFS= read -r line || [[ -n $line ]]; do
    # reading each line
    #cat $XML_HEAD $line $XML_TAIL > xmls/n.xml
    local output=${OUTPUT_DIR}/${PREFIX}$n$FILE_EXTENTION
    cat $XML_HEAD  > $output
    echo "$line" >> $output
    cat $XML_TAIL >> $output
    echo $output
    n=$((n+1))
    done < $XML_SEED
    echo 'in xmls folder created!'
    
    #4. clean temporary files (optional)
    rm "$XML_HEAD" "$XML_SEED" "$XML_TAIL" "$tmp_seedtail_file"
    
    return $n
}

#####
TMP_INPUT_DIR='xmls_input'
#loop over all split_by variables
for var in "${SPLIT_BY_VARIABLES[@]}"
do
   echo "splitting experiment by \"$var\" ..."
   nextn=1
   echo "feed output as input to function"
   mv -v "$OUTPUT_DIR" "$TMP_INPUT_DIR"
   mkdir $OUTPUT_DIR
   for input_file in $TMP_INPUT_DIR/*.xml; do
        echo "spliting $input_file"
        CreateXMLbyParameter "$input_file" "$OUTPUT_DIR" "$var" $nextn
        nextn=$?
   done
   rm -rf "$TMP_INPUT_DIR"
done

total_xmlfiles_created=$((nextn-1))
echo "In total, $total_xmlfiles_created xml files were created in xmls folder."
echo "Remeber to revise your slurm file to use $total_xmlfiles_created in jobarray, i.e., #SBATCH --array=1-$total_xmlfiles_created"
