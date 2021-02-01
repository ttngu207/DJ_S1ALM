# DataJoint pipeline for S1ALM project

This repository houses the source code for the DataJoint pipeline (in MATLAB), 
processing/analysis code, and data accompanying the following publication:

    <publication>

For users interested in recreate this pipeline, import data and reproduce the analysis results, 
please see the instruction below.

# Initialize the pipeline

Follow the instruction here to:

1. Create a MySQL database server in a Docker container

2. Initialize the DataJoint pipeline (e.g. schemas and tables) in the said database

3. Populate the database with data related to the publication (data published separately as in NWB format)

5. Access the data via DataJoint framework with MATLAB or Python


## Prerequisite

+ Have Docker installed on your computer

+ Have [DataJoint-MATLAB](https://docs.datajoint.io/matlab/setup/01-Install-and-Connect.html) package installed


## Step 1: Clone the repository
Navigate to a new folder directory for this project. Then clone this repository (`publication_ready` branch):
    
    
    git clone --single-branch -b publication_ready https://github.com/arsenyf/DJ_S1ALM
    

Change your working directory to the `DJ_S1ALM` folder


    cd DJ_S1ALM


## Step 2: Setup `dj_local_conf.json`
The provided template configuration file `template_dj_local_conf.json` is sufficient. 
Rename `template_dj_local_conf.json` to `dj_local_conf.json`

(Advanced users are welcome to make any modifications as needed)

## Step 3: Download the NWB files

Create a new folder named ***nwb_data*** in this ***DJ_S1ALM*** working directory 

Download data in NWB format, and place those NWB files in the created ***nwb_data*** folder


## Step 4: Run `docker-compose up`
Build the Docker images (one time)

    docker-compose build

Launch the containers:
    
    docker-compose up
    
When finished, you can stop the containers:

    docker-compose down
    
Note: a new ***db_data*** folder will be created, and the data for MySQL database is stored in this ***db_data*** folder, this folder is persistent.
To resume working with this pipeline, you will only need to `docker-compose up` again


## Step 5: Launch MATLAB and run `init.m`

Ensure ***DJ_S1ALM*** is your "Current Folder"

On the Command Window, run


    init
    
    
## Step 6: Go to Jupyter notebook and explore the data
The password to connect is ***datajoint***

Create any new notebooks in the ***dja*** folder

To connect to the pipeline, see the sample code below
    
    
    import os
    os.chdir('/main')
    
    from:;w:wq!
     :::pipeline_py.nwb_to_datajoint import *
    
    experiment.Session()
    
## Step 6: Go to MATLAB and explore the data

Ensure ***DJ_S1ALM*** is your "Current Folder", and you are ready to connect to the pipeline.
For example, to inspect the Session table, try:

    
    EXP.Session()