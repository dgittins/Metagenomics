# Ranger-DTL

RANGER-DTL 2.0 (short for Rapid ANalysis of Gene family Evolution using Reconciliation-DTL) is a software package for inferring gene family evolution by speciation, gene duplication, horizontal gene transfer, and gene loss. 

Website: https://compbio.engr.uconn.edu/software/ranger-dtl/

Instructions to download Ranger-DTL in a conda environment on a university HPC:

1. Download Ranger-DTL
```
cd ~/bin/rangerDTL
wget https://compbio.engr.uconn.edu/wp-content/uploads/sites/2447/2019/08/Linux.zip
wget https://compbio.engr.uconn.edu/wp-content/uploads/sites/2447/2019/05/Ranger-DTL-RT_Linux.zip
unzip Linux.zip
unzip Ranger-DTL-RT_Linux.zip
rm Linux.zip
rm Ranger-DTL-RT_Linux.zip
```

2. Create and activate a new conda environment for the Ranger-DTL program (unsure if Python is a dependency, but install anyway)
```
conda create --name rangerDTL python=3.8
conda activate rangerDTL
```

3. Install RANGER-DTL using the Linux executable
```
# Find conda's bin environment
echo $CONDA_PREFIX
/home/dgittins/miniconda3/envs/rangerDTL

# Copy the executables to the bin
cp ~/bin/rangerDTL/Linux/CorePrograms/*.linux /home/dgittins/miniconda3/envs/rangerDTL/bin/
cp ~/bin/rangerDTL/Ranger-DTL-RT_Linux/Ranger-DTL-RT.linux /home/dgittins/miniconda3/envs/rangerDTL/bin/

# Make the executable an executable
chmod +x /home/dgittins/miniconda3/envs/rangerDTL/bin/*.linux
chmod +x /home/dgittins/miniconda3/envs/rangerDTL/bin/Ranger-DTL-RT.linux
```

4. Test the Installation
```
Ranger-DTL.linux --help
Ranger-DTL-RT.linux --help
```

5. Install ARTra: Additive and Replacing Transfer Inference

ARTra (short for “Additive and Replacing Transfer Inference”) is a program for inferring and distinguishing between additive and replacing horizontal gene transfer events. 

Website: https://compbio.engr.uconn.edu/software/ARTra/

```
cd ~/bin/rangerDTL
wget https://compbio.engr.uconn.edu/wp-content/uploads/sites/2447/2020/06/ARTra.zip
unzip ARTra.zip
rm ARTra.zip
```
