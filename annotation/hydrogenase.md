## Hydrogenase workflow

a. Parse out useful information from RPS-BLAST output, e.g., names/accessions of sequences (i.e., column 1) with 'hydrogenase' annotation

```bash
cd /annotation/hydrogenase/

# Use -w option in grep  select only those lines containing matches that form whole words.  The test is that the matching substring must either be at the beginning of the line, or preceded by a non-word constituent character, i.e., " hydrogenase " or "[NiFe]hydrogenase."

for f in ../cdd/*.cdd.blastout
do 
	sample=$(basename $f .cdd.blastout)
	grep -hrw "hydrogenase" ../cdd/${sample}.cdd.blastout | awk '{print $1}' | awk '!seen[$0]++' > ${sample}.cdd.hydrogenase.acc.txt #last command removes duplicate sequence names/accessions
done
```

b. Extract fasta sequences using the sequence name/accession list (cf. https://www.biostars.org/p/319099/)

```bash
for f in ../*_proteins.faa
do 
	sample=$(basename $f _proteins.faa)
	awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' < ../${sample}_proteins.faa | grep -w -A 1 -Ff ${sample}.cdd.hydrogenase.acc.txt --no-group-separator > ${sample}.cdd.hydrogenase.faa #first command converts a multiline fasta to a singleline fasta
done
```

```bash
# Concatenate all hydrogenase sequencess into one file to run through online [HydDB](https://services.birc.au.dk/hyddb/) hydrogenase classifier
$ cat *.cdd.hydrogenase.faa > sample1_all.cdd.hydrogenase.seqs.faa
```

c. Copy local HydDB output to server, then parse squences with hydrogenase annotation

```bash
$ awk '!/NONHYDROGENASE/' sample1_hyddb.results.csv > sample1_hyddb.hydrogenase.acc.txt #write rows without 'NONHYDROGENASE'
$ awk -i inplace -F '";"' '{print $1}' sample1_hyddb.hydrogenase.acc.txt #print everything before the delimeter '";"'
$ sed -i -e s/\"//g sample1_hyddb.hydrogenase.acc.txt #remove quotes added by HydDB
```

d. Extract fasta sequences using the HydDB sequence name/accession list

```bash
for f in ../*_proteins.faa
do 
	sample=$(basename $f _proteins.faa)
	awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' < ../${sample}_proteins.faa | grep -w -A 1 -Ff sample1_hyddb.hydrogenase.acc.txt --no-group-separator > ${sample}.hyddb.hydrogenase.faa #first command converts a multiline fasta to a singleline fasta
done
```
