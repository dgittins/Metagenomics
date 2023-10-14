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
2. Navigate to a working directory and create links to all (no-quality filtered) genome bins

```bash
$ cd binning/drep/
$ ln -s ../dastool/*_DASTool_bins/*.fa .
$ rm unbinned.fa

# Count files (should be equal to total number of DASTool bins)
$ cd Metagenomes/
$ ls ./*/binning/drep/*.fa | wc -l
$ 678
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
4. Identify 'good quality' representative genomes

```bash
$ cd binning/

# 'quality_report_good.list' generated in checkm2 workflow
$ comm -12 <(cat dastool/*_DASTool_bins/*_checkm2/quality_report_good.list | sort) <(find drep/drep_out/dereplicated_genomes/ -name "*.fa" -exec basename {} \; | sort) > dastool_drep_goodbins.list

$ cd Metagenomes/

# Concatenate list of good, representative genomes
$ cat ./*/binning/*drep_goodbins.list > all.dastool_drep_goodbins.list
```
