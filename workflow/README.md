[TOC]

# Get Started

## Summary

---

The main idea is to run NetLogo's [BehavorSpace](http://ccl.northwestern.edu/netlogo/docs/behaviorspace.html#advanced) in ["headless" mode](http://ccl.northwestern.edu/netlogo/docs/behaviorspace.html#running-from-the-command-line). Experiments in BehaviorSpace is split into a number of separate simulations, each of which is submitted to HPC as a separate job and run in parallel.

---

Four steps are required to run NetLogo models on HPC:

1. Install an [SSH](https://en.wikipedia.org/wiki/Secure_Shell) client to connect HPC (For Mac OS users, this is not required).
2. Download NetLogo software and unzip it to your project directory on HPC.
3. Add an experiment in the BahaviorSpace of your NetLogo model.
4. Make a copy of the templates in this repository, revise and run your model.

Steps 1 and 2 are to set up work environment, and are only need to be done once.

## Set Environment

### Install SSH Client on Your PC

This part is only required for Windows users. Mac (OS X) already has an SSH client built-in, so Mac users can skip this step.

1. Install an SSH client such as [PuTTY](http://www.putty.org/), [Bitvise](https://www.bitvise.com/ssh-client-download), or [MobaXTerm](http://mobaxterm.mobatek.net/download-home-edition.html).

   Here we use [Bitvise SSH Client](https://www.bitvise.com/ssh-client-download) as an example.

2. Set up Bitvise SSH client

    - Tab **[Login]**: Set **Host** as `spartan.hpc.unimelb.edu.au` (change here to use the host by your institute), **Port** as `22`, **Username** as your `username`, **Initial method** as `password`, **Password** as your password.
    - Tab **[Options]**: Tick **Open Terminal** and **Open SFTP**.
    
      <img src="image\SSH_Login_.png" width="48%" /> <img src="image\SSH_Options_.png" width="48%" />

3. Save profile

   Click [**Save profile**] on the left panel, so that next time you do not need to type all these settings.

4. Log in Spartan

   Click [**Log in**] button at the bottom, type your password and click [**OK**] to login. This should open a command prompt window and a SFTP window.

   The command prompt is where you type and run your scripts. The SFTP window provides a graphical user interface where you can create/copy/delete files and folders, upload files to Spartan by dragging a file from left to right, and download files to your laptop by dragging files from right to left.

   <p align="center">
      <img src="image\SSH_cmd.PNG" width="55%" />
   </p>
   <p align="center">
      <img src="image\SSH_SFTP_.PNG" width="55%" />
   </p>
   
### Download NetLogo to HPC

In this example, we download NetLogo to this folder `/data/gpfs/projects/punim1439/workflow/netlogo_hpc`. In SFTP window, right click mouse and Create Folder `netlogo_hpc`. 

Then, in command line, 

1. Run 

    ```shell
    cd /data/gpfs/projects/punim1439/workflow/netlogo_hpc
    ```

    to change current directory to `/data/gpfs/projects/punim1439/workflow/netlogo_hpc`. 

2. Run

    ```shell
    wget https://ccl.northwestern.edu/netlogo/6.2.0/NetLogo-6.2.0-64.tgz
    ```

    to download NetLogo installation file to current directory.

3. Run

    ```shell
    tar -xzf NetLogo-6.2.0-64.tgz
    ```

    to install (unzip) NetLogo to current directory. 

    Click **Refresh**, and you should be able to see the NetLogo 6.2.0 folder. 

    <p align="center">
      <img src="image\SSH_NetLogo_.PNG" width="60%" />
    </p>

    **:bulb:Tips**: 

    * Copy and paste in command prompt: **Right Click** mouse:computer_mouse: in command prompt to paste content from clipboard.
    * Press up arrow key:arrow_up: and down arrow key :arrow_down: in keyboard to recall command history.

## Run Experiment

### Set Model BahaviorSpace

1. We used a `Wolf_Sheep_Predation.nlogo` model as an example.

   This model is adjusted on top of a NetLogo sample model `NetLogo 6.2.0/app/models/Sample Models/Biology/Wolf Sheep Predation.nlogo`. We created an `HPC_Experiment` in the BahaviorSpace, added a global variable `repetitions` with 100 values, and removed `user-message "The sheep have inherited the earth"`. 
   
   <p align="center">
      <img src="image\NetLogo_BehaviorSpace_.PNG" width="50%" />
   </p>

2. Upload `Wolf_Sheep_Predation.nlogo`, `create_xmls.sh` and `submit_jobarray.slurm` to HPC folder.

    <p align="center">
      <img src="image\SSH_Wolf_Sheep_HPC_.PNG" width="58%" />
    </p>

    **:bulb:Tips**: 

    If your model is on GitHub, clone the repo (for example `https://github.com/JTHooker/COVIDModel`) directly to HPC using:

    ```shell
    git clone https://github.com/JTHooker/COVIDModel
    ```

### Revise and Run `create_xmls.sh`

1. Edit `create_xmls.sh` (using text editor notepad++, notepad, etc)

    - BEHAVIORSPACE_NAME=`'HPC_Experiment'`
    - NETLOGO_MODEL=`'/data/gpfs/projects/punim1439/workflow/netlogo_hpc/Wolf_Sheep_Predation/Wolf_Sheep_Predation.nlogo'`

2. End of Line (EOL) Conversion

   From Bitvise command line, change directory to `Wolf_Sheep_Predation`: 

   ```shell
   cd /data/gpfs/projects/punim1439/workflow/netlogo_hpc/Wolf_Sheep_Predation
   ```

   Then, run

   ```shell
   sed -i.bak 's/\r$//g' create_xmls.sh
   ```

   to convert Windows (CR LF) line ending to Unix (LF)

3. Run `bash create_xmls.sh`

   From Bitvise command line, run 

    ```shell
    bash create_xmls.sh
    ```

    to create xmls folder and 100 xml files under this folder.

    **:bulb:Tips**: 

   MS-Windows to Unix like operation systems are using different End of Line (EOL). 

   If you want to see line ending in Notepad++, click menu **View > Show Symbol > Show All Characters**, then you will see Windows has line ending with invisible characters **CRLF**, while Unix has **LF**. Click menu **Edit > EOL Conversion > Unix (LF)** to convert MS-Windows to Unix EOL, as HPC is using Unix like operation systems.

   Command `sed -i.bak 's/\r$//g' create_xmls.sh` did the same thing, using string editor to convert EOL of `create_xmls.sh` to Unix removing all **CR**, and the original file is backed up as `submit_jobarray.slurm.bak`.

### Revise and Run `submit_jobarray.slurm`

1. Edit `submit_jobarray.slurm` (using text editor notepad++, notepad, etc).

      - `#SBATCH` are script directive for Spartan. This script creates a job array of **100** jobs. Each job requires **1** computer node and **8** CPU cores on **snowy** cluster for a maximum wall time of **2** hours. When all jobs are ended, an email notification will be sent to –mail-user. In `#SBATCH` directive, `--qos`, `-A`, `--job-name`, `--mail-user`, `--mail-type` are optional, and can be deleted.
      - `BASE_FOLDER`: current directory of `submit_jobarray.slurm`, and the upper directory of `xmls` folder.
      - `NETLOGO_SH`: file path of `netlogo-headless.sh` under NetLogo 6.2.0 directory.
      - `NETLOGO_MODEL`: file path of `Wolf_Sheep_Predation.nlogo`
      - `OUTPUT_FOLDER`: name of output folder.

2. End of Line (EOL) Conversion

   From Bitvise command line, run

    ```shell
    sed -i.bak 's/\r$//g' submit_jobarray.slurm
    ```

3. Run `sbatch submit_jobarray.slurm`

    ```shell
    sbatch submit_jobarray.slurm
    ```

    to submit 100 jobs to Spartan. You will receive an email when the computation ends.

    **:bulb:Tips**: 

    - Run `squeue -u yourusername` to see current jobs, replacing `yourusername` with your username.
    - Check log files `slurm-jobid_taskid.out` in `Wolf_Sheep_Predation` folder for any error.
    - Run `scancel -n wolf_sheep_predation` to cancel a job, replacing `wolf_sheep_predation` with the value after `SBATCH --job-name=` (file `submit_jobarray.slurm`).
    - Run `spartan-weather` to see usage of all partitions (optional).
    - Run `clear` to clear screen.
    - Run `exit` to quite command line.

4. Move all slurm_\*.out files to slurm folder (optional)

    When all jobs finished, run 

    ```shell
    cd /data/gpfs/projects/punim1439/workflow/netlogo_hpc/Wolf_Sheep_Predation
    mkdir -p slurms
    mv ./slurm-*.out ./slurms/
    ```

    to create a folder slurms, and move all slurm-*.out files to slurms folder. 

### Merge CSV Results

```shell
cd /data/gpfs/projects/punim1439/workflow/netlogo_hpc/Wolf_Sheep_Predation/outputs

awk '(NR < 8) || (FNR > 7)' *_table_*.csv > MergedResults.csv
```

This will create a file `MergedResults.csv` as the final output file.

## Other Notes

1. `cd`

   Change directory command is to avoid always typing the absolute path when running script files.

    ```shell
    cd /data/gpfs/projects/punim1439/workflow/netlogo_hpc/Wolf_Sheep_Predation

    bash create_xmls.sh

    sbatch submit_jobarray.slurm

    cd outputs
    awk '(NR < 8) || (FNR > 7)' *_table_*.csv > MergedResults.csv
    ```
    is the same as using
    ```shell
    bash /data/gpfs/projects/punim1439/workflow/netlogo_hpc/Wolf_Sheep_Predation/create_xmls.sh

    sbatch /data/gpfs/projects/punim1439/workflow/netlogo_hpc/Wolf_Sheep_Predation/submit_jobarray.slurm

    awk '(NR < 8) || (FNR > 7)' /data/gpfs/projects/punim1439/workflow/netlogo_hpc/Wolf_Sheep_Predation/outputs/*_table_*.csv > /data/gpfs/projects/punim1439/workflow/netlogo_hpc/Wolf_Sheep_Predation/outputs/MergedResults.csv
    ```

2. In command prompt, put file path or directory path in `“ ”` if filename includes space, for example

    ```shell
    cd “/data/gpfs/projects/punim1439/workflow/netlogo_hpc/NetLogo 6.2.0”
    ```

3. Bitvise

   Click **[New terminal console]** to open a new command window. Click **[New SFTP window]** to open a new SFTP window. Set the **Initial directory** in Tab **[SFTP]** and Save profile, to specify initial directories for your new SFTP windows.

   <p align="center">
      <img src="image\SSH_Tips_.PNG" width="48%" />
   </p>

4. NetLogo RAM

    To run models that require large memory, you need to change NetLogo's RAM of Java virtual machine (JVM).

    - Make a copy of netlogo-headless.sh (e.g. netlogo-headless-10g.sh)

    ```shell
    cd "/data/gpfs/projects/punim1439/workflow/netlogo_hpc/NetLogo 6.2.0"
    cp netlogo-headless.sh netlogo-headless-10g.sh
    ```

    - Edit `netlogo-headless-10g.sh`: Line 15, Change **-Xmx10240m** to **-Xmx10g** to increase 1GB RAM to 10GB RAM.

    ```  bash
    JVM_OPTS=(-Xmx10g -XX:+UseParallelGC -Dfile.encoding=UTF-8)  
    ```

    > Notes: You can either edit `netlogo-headless-10g.sh` using any text editors, or edit in line on command prompt by running

    ```shell
    nano netlogo-headless-10g.sh  
    ```

    After editing, press Ctrl + X to exit, type Y to save changes, then press Enter to overwrite file.

5. NetLogo extensions

    If your model requires an extension which is not a default extention of NetLogo software, the extension should be copied to the same folder of the NetLogo model or can be placed in the extension’s folder in the NetLogo extensions directory. Refer [here](https://ccl.northwestern.edu/netlogo/docs/extensions.html) for where to find extensions. 

    For example, we can copy `rngs` folder from `C:\Program Files\NetLogo 6.2.0\app\extensions\.bundled\rngs` on our laptop to `/data/gpfs/projects/punim1439/workflow/netlogo_hpc/NetLogo 6.2.0/app/extensions/.bundled/rngs` on HPC.

6. Single run

    If your experiment only has **one run** that cannot be split (Note the `HPC_Experiment` of `Wolf_Sheep_Predation.nlogo` has 100 runs), or you just want to run your model by submitting one job to HPC, then you can simply save the following script as `submit_single_job.slurm` (:information_source:use Unix EOL), and run 
    
    ```
    sbatch submit_single_job.slurm
    ```
    
     after you [Set Model BahaviorSpace](#set-model-bahaviorspace) You do not need to run [Revise and Run `create_xmls.sh`](#revise-and-run-createxmlssh), [Revise and Run `submit_jobarray.slurm`](#revise-and-run-submitjobarrayslurm) and [Merge CSV Results](#merge-csv-results). 
    
    ```bash
    # -- file submit_single_job.slurm --
    #!/bin/bash
    #SBATCH --nodes=1
    #SBATCH --partition interactive 
    #SBATCH --time 1:00:00 
    #SBATCH --cpus-per-task=8 
    
    module load java
    cd "/data/gpfs/projects/punim1439/workflow/netlogo_hpc/Wolf_Sheep_Predation"
    "/data/gpfs/projects/punim1439/workflow/netlogo_hpc/NetLogo 6.2.0/netlogo-headless.sh" \
      --model "Wolf_Sheep_Predation.nlogo" \
      --experiment "HPC_Experiment" \
      --table "output_file.csv"
    ```
    
    You can also run NetLogo headless mode on Windows PC (if JAVA_HOME has been set or system PATH has included java.exe), using
    ```bash
    cd "C:\Users\zhahz\Desktop\netlogo_hpc"
    "C:\Program Files\NetLogo 6.2.0\netlogo-headless.bat" ^
      --model "Wolf_Sheep_Predation.nlogo" ^
      --experiment "HPC_Experiment" ^
      --table "output_file.csv"
    ```
    
# Cheat Sheet

```shell
# change work directory
cd /data/gpfs/projects/punim1439/workflow/netlogo_hpc/Wolf_Sheep_Predation

# create experiments
sed -i.bak 's/\r$//g' create_xmls.sh
bash create_xmls.sh

# check which partition has more available CPUs
spartan-weather

# submit jobs
sed -i.bak 's/\r$//g' submit_jobarray.slurm
sbatch submit_jobarray.slurm

# check job status
squeue -u yourusername

# clean log files
mkdir slurms
mv ./slurm-*.out ./slurms/

# merge results
cd outputs
awk '(NR < 8) || (FNR > 7)' *_table_*.csv > MergedResults.csv

# cancel job
scancel -n wolf_sheep_predation
```