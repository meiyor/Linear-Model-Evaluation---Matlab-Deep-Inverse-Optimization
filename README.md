# Linear-Model-Evaluation - Matlab-Deep-Inverse-Optimization

Framework to parse parameters between Matlab and Python to do Deep Inverse Optimization which is not available in the Matlab Optim Toolbox. The Deep Inverse Optimization code can be found here (https://github.com/tankconcordia/deep_inv_opt) described as an efficient way for tuning parameters is very necessary to evaluate and find correlation on empirical and  optimized forward models in Neuroscience. 

#### This repository can parse any parameter from Matlab to the Python code described by the Deep Inverse Optimization repository.

### Requirements
- Miniconda 3
- Anaconda 3
- Matlab >= R2019a
- Python 3.7
- Pytorch
- deep_inv_opt
- numpy
- matplotlib

Follow the next steps before run the Matlab main code:

__1.__ Install Anaconda and Miniconda 3 prompt following the instructions documented in this link __(https://docs.conda.io/projects/conda/en/latest/user-guide/install/windows.html)__. For Unix or Mac follow these instructions __(https://docs.conda.io/projects/conda/en/latest/user-guide/install/linux.html)__ or --__(https://docs.conda.io/projects/conda/en/latest/user-guide/install/macos.html)__

__2.__ From the Anaconda prompt in Windows or Unix install the requirement packages from te __requirements.txt__ file added in this current repository following the next command on pip:

```bash  
   pip install -r requirements.txt
```
(it will take a time, and be sure you have 5GB available in your HD for Conda installation)

__3.__ After the main requirements are installed you must install the Deep Inverse Optimization (https://github.com/tankconcordia/deep_inv_opt). Download the repository and setup the code as part of the enviroment variable as they suggested in the repository:

```bash  
   python setup.py develop
```
(run this on the deep_inv_opt main directory where the file setup.py is located).

After Deep Inverse Optimization repository is set in Anaconda you can go to the matlab prompt and run the main example containing a linear model optimization following this command on the main directory you have located the .m files on this repository:

```matlab 
   matlab_interface_python(40,20);
```


