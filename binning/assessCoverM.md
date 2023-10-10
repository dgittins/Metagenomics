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
	coverm genome -1 *_pass_1.qc.fastq -2 *_pass_2.qc.fastq -d . -x .fa --min-read-percent-identity 95 --min-read-aligned-percent 75  --min-covered-fraction 0 -m relative_abundance mean trimmed_mean coverage_histogram covered_bases variance length count reads_per_base rpkm -o coverm_out.tsv -t 40
done
```

for i in /groups/banfield/sequences/2022/unicom*/raw.d/*clean.PE.1.fastq.gz
do
dir=$(dirname $i)
r2=$(basename $i 1.fastq.gz)2.fastq.gz
sample=$(basename $i _trim_clean.PE.1.fastq.gz)
coverm genome -1 $i -2 ${dir}/${r2} --genome-fasta-directory /groups/banfield/projects/synthetic/cyano_coms/unicom_2021/analysis/unicom2021_annotation/circular_plasmids/unicom2021_Dbay_Inner_A7120_BW_A_idba_concoct_16_POTENTIAL_CIRCULAR_PLASMID/coverm_genomes/ --genome-fasta-extension fasta -o coverm_${sample}.tsv --min-covered-fraction 0 --min-read-percent-identity 95 --min-read-aligned-percent 75 --trim-min 5 --trim-max 95 -m mean trimmed_mean covered_fraction covered_bases variance count rpkm tpm relative_abundance -t 30
done



for dir in *_DASTool_bins/
do
	if [ "$dir" == Christman_DASTool_bins/ ] ; then
              continue;
    	fi
	
	cd "$dir"
	sample=$(echo "$dir" | cut -d\_ -f1)
	
	for f in *.fa
	do
		coverm genome -1 ../../../qc/${sample}_pass_1.qc.fastq -2 ../../../qc/${sample}_pass_2.qc.fastq -d . -x .fa -o ${sample}_coverm.out -t 40
	done
	
	cd ../
done

# update coassembly name
```
