# Assess genome bin quality

## [CheckM2](https://github.com/chklovski/CheckM2)

1. Install CheckM2

```bash
$ git clone --recursive https://github.com/chklovski/checkm2.git && cd checkm2

$ conda env create -n checkm2 -f checkm2.yml
$ conda activate checkm2

$ python setup.py install
```

\
2. Download and install the external DIAMOND database

```bash
# Option 1 - install it into your default /home/user/databases directory
$ checkm2 database --download

# Option 2 - set database location using an existing install
$ checkm2 database --setdblocation /home/user/databases/checkm2/CheckM2_database/uniref100.KO.1.dmnd
```

\
3. Run Checkm2

```bash
for dir in *_DASTool_bins/
do
	cd "$dir"
	sample=$(echo "$dir" | cut -d\_ -f1) #create a variable of the sample name from the directory name
	mkdir ${sample}_checkm2 #create an output directory
	checkm2 predict --threads 30 --input . -x fasta --output-directory ./${sample}_checkm2 #run CheckM2 script
	cd ../
done
```
