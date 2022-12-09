# Annotating metagenomic assembled genomes

## [DRAM (Distilled and Refined Annotation of Metabolism)](https://github.com/WrightonLabCSU/DRAM)

1. Install DRAM

```bash
$ wget https://raw.githubusercontent.com/shafferm/DRAM/master/environment.yaml

$ conda env create -f environment.yaml -n dram
$ conda activate dram
```

\
2. Download DRAM databases

```bash
$ DRAM-setup.py prepare_databases --output_dir DRAM_data
```
