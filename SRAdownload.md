# Download metagenomes from NCBI's Sequence Read Archive (SRA)

1. Download and install SRA Toolkit 

```bash
$ conda create -n sratools -c bioconda sra-tools
$ conda activate sratools
```

2. **Option 1** - Configure toolkit to download to the current working directory

```bash
$ vdb-config --prefetch-to-cwd
```

2. **Option 2** - Configure toolkit to download to a user repository

Create a repository for downloaded sequences (run the command below and operate the buttons in the output screen by pressing the letter highlighted in red - navigate to the 'Cache' then the 'location of user-repository:' and create a repository for download sequences, e.g., '/home/user.name/sradownloads'

```bash
$ vdb-config -i
```

3. Create a sequence accession list file that contains the SRR accession numbers of the target sequences

```bash
$ less SraAccList.txt

SRR13515396	
SRR13515397	
SRR13515398	
```

4. Use the 'prefetch' tool to download files

```bash
$ prefetch --option-file SraAccList.txt
```

5. Use the 'fastq-dump' or 'fasterq-dump' tool to extract fastq files

```bash
$ mkdir fastq
$ fastq-dump --outdir fastq --gzip --skip-technical --readids --read-filter pass --dumpbase --split-3 --clip *.sra #command can be run on multiple .sra files
$ fasterq-dump --outdir ./fastq --threads 20 *.sra #command can be multithreaded, but not run on multiple .sra files
```

Commands to reduce stored data volume

```bash
$ gzip ./*.fastq #compress fastq files
$ rm *.sra #remove sra files
```
