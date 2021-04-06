# code defined by Yingcong Tan, Concordia University
# modified by Juan Mayor-Torres, Cardiff University

import torch
import numpy as np
import deep_inv_opt as io
import deep_inv_opt.plot as iop
import sys

import matplotlib
import matplotlib.pyplot as plt
# Let the plots flow! ## this doesnt work in Anaconda prompt you need to use X11 or other interactive shell use plt.show to check the results instead
matplotlib.rcParams['figure.max_open_warning'] = 0
# matplotlib inline


class ExamplePLP(io.ParametricLP):
    # x1= w_{hat}
    # x2= w_{e} For this two variables refer to the README file. w_{hat} will be the estimation and w_{e} the x_targets parsed from Matlab
    # Generate an LP from a given feature vector u and weight vector w. The final weight value w should be capture from the stdio

    def generate(self, u, w):

        # c=[[u*w],[0.0]] ## cost function should be defined to the best convenience of the model
        c = [[torch.cos(w + (u**2)/2)],  # define the cost function depending how do you want to modulate w and u across the model you can define here
             [torch.sin(w + (u**2)/2)]]
        # inequality matrix, very important for the final prediction u and w should modulate w_{e} as well as w_{hat} for having a proper and faster estimation of the  weights w
        A_ub = [[-1.0,  0.0],      # x1 >= 0
                [0.0, -1.0],      # x2 >= 0
                [1.0, 0.0],        # x1 <= 1
                [0.0, 1.0],        # x2 <= 1
                [0.0, 1.0+u*w]]  # (1+u*w)w_{e} <= 1

        # constants of the other side of the inequeality matrix
        b_ub = [[0.0],
                [0.0],
                [1.0],
                [1.0],
                [1.0]]
        # model definition itself (1+u*w)w_{hat}=1
        A_eq = [[1.0+(u*w), 0.0]]

        b_eq = [[1.0]]

        # all the linear programming (LP) model should be defined and return for
        return c, A_ub, b_ub, A_eq, b_eq

# Evaluate the parametric LP at specific values of u reading from the strings parsed from Matlab


plp_true = ExamplePLP(weights=[float(sys.argv[5])])

x_train = io.tensor(np.array(sys.argv[1].split(',')).astype(np.float).reshape(
    (-1, 1)))  # targets given as empirical rates from participants

u_train = io.tensor(np.array(sys.argv[2].split(',')).astype(
    np.float).reshape((-1, 1)))  # the Pb/Pf value declared as u on this model

# define the forward model values from the xtarget using the following instruction

u_train_sal_model = torch.cat(
    [io.linprog(*plp_true(ui)).detach().t() for ui in u_train])

# Plot it
xylim = ((0, 2), (0, 2))
cxy = (5, 5)

# plot different 4 examples for your model you can see how the model evolves in terms of w
plt.figure(figsize=(16, 4))
for i, w in enumerate([7, 6, 5, 1]):
    plt.subplot(141+i)
    plt.title('w=%.1f' % w)
    iop.plot_parametric_linprog(ExamplePLP(
        weights=[w]), u_train, xylim=xylim, cxy=cxy, show_solutions=True)

plt.show()

# Create an instance with weight initialized to 0.8, and plot it to be sure the mode is working properly
iop.plot_parametric_linprog(
    plp_true, u_train, xylim=xylim, cxy=cxy, show_solutions=True)
plt.show()

# define the learning range between argument 4 and argument 5 from the Matlab parsing

plp_learn = ExamplePLP([float(sys.argv[4])])
iop.plot_targets(io.tensor(np.transpose(np.concatenate((np.expand_dims(
    u_train_sal_model[:, 0], axis=0), np.expand_dims(np.squeeze(x_train), axis=0)), axis=0))), markersize=13)
iop.plot_parametric_linprog(plp_learn, u_train, color=[
                            0, 0, 1], xylim=xylim, cxy=cxy, show_solutions=True)
plt.show()

# Adjust weights of plp_learn to fit the training targets, this command perform the inverse linear programming training following the Deep Inverse Optimization
io.inverse_parametric_linprog(u_train, io.tensor(np.transpose(np.concatenate((np.expand_dims(u_train_sal_model[:, 0], axis=0), np.expand_dims(
    np.squeeze(x_train), axis=0)), axis=0))), plp_learn, max_steps=int(sys.argv[3]), callback=io.inverse_parametric_linprog_step_printer())

# Plot the new plp_learn, to show that the solutions (blue circles) now line up with the observed targets (black circles).
iop.plot_targets(io.tensor(np.transpose(np.concatenate((np.expand_dims(
    u_train_sal_model[:, 0], axis=0), np.expand_dims(np.squeeze(x_train), axis=0)), axis=0))), markersize=13)
iop.plot_parametric_linprog(plp_learn, u_train, color=[
                            0, 0, 1], xylim=xylim, cxy=cxy, show_solutions=True)
plt.show()
