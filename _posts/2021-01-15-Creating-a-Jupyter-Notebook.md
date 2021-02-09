---
layout: post
title: Creating a Jupyter Notebook
date: '2021-01-15'
categories: Protocols
tags: jupyter, python
projects:
---

# Creating a Jupyter Notebook

#### Jupyter Trial
Trial Jupyter before installing and creating your own: [Try Jupyter](https://jupyter.readthedocs.io/en/latest/tryjupyter.html)

#### Jupyter Tools

Read the following post about [jupyter](https://jupyter.readthedocs.io/en/latest/install.html#jupyter-lab).

#### Installation Jupyter Notebook Interface
Below is how I created a Jupyter Notebook using the following resources.

[Installing Jupyter Notebook interface](https://jupyter.readthedocs.io/en/latest/install/notebook-classic.html#installing-jupyter-using-anaconda-and-conda)  
- Follow the **Graphical Installation of Anaconda** and **Testing your Installation** instructions when downloading [Anaconda - how to install](https://www.datacamp.com/community/tutorials/installing-anaconda-mac-os-x). This is step 1 in the Jupyter Notebook interface link. See my troubleshooting steps at the bottom of the page for help with installation options.

Testing installation example using --version for python:  

```
emmastrand@Emmas-MacBook-Pro-2 ~ % python --version
Python 2.7.16
```

Testing installation example by opening Jupyter Notebooks:  

```
emmastrand@Emmas-MacBook-Pro-2 ~ % jupyter notebook

[I 12:52:16.124 NotebookApp] The port 8888 is already in use, trying another port.
[I 12:52:16.424 NotebookApp] JupyterLab extension loaded from /Users/emmastrand/opt/anaconda3/lib/python3.8/site-packages/jupyterlab
[I 12:52:16.424 NotebookApp] JupyterLab application directory is /Users/emmastrand/opt/anaconda3/share/jupyter/lab
[I 12:52:16.427 NotebookApp] Serving notebooks from local directory: /Users/emmastrand
[I 12:52:16.427 NotebookApp] Jupyter Notebook 6.1.4 is running at:
[I 12:52:16.427 NotebookApp] http://localhost:8889/?token=17d4975ec888f6e46a39b52afabe18fe83909ec9e3e13d40
[I 12:52:16.427 NotebookApp]  or http://127.0.0.1:8889/?token=17d4975ec888f6e46a39b52afabe18fe83909ec9e3e13d40
[I 12:52:16.427 NotebookApp] Use Control-C to stop this server and shut down all kernels (twice to skip confirmation).
[C 12:52:16.441 NotebookApp]

    To access the notebook, open this file in a browser:
        file:///Users/emmastrand/Library/Jupyter/runtime/nbserver-76470-open.html
    Or copy and paste one of these URLs:
        http://localhost:8889/?token=17d4975ec888f6e46a39b52afabe18fe83909ec9e3e13d40
     or http://127.0.0.1:8889/?token=17d4975ec888f6e46a39b52afabe18fe83909ec9e3e13d40

# this output opens jupyter notebook in a new internet window
# it worked, yay!
```

If Anaconda did not install properly, refer to the **Common Issues** section of the how to install link.

Updating Anaconda to update python version. When I use the python --version function, this reports a lower version than when I use the conda list function and scroll to find python. Since the version under conda list is the desired version and conda/jupyter notebook function works, I moved on.

```
% conda update anaconda
% conda --version
conda 4.9.2
% conda install python=3.7
% conda update python

% python --verison
Python 2.7.16

% conda list

python                    3.8.5                h26836e1_1  
python-dateutil           2.8.1                      py_0  
python-jsonrpc-server     0.4.0                      py_0  
python-language-server    0.36.2             pyhd3eb1b0_0  
python-libarchive-c       2.9                        py_0  
python.app                3                py38h9ed2024_0
```


##### Troubleshooting Anaconda Installation.

I had to troubleshoot this install with the following commands.

Testing installation example using --version for python:  

```
# the below output indicates that the installation did not work.
emmastrand@Emmas-MacBook-Pro-2 ~ % python --version
Python 2.7.16

# desired output:
Python 2.7.16 :: Anaconda, Inc.
```

Testing installation example by opening Jupyter Notebooks:  

```
# the below output indicates that the installation did not work.
emmastrand@Emmas-MacBook-Pro-2 ~ % jupyter notebook
zsh: command not found: jupyter
```


Checking contents of bash profile.

```
emmastrand@Emmas-MacBook-Pro-2 ~ % cat .bash_profile

[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
```

Changed the contents of my .bashrc file because during installation I accidentally did not add the conda prompt to my path.

```
emmastrand@Emmas-MacBook-Pro-2 ~ % nano .bashrc

# in nano
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

## changed contents to
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH=/Users/emmastrand/anaconda3/bin:$PATH
```
This didn't work. I changed my .bashrc back to the original.

Uninstalled and reinstalled Anaconda. **I chose different options upon installation**:  
- In "Destination Select", I chose "Install on a specific disk" > "Mactintosh HD" > "Choose Folder" > "emmastrand".  
- "By default, this installer modifies your bash profile to activate the base environment of Anaconda3 when your shell starts up.  To disable this, choose "Customize" at the "Installation Type" phase, and disable the "Modify PATH" option. Whether to modify the bash profile file to append Anaconda3 to the PATH variable. If you do not do this, you will need to add ~/anaconda3/bin to your PATH manually to run the commands, or run all Anaconda3 commands explicitly from that path.

This worked, yay!

#### Installation of JupyterLab and Jupyter-Console

I ran the below commands to [install JupyterLab](https://jupyterlab.readthedocs.io/en/stable/getting_started/installation.html).

```
% conda install -c conda-forge jupyterlab
```

I ran the below commands to [install Jupyter console 6.0](https://jupyter-console.readthedocs.io/en/latest/). However, I got an error saying "Solving environment: failed with initial frozen solve. Retrying with flexible solve. PackagesNotFoundError: The following packages are not available from current channels:". I will come back to this.

```
% conda install -c conda-forge jupyter-console
```

**Running Jupyter Lab**

```
% jupyter-lab

# this output will result in Jupyter lab opening in a windows browswer
```

Click on the Notebook Python 3 options in Jupyter Lab to create a notebook. This can lead to an error permission denied. In that case 

One of the biggest pros of working in Jupyter notebook and lab is that your commands and outut are saved as opposed to creating a markdown file like this and writing notes here.
