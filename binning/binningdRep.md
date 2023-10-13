# de-replicate a genome set - best representative genome

## [dRep](https://github.com/MrOlm/drep)

1. Install dRep

```bash
$ conda create -n dRep -c bioconda dRep
$ conda activate dRep

$ dRep check_dependencies

# 'centrifuge' and 'nsimscan' are not required
```

\
2. Navigate to a working directory and create links to genome bins

```bash
$ cd binning/drep/
$ ln -s ../dastool/*_DASTool_bins/*[0-9].fa .
```

\
3. Run dRep 

```bash
# 10% minumum genome completeness, 25% maximum genome contamination
$ dRep dereplicate drep_out -g *.fa -p 20 -comp 10 -con 25

# ^ run dRep with low completeness to identify all unique genomes, then filter by completeness and contamination to identify good quality bins.
# ^ dRep uses checkm (not checkm2) so the completeness cutoffs may not capture diversity of minimal-genomes CPR and DPANN

# Default - 75% minumum genome completeness, 25% maximum genome contamination
# $ dRep dereplicate drep_out -g *.fa
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
