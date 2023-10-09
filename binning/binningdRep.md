# de-replicate a genome set - best representative genome

## [dRep](https://github.com/MrOlm/drep)

1. Install dRep

```bash
$ conda create -n dRep -c bioconda dRep
$ conda activate dRep

$ dRep check_dependencies

# 'centrifuge' and 'nsimscan' are not required
```

\
2. Navigate to a working directory and create links to genome bins

```bash
$ cd binning/drep/
$ ln -s ../dastool/*_DASTool_bins/*[0-9].fa .
```

\
3. Run dRep (default 95% ANI, 10% minimum alignment coverage)

```bash
dRep dereplicate drep_out -g *.fa
```
