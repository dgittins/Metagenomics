# Assign taxonomic classifications to bacterial and archaeal genomes

## [GTDB-Tk](https://ecogenomics.github.io/GTDBTk/index.html)

1. Install GTDB-Tk

```bash
$ conda create -n gtdbtk -c conda-forge -c bioconda gtdbtk=2.1.1
$ conda activate gtdbtk

$ python setup.py install
```

\
2. Download and alias the GTDB-Tk reference data

```bash
# Option 1 - download and extract the GTDB-Tk reference data
$ download-db.sh

# Option 2 - alias GTDBTK_DATA_PATH
$ export GTDBTK_DATA_PATH=/home/user/databases/GTDB_R207/release207_v2
```
