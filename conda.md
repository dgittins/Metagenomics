# Install conda on a macOS

1. Create a ~/.zshrc file
```
nano ~/.zshrc
```

2. Copy the appropriate installer link from https://docs.anaconda.com/free/miniconda/

3. Open a terminal and use command line to install
```
mkdir -p ~/Software/miniconda3
curl https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh -o ~/Software/miniconda3/miniconda.sh
bash ~/Software/miniconda3/miniconda.sh -b -u -p ~/Software/miniconda3
rm -rf ~/Software/miniconda3/miniconda.sh
```

3. Initiallize the installed Miniconda using zsh
```
~/Software/miniconda3/bin/conda init zsh

less ~/.zshrc
source ~/.zshrc
conda -V
```

