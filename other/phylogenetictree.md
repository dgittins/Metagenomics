# Align sequences and create a phylogenetic tree

## Align sequences using [MUSCLE](http://www.drive5.com/muscle/muscle_userguide3.8.html)
## Create a phylogenetic tree using [RAxML Next Generation](https://github.com/amkozlov/raxml-ng) 

1. Create a conda environment with MUSCLE installed

```bash
$ conda create -n muscle -c bioconda muscle
$ conda activate muscle
```

\
2. Extract sequences from a hydrogenase group

```bash
#parse hydDB results according to hydrogenase group
$ awk '/\[Fe\]/' all_hyddb.results.csv > Fe_hyddb.hydrogenase.acc.txt
$ awk '/\[FeFe\]/' all_hyddb.results.csv > FeFe_hyddb.hydrogenase.acc.txt
$ awk '/\[NiFe\]\ Group\ 1/' all_hyddb.results.csv > NiFeGroup1_hyddb.hydrogenase.acc.txt
$ awk '/\[NiFe\]\ Group\ 2/' all_hyddb.results.csv > NiFeGroup2_hyddb.hydrogenase.acc.txt
...

#subset parsed hydDB results to only the sequence name
$ awk -i inplace -F '";"' '{print $1}' Fe_hyddb.hydrogenase.acc.txt
$ awk -i inplace -F '";"' '{print $1}' FeFe_hyddb.hydrogenase.acc.txt
$ awk -i inplace -F '";"' '{print $1}' NiFeGroup1_hyddb.hydrogenase.acc.txt
$ awk -i inplace -F '";"' '{print $1}' NiFeGroup2_hyddb.hydrogenase.acc.txt
...

#remove quotation marks added by hydDB
$ sed -i -e s/\"//g Fe_hyddb.hydrogenase.acc.txt
$ sed -i -e s/\"//g FeFe_hyddb.hydrogenase.acc.txt
$ sed -i -e s/\"//g NiFeGroup1_hyddb.hydrogenase.acc.txt
$ sed -i -e s/\"//g NiFeGroup2_hyddb.hydrogenase.acc.txt
...

#extract sequences according to hydrogeanse group using the sequence list
$ cat ../goodMAGs/*_proteins.faa | awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' | grep -w -A 1 -Ff Fe_hyddb.hydrogenase.acc.txt --no-group-separator > Fe_hyddb.hydrogenase.faa
$ cat ../goodMAGs/*_proteins.faa | awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' | grep -w -A 1 -Ff FeFe_hyddb.hydrogenase.acc.txt --no-group-separator > FeFe_hyddb.hydrogenase.faa
$ cat ../goodMAGs/*_proteins.faa | awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' | grep -w -A 1 -Ff NiFeGroup1_hyddb.hydrogenase.acc.txt --no-group-separator > NiFeGroup1_hyddb.hydrogenase.faa
$ cat ../goodMAGs/*_proteins.faa | awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' | grep -w -A 1 -Ff NiFeGroup2_hyddb.hydrogenase.acc.txt --no-group-separator > NiFeGroup2_hyddb.hydrogenase.faa
...
```

\
3. Download nuoA sequence from [KEGG](https://www.genome.jp/entry/eco:b2288) - https://www.genome.jp/entry/K00330 - to use as an outgroup for hydrogenase trees (nuoA, NADH-quinone oxidoreductase subunit A, shares high sequence identity with many hydrogenases, but is not a hydrogenase) 


\
4. Add nuoA sequence to each hydrogenase sequnce file

\
5. Align sequences using MUSCLE

```bash
#The super5 command uses the Super5 algorithm to align sequences. Super5 is generally used for aligning large sets of sequences where the PPP algorithm (align command) is too slow.
for f in *_hyddb.hydrogenase.faa
do
	sample=$(basename $f _hyddb.hydrogenase.faa)
	muscle -super5 ${sample}_hyddb.hydrogenase.faa -output ${sample}_hyddb.hydrogenase.afaa
done

for f in *_hyddb.hydrogenase.faa
do
	sample=$(basename $f _hyddb.hydrogenase.faa)
	muscle -align ${sample}_hyddb.hydrogenase.faa -output ${sample}_hyddb.hydrogenase.afaa
done
```

\
5. #Rename sequences by removing everything after the first space in the header (RAxML-NG will fail without this step)
```bash
sed '/^>/ s/ .*//' nuoA.fasta > nuoA_rename.fasta
sed '/^>/ s/ .*//' NiFeGroup4_hyddb.hydrogenase.afaa > NiFeGroup4_hyddb.hydrogenase.rename.afaa
sed '/^>/ s/ .*//' NiFeGroup4_hyddb.hydrogenase.afaa > NiFeGroup4_hyddb.hydrogenase.rename.afaa
sed '/^>/ s/ .*//' NiFeGroup4_hyddb.hydrogenase.afaa > NiFeGroup4_hyddb.hydrogenase.rename.afaa
sed '/^>/ s/ .*//' NiFeGroup4_hyddb.hydrogenase.afaa > NiFeGroup4_hyddb.hydrogenase.rename.afaa
...
