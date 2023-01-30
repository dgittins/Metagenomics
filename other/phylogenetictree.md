# Align sequences and create a phylogenetic tree

## Align sequences using [MUSCLE](http://www.drive5.com/muscle/muscle_userguide3.8.html)

1. Create a conda environment with MUSCLE installed

```bash
$ conda create -n muscle -c bioconda muscle
$ conda activate muscle
```

\
2. Extract sequences from a hydrogenase subgroup.

```bash
awk '/\[Fe\]/' all_hyddb.results.csv > Fe_hyddb.hydrogenase.acc.txt
awk '/\[FeFe\]/' all_hyddb.results.csv > FeFe_hyddb.hydrogenase.acc.txt
awk '/\[NiFe\]\ Group\ 1/' all_hyddb.results.csv > NiFeGroup1_hyddb.hydrogenase.acc.txt

awk -i inplace -F '";"' '{print $1}' Fe_hyddb.hydrogenase.acc.txt
awk -i inplace -F '";"' '{print $1}' FeFe_hyddb.hydrogenase.acc.txt
awk -i inplace -F '";"' '{print $1}' NiFeGroup1_hyddb.hydrogenase.acc.txt

sed -i -e s/\"//g Fe_hyddb.hydrogenase.acc.txt
sed -i -e s/\"//g FeFe_hyddb.hydrogenase.acc.txt
sed -i -e s/\"//g NiFeGroup1_hyddb.hydrogenase.acc.txt

cat ../goodMAGs/*_proteins.faa | awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' | grep -w -A 1 -Ff Fe_hyddb.hydrogenase.acc.txt --no-group-separator > Fe_hyddb.hydrogenase.faa
cat ../goodMAGs/*_proteins.faa | awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' | grep -w -A 1 -Ff FeFe_hyddb.hydrogenase.acc.txt --no-group-separator > FeFe_hyddb.hydrogenase.faa
cat ../goodMAGs/*_proteins.faa | awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' | grep -w -A 1 -Ff NiFeGroup1_hyddb.hydrogenase.acc.txt --no-group-separator > NiFeGroup1_hyddb.hydrogenase.faa
```
