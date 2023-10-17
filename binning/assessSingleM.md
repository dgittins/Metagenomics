# Profile shotgun metagenomes - estimate the relative abundances of microbial community members

## [SingleM](https://wwood.github.io/singlem/)

Use the relative abundance of single copy marker genes in reads to estimate the relative abudance of communtity members. Compare with CoverM mapped reads to evaluate genome representation. 

1. Install SingleM

```bash
$ conda create -n singlem -c bioconda singlem
$ conda activate singlem
```

\
2. Navigate to a working directory

```bash
$ cd binning/singlem/
```

\
3. Create links to raw illumina reads (not QC reads)

```bash
$ ln -s ../../

\
3. Run Checkm2

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

# Concatenate lists of good bins in each study
$ cd binning/
$ cat dastool/*_DASTool_bins/*_checkm2/quality_report_good.list > dastool_goodbins.list

# Concatenate lists of good bins across all studies
$ cd metagenomes/
$ cat */binning/dastool/*_DASTool_bins/*_checkm2/quality_report_good.list > dastool_goodbins.list

# Count the number of good bins across all studies
$ cd metagenomes/
for f in */binning/dastool_goodbins.list
do
cat "$f" | wc -l
done
```
