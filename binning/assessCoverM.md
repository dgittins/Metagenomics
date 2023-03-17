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
	if [ "$dir" == "coassembly_DASTool_bins" ] ; then
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
