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
4. Filter to good qulaity genomes

```bash
# Write all the "quality_report_good.list" files from checkm2 workflow to a single file

for file in /work/ebg_lab/gm/gapp/dgittins/ReservoirMicrobiology/Metagenomes/*/binning/dastool/*_DASTool_bins/*_checkm2/quality_report_good.list; do
    tail -n +2 "$file"
done > all.quality_report_good.list

for file in /work/ebg_lab/gm/gapp/dgittins/ReservoirMicrobiology/Metagenomes/Vigneron2017/binning/metabat2/*_metabat.out/*_checkm2/quality_report_good.list; do
    tail -n +2 "$file"
done >> all.quality_report_good.list


$ cat /work/ebg_lab/gm/gapp/dgittins/ReservoirMicrobiology/Metagenomes/*/binning/dastool/*_DASTool_bins/*_checkm2/quality_report_good.list > all.quality_report_good.list
$ cat /work/ebg_lab/gm/gapp/dgittins/ReservoirMicrobiology/Metagenomes/Vigneron2017/binning/metabat2/*_metabat.out/*_checkm2/quality_report_good.list >> all.quality_report_good.list



