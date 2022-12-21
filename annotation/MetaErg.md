# Annotating metagenome-assembled genomes (MAGs)

## [MetaErg](https://github.com/kinestetika/MetaErg)

1. Install MetaErg (version 2.3.X)

Commands for installing from Docker using Singularity on a High Performance Computing (HPC) cluster

```bash
$ conda create -n singularity 
$ conda activate singularity
$ conda install -c conda-forge singularity

$ cd ~/software/singularity
$ singularity pull docker://kinestetika/metaerg #first pull attempt did not create the metaerg_latest.sif file - used 'singularity cache clean' and re-ran pull command 
```

\
2. Run the MetaErg singularity container

```bash
$ singularity run ~/software/singularity/metaerg_latest.sif
```

\
3. Download and create MetaErg database

```bash
$ mkdir metaerg_database
$ metaerg --download_database --database_dir ~/software/singularity/metaerg_database/ #requires sufficient memory, ~50 GB
$ metaerg --create_database S --database_dir ~/software/singularity/metaerg_database/
```

\
4. Download signalp (version signalp 6.0 fast) and TMHMM (version tmhmm 2.0c Linux) from https://services.healthtech.dtu.dk/software.php - requires a form to be filled out and a link to each database will be emailed

```bash
$ cd singularity run ~/software/singularity/metaerg_database/

$ wget https://services.healthtech.dtu.dk/download/<number>/signalp-6.0g.fast.tar.gz #update command with emailed software link
$ tar -xvzf signalp-6.0g.fast.tar.gz #extract download
$ rm signalp-6.0g.fast.tar.gz

$ wget https://services.healthtech.dtu.dk/download/<number>/tmhmm-2.0c.Linux.tar.gz #update command with emailed software link
$ tar -xvzf tmhmm-2.0c.Linux.tar.gz #extract download
$ rm tmhmm-2.0c.Linux.tar.gz
```