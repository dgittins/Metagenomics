# Download metagenomes from NCBI's Sequence Read Archive (SRA)

1. Download and install SRA Toolkit 

```bash
$ conda create -n sratools -c bioconda sra-tools
$ conda activate sratools
```

2. Create a repository for download sequences

```bash
$ vdb-config -i
```

#Operate the buttons by pressing the letter highlighted in red. Create a repository for download sequences, e.g., "/home/user.name/sradownloads"
