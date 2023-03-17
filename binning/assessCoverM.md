# Assess genome read coverage and relative abundance

## [CoverM](https://github.com/wwood/CoverM)

1. Install CoverM

```bash
$ conda create -n coverm -c bioconda coverm
$ conda activate coverm
```

\
2. Navigate to a working directory

```bash
$ cd binning/dastool/
```

\
3. Run CoverM

```bash
for dir in *_DASTool_bins/
do
	cd "$dir"
	sample=$(echo "$dir" | cut -d\_ -f1) #create a variable of the sample name from the directory name
	mkdir ${sample}_coverm #create an output directory
	
	
	
	checkm2 predict --threads 20 --input . -x fa --output-directory ./${sample}_checkm2 #run CheckM2 script
	cd ../
done
```
