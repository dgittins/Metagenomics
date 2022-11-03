# Map quality controlled reads to the assemblies (contigs)

To generate 'coverage' information that will imporve binning, each QC read pair should be mapped to each assembly and the coassembly - if a study has four read pair files (metagenomes), four assemblies and one coassembly, mapping will need to be performed 4 x 5 (20) times.

## [BBMap](https://jgi.doe.gov/data-and-tools/software-tools/bbtools/bb-tools-user-guide/bbmap-guide/)

1. Install BBMap

```bash
$ conda create -n bbtools -c bioconda bbmap
$ conda activate bbtools
```

