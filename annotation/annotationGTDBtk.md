# Assign taxonomic classifications to bacterial and archaeal genomes

## [GTDB-Tk](https://ecogenomics.github.io/GTDBTk/index.html)

1. Install GTDB-Tk (mamba is much quicker than conda)

```bash
$ mamba create -n gtdbtk -c conda-forge -c bioconda gtdbtk=2.3.0

$ mamba create -n gtdbtk -c conda-forge -c bioconda gtdbtk=2.1.1
$ conda activate gtdbtk
```

\
2. Download and alias the GTDB-Tk reference data

```bash
# Option 1 - download and extract the GTDB-Tk reference data
$ download-db.sh

# Option 2 - create a link (alias) to a directory containing GTDB-Tk reference data
$ conda env config vars set GTDBTK_DATA_PATH=/home/user/databases/GTDB_R214/

# check install
$ gtdbtk check_install
```

\
3. Navigate to a working directory

```bash
$ cd binning/dastool/
```

\
4. Run GTDB-Tk

```bash
for dir in *_DASTool_bins/
do
        cd "$dir"
        sample=$(echo "$dir" | cut -d\_ -f1) #create a variable of the sample name from the directory name
        mkdir ${sample}_gtdbtk #create an output directory
        gtdbtk classify_wf --genome_dir . --out_dir ${sample}_gtdbtk/ -x fa --mash_db mash_out/ --cpus 20 #run GTDB-Tk classify workflow script
        cd ../
done
```
