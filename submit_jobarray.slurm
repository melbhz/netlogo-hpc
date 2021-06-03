#!/bin/bash
#SBATCH --nodes=1
#SBATCH --partition snowy 
#SBATCH --qos=covid19
#SBATCH -A punim1439
#SBATCH --time 2:00:00 
#SBATCH --cpus-per-task=8 

#SBATCH --job-name="COVIDModel-Snowy"
#SBATCH --mail-user=jason.thompson@unimelb.edu.au
#SBATCH --mail-type=END

#SBATCH --array=1-100

#The above commands instruct the HPC cluster "Spartan" using directives. The job environment is created using these. While 
#the SBATCH commands are within comments, they are parsed and understood by the HPC. The commands above do the following:
#Creates a job with a single node on partition snowy using special directive "covid19" to get higher priority for the pro-
#-ject punim1439. The job has a maximum time limit of 2 hours with 8 cpus assigned per task. The job has been named "COVID-
#Model-Snowy" and will send an automated email to jason.thompson@unimelb.edu.au

module load java
#module load netlogo/6.2.0-64

BASE_FOLDER='/data/gpfs/projects/punim1439/workflow/Test_24Mar' #REVISE HERE: The base folder is where the slurm file lives
cd $BASE_FOLDER

NETLOGO_SH='/data/gpfs/projects/punim1439/workflow/NetLogo 6.2.0/netlogo-headless-10g.sh'
NETLOGO_MODEL='/data/gpfs/projects/punim1439/workflow/Test_24Mar/COVIDModel-56ccc6ae53f5ec7933443bcaf9bb0ac9cd913c7b/Vic TB Elim Economic Models/VIC JAN/headless.nlogo' #REVISE HERE: The path of *.nlogo file

EXPERIMENT="xmls/exp_${SLURM_ARRAY_TASK_ID}.xml"
TABLE_SUFFIX="_table"

OUTPUT_FOLDER="outputs_snowy"
OUTPUT_TABLE=${OUTPUT_FOLDER}/"${SLURM_ARRAY_TASK_ID}${TABLE_SUFFIX}_${SLURM_ARRAY_TASK_ID}.csv"

mkdir -p ${BASE_FOLDER}/$OUTPUT_FOLDER

echo $OUTPUT_FOLDER

date '+%A %W %Y %X'

"$NETLOGO_SH" \
  --model "$NETLOGO_MODEL" \
  --setup-file "$EXPERIMENT" \
  --table "$OUTPUT_TABLE" \
  --threads 12
  
date '+%A %W %Y %X'
