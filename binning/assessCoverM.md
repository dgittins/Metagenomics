# Assess genome read coverage and relative abundance

## [CoverM](https://github.com/wwood/CoverM)

Run on dereplicated genomes only, otherwise read mappers will be confused as to which of two very similar genomes a read maps to.

1. Install CoverM

```bash
$ conda create -n coverm -c bioconda coverm
$ conda activate coverm
```

\
2. Navigate to a working directory and create links to reads

```bash
$ cd binning/coverm/

# Create link to read files
$ ln -s ../../qc/*.qc.fastq .

# Create a link to 'good quality' (-> checkm2), representative (-> dRep) genomes
while IFS= read -r filename; do
    ln -s -f "../drep/drep_out/dereplicated_genomes/$filename" ./
done < ../dastool_drep_goodbins.list

# Check file counts
$ ls *.fa | wc -l
16
$ wc -l ../dastool_drep_goodbins.list
16 ../dastool_drep_goodbins.list
```

\
3. Run CoverM

```bash
for f in *_pass_1.fastq.gz
do
	sample=$(basename $f _pass_1.fastq.gz)
	coverm genome -1 ${sample}_pass_1.fastq.gz -2 ${sample}_pass_2.fastq.gz -d . -x .fa -p --min-read-percent-identity 95 --min-read-aligned-percent 75 --min-covered-fraction 0 -m relative_abundance mean trimmed_mean covered_bases variance length count reads_per_base rpkm -o ${sample}.coverm_out.tsv -t 40
done
```

\
4. Concatenate CoverM outputs based on relative abundance

```bash
$ emacs coverm.concatenation.py

import pandas as pd
import glob

files = glob.glob('./*.tsv')

# Read the first file and select the first two columns
df_result = pd.read_csv(files[0], sep='\t', usecols=[0, 1])

# Iterate over the rest of the files and merge the second column
for f in files[1:]:
    # Read the file and select the second column
    df = pd.read_csv(f, sep='\t', usecols=[1])
    # Concatenate the selected column to the result dataframe
    df_result = pd.concat([df_result, df], axis=1)

df_result.to_csv("all.abundance.coverm_out.tsv", sep='\t', index=False)


$ conda activate python

$ python coverm.concatenation.py
```
