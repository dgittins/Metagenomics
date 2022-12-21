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
$ metaerg --create_database PVEBRCSA --database_dir ~/software/singularity/metaerg_database/
```
