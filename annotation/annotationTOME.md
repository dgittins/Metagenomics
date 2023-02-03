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
3. Install Tome

***VERY IMPORTANT*** manually change 'from sklearn.externals import joblib' to 'import joblib' on line 23 of ~/software/software/tome/Tome-1.0.0/tome/tome.py
    
```bash
$ pip install -e Tome-1.0.0/
$ pip3 install joblib #not detailed in the GitHub instructions
```

\
4. Run Tome

```bash
$ cd annotation/

for f in *.fa
do 
    sample=$(basename $f .fa)
    
done
```
