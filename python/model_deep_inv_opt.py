## code defined by 
## modified by Juan Mayor-Torres
import numpy as np
import deep_inv_opt as io
import deep_inv_opt.plot as iop
import sys

import matplotlib
import matplotlib.pyplot as plt
matplotlib.rcParams['figure.max_open_warning'] = 0  # Let the plots flow! ## this doesnt work in Anaconda prompt you need to use X11 or other interactive shell use plt.show to check the results instead
#matplotlib inline

import torch

class ExamplePLP(io.ParametricLP):
    # x1= w_{hat}
    # x2= w_{e} For this two variables refer to the README file 
    # Generate an LP from a given feature vector u and weight vector w. The final weight value w should be capture from the stdio
    
    def generate(self, u, w): ##
        
        #c=[[u*w],[0.0]] ## cost function should be defined to the best convenience of the model
        c = [[torch.cos(w + (u**2)/2)], ## define the cost function depending how do you want to modulate w and u across the model you can define here
             [torch.sin(w + (u**2)/2)]]

        A_ub = [[-1.0,  0.0],      # x1 >= 0
                [ 0.0, -1.0],      # x2 >= 0
                [1.0, 0.0],        # x1 <= 1
                [0.0, 1.0],        # x2 <= 1
                [0.0, 1.0+u*w]]  
                

        b_ub = [[ 0.0],
                [ 0.0],
                [1.0],
                [1.0],
                [1.0]]

        A_eq = [[1.0+(u*w),0.0]]
        
        b_eq = [[1.0]]       

        return c, A_ub, b_ub, A_eq, b_eq

# Evaluate the parametric LP at specific values of u

plp_true = ExamplePLP(weights=[6])
x_train = io.tensor(np.array(sys.argv[1].split(',')).astype(np.float).reshape((-1,1))) ##targets given as empirical rates from participants

u_train = io.tensor(np.array(sys.argv[2].split(',')).astype(np.float).reshape((-1,1))) ## the Pb/Pf value declared as u on this model


u_train_sal_model = torch.cat([io.linprog(*plp_true(ui)).detach().t() for ui in u_train])

# Plot it 
xylim = ((0, 2), (0, 2))
cxy = (5, 5)

plt.figure(figsize=(16,4))
for i, w in enumerate([7, 6, 5, 1]):
    plt.subplot(141+i)
    plt.title('w=%.1f' % w)
    iop.plot_parametric_linprog(ExamplePLP(weights=[w]), u_train, xylim=xylim, cxy=cxy, show_solutions=True)

plt.show()

# Create an instance with weight initialized to 0.8, and plot it to be sure the mode is working properly
iop.plot_parametric_linprog(plp_true, u_train, xylim=xylim, cxy=cxy, show_solutions=True)
plt.show()


plp_learn = ExamplePLP([2.8])
iop.plot_targets(io.tensor(np.transpose(np.concatenate((np.expand_dims(u_train_sal_model[:,0],axis=0),np.expand_dims(np.squeeze(x_train),axis=0)),axis=0))),markersize=13)
iop.plot_parametric_linprog(plp_learn, u_train, color=[0, 0, 1], xylim=xylim, cxy=cxy, show_solutions=True)
plt.show()

# Adjust weights of plp_learn to fit the training targets
print(np.shape(np.expand_dims(u_train_sal_model[:,0],axis=0)),'hii',np.shape(np.expand_dims(np.squeeze(x_train),axis=0)),'fii',np.concatenate((np.expand_dims(u_train_sal_model[:,0],axis=0),np.expand_dims(np.squeeze(x_train),axis=0)),axis=0),'wwii',np.shape(np.concatenate((np.expand_dims(u_train_sal_model[:,0],axis=0),np.expand_dims(np.squeeze(x_train),axis=0)),axis=0)))
io.inverse_parametric_linprog(u_train,io.tensor(np.transpose(np.concatenate((np.expand_dims(u_train_sal_model[:,0],axis=0),np.expand_dims(np.squeeze(x_train),axis=0)),axis=0))),plp_learn,max_steps=int(sys.argv[3]),callback=io.inverse_parametric_linprog_step_printer())

# Plot the new plp_learn, to show that the solutions (blue circles) now line up with the observed targets (black circles).
iop.plot_targets(io.tensor(np.transpose(np.concatenate((np.expand_dims(u_train_sal_model[:,0],axis=0),np.expand_dims(np.squeeze(x_train),axis=0)),axis=0))),markersize=13)
iop.plot_parametric_linprog(plp_learn, u_train, color=[0, 0, 1], xylim=xylim, cxy=cxy, show_solutions=True)
plt.show()
