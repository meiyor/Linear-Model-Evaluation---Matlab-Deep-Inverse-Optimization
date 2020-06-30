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

After Deep Inverse Optimization repository is set in Anaconda you can go to the matlab prompt and run the main example containing a linear model optimization following this command on the main directory you have located the .m files from this repository:

```matlab 
   matlab_interface_python(40,20);
```

The previous command will create an input vector of 40 random points and 40 target points from a uniform distribution between 0 and 1. You can modify the model on matlab and this command will proceed with 20 training iterations on deep_inv_opt after you run it. The final output on the Matlab command prompt will be something like this:
```bash 
     inverse_parametric_linprog[0001]: loss=0.101617 weights=[2.8000]
     inverse_parametric_linprog[0002]: loss=0.081102 weights=[2.9568]
     inverse_parametric_linprog[0003]: loss=0.078752 weights=[3.0901]
     inverse_parametric_linprog[0004]: loss=0.062718 weights=[3.1193]
     inverse_parametric_linprog[0005]: loss=0.062531 weights=[3.1179]
     inverse_parametric_linprog[0006]: loss=0.061715 weights=[3.1177]
     inverse_parametric_linprog[0007]: loss=0.061681 weights=[3.1177]
     inverse_parametric_linprog[0008]: loss=0.061229 weights=[3.1177]
     inverse_parametric_linprog[0009]: loss=0.061196 weights=[3.1177]
     inverse_parametric_linprog[0010]: loss=0.061193 weights=[3.1177]
     inverse_parametric_linprog[0011]: loss=0.061193 weights=[3.1177]
     inverse_parametric_linprog[0012]: loss=0.061193 weights=[3.1177]
     inverse_parametric_linprog[0013]: loss=0.061193 weights=[3.1177]
     inverse_parametric_linprog[0014]: loss=0.061193 weights=[3.1177]
     inverse_parametric_linprog[0015]: loss=0.061193 weights=[3.1177]
     inverse_parametric_linprog[0016]: loss=0.061193 weights=[3.1177]
     inverse_parametric_linprog[0017]: loss=0.061193 weights=[3.1177]
     inverse_parametric_linprog[0018]: loss=0.061193 weights=[3.1177]
     inverse_parametric_linprog[0019]: loss=0.061193 weights=[3.1177]
     inverse_parametric_linprog[0020]: loss=0.061193 weights=[3.1177]
     inverse_parametric_linprog[done]: loss=0.061193 weights=[3.1177]
```
For this particular model we want to make an inverse optimization on the paramater w on a Bayesian model described on the following Equation:

<a href="https://www.codecogs.com/eqnedit.php?latex=\hat{\omega}=\frac{p_{f}}{p_{f}&space;&plus;&space;w&space;p_{b}}" target="_blank"><img src="https://latex.codecogs.com/gif.latex?\hat{\omega}=\frac{p_{f}}{p_{f}&space;&plus;&space;w&space;p_{b}}" title="\hat{\omega}=\frac{p_{f}}{p_{f} + w p_{b}}" /></a>
