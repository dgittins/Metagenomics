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
$ cd binning/coverm/
$ ln -s ../../qc/*_pass_*.qc.fastq .
$ ln -s ../drep/drep_out/dereplicated_genomes/*[0-9].fa .
```

\
3. Run CoverM

```bash
for f in *.fa
do
	coverm genome -1 *_pass_1.qc.fastq -2 *_pass_2.qc.fastq -d . -x .fa \
	--min-read-percent-identity 95 \
	--min-read-aligned-percent 75 \
	--min-covered-fraction 0 \
	-m relative_abundance mean trimmed_mean coverage_histogram covered_bases variance length count reads_per_base rpkm \
	-o coverm_out.tsv -t 40
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

$ python coverm.concatenation.py
```
