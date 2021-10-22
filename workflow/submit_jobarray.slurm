#!/bin/bash
#SBATCH --nodes=1
#SBATCH --partition snowy 
#SBATCH --qos=covid19
#SBATCH -A punim1439
#SBATCH --time 2:00:00 
#SBATCH --cpus-per-task=8 

#SBATCH --job-name="wolf_sheep_predation"
#SBATCH --mail-user=jason.thompson@unimelb.edu.au
#SBATCH --mail-type=END

#SBATCH --array=1-100

#The above commands instruct the HPC cluster "Spartan" using directives. The job environment is created using these. While 
#the SBATCH commands are within comments, they are parsed and understood by the HPC. The commands above do the following:
#Creates a job with a single node on partition snowy using special directive "covid19" to get higher priority for the pro-
#-ject punim1439. The job has a maximum time limit of 2 hours with 8 cpus assigned per task. The job has been named "COVID-
#Model-Snowy" and will send an automated email to jason.thompson@unimelb.edu.au when jobs finished. For some partitions, 
#--qos and #SBATCH -A are not necessary and can be deleted. 

module load java

BASE_FOLDER='/data/gpfs/projects/punim1439/workflow/netlogo_hpc/Wolf_Sheep_Predation' #REVISE HERE: The base folder is where the slurm file lives
cd $BASE_FOLDER

NETLOGO_SH='/data/gpfs/projects/punim1439/workflow/netlogo_hpc/NetLogo 6.2.0/netlogo-headless.sh' #REVISE HERE: The path about your NetLogo software
#NETLOGO_SH='/data/gpfs/projects/punim1439/workflow/netlogo_hpc/NetLogo 6.2.0/netlogo-headless-10g.sh' #when run model that requires large memory (refer to README)
NETLOGO_MODEL='/data/gpfs/projects/punim1439/workflow/netlogo_hpc/Wolf_Sheep_Predation/Wolf_Sheep_Predation.nlogo' #REVISE HERE: The path of *.nlogo file
THREADS=8 #REVISE HERE: Same value as cpus-per-task is recommended; 1 to disable parallel runs; slightly larger value may speed up model run.

EXPERIMENT="xmls/exp_${SLURM_ARRAY_TASK_ID}.xml"
TABLE_SUFFIX="_table"

OUTPUT_FOLDER="outputs" #this folder will be created, this is where to see output files
OUTPUT_TABLE=${OUTPUT_FOLDER}/"${SLURM_ARRAY_TASK_ID}${TABLE_SUFFIX}_${SLURM_ARRAY_TASK_ID}.csv"

mkdir -p ${BASE_FOLDER}/$OUTPUT_FOLDER

echo "output folder: $OUTPUT_FOLDER"

#date '+%A %W %Y %X'
starttime=$(date '+%d/%m/%Y %H:%M:%S')
echo "job ${SLURM_JOBID}_${SLURM_ARRAY_TASK_ID} started  at $starttime"

"$NETLOGO_SH" \
  --model "$NETLOGO_MODEL" \
  --setup-file "$EXPERIMENT" \
  --table "$OUTPUT_TABLE" \
  --threads $THREADS

#date '+%A %W %Y %X'
endtime=$(date '+%d/%m/%Y %H:%M:%S')
echo "job ${SLURM_JOBID}_${SLURM_ARRAY_TASK_ID} finished at $endtime"

