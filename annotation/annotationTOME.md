# Prediction of optimal growth temperature

## [Tome](https://github.com/EngqvistLab/Tome)

1. Create a conda environment running python version 3.7

```bash
$ conda create -n tome python=3.7
$ conda activate tome
```

\
2. Navigate to a software directory and download Tome 

```bash
$ cd ~/software/tome

$ wget https://github.com/EngqvistLab/Tome/archive/refs/tags/v1.0.0.tar.gz #link under the 'Releases' tab on the GitHub page
$ tar xvzf v1.0.0.tar.gz
$ rm v1.0.0.tar.gz
```

\
3. Install Tome (NB: some modifications not mentioned in the GitHub instructions)

\***VERY IMPORTANT*** manually change 'from sklearn.externals import joblib' to 'import joblib' on line 23 of ~/software/software/tome/Tome-1.0.0/tome/tome.py
    
```bash
#then run the install commands
$ pip install -e Tome-1.0.0/
$ pip3 install joblib #not detailed in the GitHub instructions
$ python3 -m pip install -U scikit-learn #not detailed in the GitHub instructions
```

\
4. Run Tome to predict optimal growth temperature from amino acid gene predictions

```bash
$ cd annotation/tome/

for f in ../*_proteins.faa
do 
    sample=$(basename $f _proteins.faa)
    tome predOGT --fasta ../${sample}_proteins.faa -o ${sample}_ogt.txt -p 20    
done

#concatenate individual *_ogt.text files
$ awk 'FNR > 1' *.txt > all_ogt.txt #second line of each file
```
