# Download metagenomes from NCBI's Sequence Read Archive (SRA)

1. Download and install SRA Toolkit 

```bash
$ conda create -n sratools -c bioconda sra-tools
$ conda activate sratools
```

2. Create a repository for downloaded sequences (run the command below and operate the buttons in the output screen by pressing the letter highlighted in red - navigate to the 'Cache' then the 'location of user-repository:' and create a repository for download sequences, e.g., '/home/user.name/sradownloads'

```bash
$ vdb-config -i
```

