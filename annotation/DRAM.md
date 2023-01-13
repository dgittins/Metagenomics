# Annotating metagenome-assembled genomes (MAGs)

## [DRAM (Distilled and Refined Annotation of Metabolism)](https://github.com/WrightonLabCSU/DRAM)

1. Install DRAM

```bash
$ cd /home/user.name/software/dram
$ wget https://raw.githubusercontent.com/shafferm/DRAM/master/environment.yaml

$ conda env create -f environment.yaml -n dram
$ conda activate dram

$ DRAM-setup.py version #check version 1.4.3 is installed; required for 2. Option 2 step below
```

\
2. **Option 1** - Download databases and setup DRAM

```bash
$ mkdir /work/lab/ReferenceDatabases/DRAM_data
$ DRAM-setup.py prepare_databases --output_dir /work/lab/ReferenceDatabases/DRAM_data #use --kegg_loc kegg.pep if you have access to KEGG
```

\
2. **Option 2** - Use already downloaded databases and a config file

```bash
$ DRAM-setup.py import_config --config_loc dram.config

$ less dram.config

{
  "search_databases": {
    "kegg": null,
    "kofam_ko_list": "/work/lab/ReferenceDatabases/DRAM_data/kofam_ko_list.tsv",
    "uniref": "/work/lab/ReferenceDatabases/DRAM_data/uniref90.20220122.mmsdb",
    "pfam": "/work/lab/ReferenceDatabases/DRAM_data/pfam.mmspro",
    "dbcan": "/work/lab/ReferenceDatabases/DRAM_data/dbCAN-HMMdb-V9.txt",
    "viral": "/work/lab/ReferenceDatabases/DRAM_data/refseq_viral.20220122.mmsdb",
    "peptidase": "/work/lab/ReferenceDatabases/DRAM_data/peptidases.20220122.mmsdb",
    "vogdb": "/work/lab/ReferenceDatabases/DRAM_data/vog_latest_hmms.txt",
    "kofam_hmm": "/work/lab/ReferenceDatabases/DRAM_data/kofam_profiles.hmm"
  },
  "database_descriptions": {
    "dbcan_fam_activities": "/work/lab/ReferenceDatabases/DRAM_data/CAZyDB.07302020.fam-activities.txt",
    "vog_annotations": "/work/lab/ReferenceDatabases/DRAM_data/vog_annotations_latest.tsv.gz",
    "pfam_hmm": "/work/lab/ReferenceDatabases/DRAM_data/Pfam-A.hmm.dat.gz"
  },
  "dram_sheets": {
    "genome_summary_form": "/work/lab/ReferenceDatabases/DRAM_data/genome_summary_form.20220122.tsv",
    "module_step_form": "/work/lab/ReferenceDatabases/DRAM_data/module_step_form.20220122.tsv",
    "etc_module_database": "/work/lab/ReferenceDatabases/DRAM_data/etc_mdoule_database.20220122.tsv",
    "function_heatmap_form": "/work/lab/ReferenceDatabases/DRAM_data/function_heatmap_form.20220122.tsv",
    "amg_database": "/work/lab/ReferenceDatabases/DRAM_data/amg_database.20220122.tsv"
  },
  "dram_version": "1.4.3",
  "description_db": "/work/lab/ReferenceDatabases/DRAM_data/description_db.sqlite",
  "setup_info": {},
  "log_path": null
}
```

\
3. Check DRAM configuration

```bash
$ DRAM-setup.py print_config #should return a path for each database
```

\
4. Navigate to a working directory and create links to 'good' / '[medium-quality draft](https://www.nature.com/articles/nbt.3893)' bins (completeness >50%, contamination <10%) based on [Checkm2 workflow](https://github.com/dgittins/Metagenomics/edit/main/binning/assessCheckM2.md) results

```bash
$ cd annotation/
$ cat ../binning/dastool/*_DASTool_bins/*_checkm2/quality_report_good.list > dastool_goodbins.list #concatenate the lists of good bins
$ awk 'NR > 1{ print $1 }' dastool_goodbins.list | xargs -I{} sh -c 'ln -s ../binning/dastool/*/{}' . #create a sym link to good bins. NB add 'sh -c' to make xargs respect wildcards in searches, otherwise sym link path is literal
```

\
5. Run DRAM to annotate MAGs

```bash
$ DRAM.py annotate -i *.fa -o dram_annotation --threads 20 #requires a lot of memory, ~500 GB
```
