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

\
5. Create a list of the 'good' / '[medium-quality draft](https://www.nature.com/articles/nbt.3893)' bins (completeness >50%, contamination <10%)
 from the Checkm2 report file
 
```bash
for dir in *_DASTool_bins/*_checkm2/
do
	cd "$dir"
	awk '{ if (($2 > 50) && ($3 < 10)) { print $1} }' quality_report.tsv > quality_report_good.list #create a list of good quality bin names
	sed -e 's/$/.fa/' -i quality_report_good.list #append '.fa' to bin names
	cd ../../
done
```

\
Other useful code:

```bash
# Create a modified Checkm2 report file
$ awk '{ if (NR==1 || ($2 > 50) && ($3 < 10)) { print } }' quality_report.tsv > quality_report_good.tsv #NR==1 means if this is the first record

# Copy good quality bins to a new directory
$ xargs -a quality_report_good.list cp -t ./sample1_goodbins

# Concatenate lists of good bins
$ cd binning/
$ cat dastool/*_DASTool_bins/*_checkm2/quality_report_good.list > dastool_goodbins.list
```

