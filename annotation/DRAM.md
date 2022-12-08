# Annotating metagenomic assembled genomes

## [DRAM (Distilled and Refined Annotation of Metabolism)](https://github.com/WrightonLabCSU/DRAM)

1. Install DRAM

```bash
$ wget https://raw.githubusercontent.com/shafferm/DRAM/master/environment.yaml

$ conda env create -f environment.yaml -n dram
$ conda activate dram
```

\
2. Download DRAM databases

```bash
$ DRAM-setup.py prepare_databases --output_dir DRAM_data
```

\
3. Navigate to a working directory

```bash
$ cd binning/dastool/
```

\
4. Run Checkm2

```bash
for dir in *_DASTool_bins/
do
	cd "$dir"
	sample=$(echo "$dir" | cut -d\_ -f1) #create a variable of the sample name from the directory name
	mkdir ${sample}_checkm2 #create an output directory
	checkm2 predict --threads 20 --input . -x fa --output-directory ./${sample}_checkm2 #run CheckM2 script
	cd ../
done
```
