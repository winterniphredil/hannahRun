import sympy as smp
from sympy import sin, symbols, Abs, Max
import numpy as np
import matplotlib.pyplot as plt
from matplotlib.colors import ListedColormap, TwoSlopeNorm
import sys

scheme = sys.argv[1]
its = int(sys.argv[2])

alpha = 0.5
n_c_vals = 25

c_a, c_g = symbols('c_a c_g', real = True)
a = symbols('alpha', real = True)
substitutions = {a: alpha}

id_mat = smp.Matrix([[1,0],[0,1]])
J_mat = smp.Matrix([[0,1],[1,0]])


def semi_implicit(ampl_mat_prev_iter):
    """
    Calculates the amplification matrix for a further iteration of the semi-implicit scheme

    Args:
        ampl_mat_prev_iter (2x2 matrix): the amplification matrix of the previous iteration

    Returns:
        (2x2 matrix): the final amplification matrix
    """
    coeff = id_mat + smp.I*a*c_g*J_mat
    coeff_inv = 1/(1+a**2*c_g**2) * (id_mat-smp.I*a*c_g*J_mat)
    term_1 = id_mat-smp.I*(1-a)*(c_a*id_mat + c_g*J_mat)
    term_2 = -smp.I*a*c_a*ampl_mat_prev_iter
    ampl_mat = coeff_inv*(term_1 + term_2)
    return ampl_mat
    
def segregated(ampl_mat_prev_iter):
    """
    Calculates the amplification matrix for a further iteration of the segregated scheme

    Args:
        ampl_mat_prev_iter (2x2 matrix): the amplification matrix of the previous iteration

    Returns:
        (2x2 matrix): the final amplification matrix
    """
    coeff = id_mat + smp.I*a*c_g*J_mat
    term_1 = smp.Matrix([[1/(1+smp.I*c_a*a),0],[0,1]]) * ((1-smp.I*c_a*(1-a))*id_mat-smp.I*c_g*(1-a)*J_mat)
    term_2 = smp.Matrix([[0,-smp.I*c_g*a*(1-1/(1+smp.I*c_a*a))],[0,-smp.I*c_a*a]])*ampl_mat_prev_iter
    ampl_mat = coeff.inv() * (term_1 + term_2)
    return ampl_mat

def op_split(ampl_mat_prev_iter):
    """
    Calculates the amplification matrix for a further iteration of the operator-split scheme

    Args:
        ampl_mat_prev_iter (2x2 matrix): the amplification matrix of the previous iteration

    Returns:
        (2x2 matrix): the final amplification matrix
    """
    coeff = id_mat + smp.I*a*c_g*J_mat
    term_1 = smp.Matrix([[1/(1+smp.I*c_a*a) * (1-smp.I*c_a*(1-a)),0],[0,1-smp.I*(c_a+c_g**2)*(1-a)]]) - smp.I*c_g*(1-a)*J_mat
    term_2 = smp.Matrix([[0,0],[0,-smp.I*c_a*a]]) * ampl_mat_prev_iter
    ampl_mat = coeff.inv() * (term_1 + term_2)
    return ampl_mat

def generate_ev_mat(A_mat, c_a_vals, c_g_vals):
    """
    Calculates the maximal magnitude of the eignevalues of the amplification matrix for a range of values of c_a and c_g

    Args:
        A_mat (2x2 matrix): the amplification matrix of
        c_a_vals (array): array of values to substitute for c_a
        c_g_vals (array): array of values to substitute for c_g

    Returns:
        (2x2 matrix): the final amplification matrix
    """
    
    A = np.zeros((len(c_a_vals), len(c_g_vals)))
    A_for_ev = A_mat.subs({a:alpha})
    print(A_for_ev.eigenvals().keys())
    
    for i in range(n_c_vals):
        for j in range(n_c_vals):
            A_sub = A_mat.subs({c_a: c_a_vals[i], c_g: c_g_vals[j], a: alpha})
            #print(A_sub)
            A_sub = np.array(A_sub.tolist(), dtype=np.complex128)
            A[i,j] = max(abs(np.linalg.eigvals(A_sub)))
    
    return A

def plot_2d(max_a,max_g,ampls,A_mat):
    """
    Plots the predicted and observed amplification factors

    Args:
        max_a (array): list of the maximum values of c_a
        max_g (array): list of the maximum values of c_g
        ampls (array): list of the amplification factors for the corresponding c_a and c_g
        A_mat (2x2 matrix): the amplification matrix in terms of c_a and c_g
    """
    fig = plt.figure(figsize=(15,15))
    ax = plt.axes()
    ax.set_xlabel(r'$c_a$')
    ax.set_ylabel(r'$c_g$')
    ax.set_xlim(0, 3)
    ax.set_ylim(0, 3)
    ampls_np = np.array(ampls)
    unstable = (ampls_np > 1.0000000001)
    custom_cmap = ListedColormap(['green', 'red'])
    lims = [
        min(min(max_a), min(max_g)),
        max(max(max_a), max(max_g))
    ]
    cLevels=np.arange(0, 2.1, 0.1)
    cNorm = TwoSlopeNorm(1.,vmin=0., vmax=2.)
    
    c_a_vals = np.linspace(0.0,3.0,n_c_vals)
    c_g_vals = np.linspace(0.0,3.0,n_c_vals)
    
    A = generate_ev_mat(A_mat, c_a_vals, c_g_vals)
    
    ca, cg = np.meshgrid(c_a_vals, c_g_vals, indexing='ij')
    cf = ax.contourf(ca, cg, A, cLevels, cmap='bwr', extend='max', norm=cNorm)
    plt.colorbar(cf, orientation='horizontal')
    plt.contour(ca, cg, A, levels=[1.000000001], colors='black', linewidths=1)
    plt.axvline(1.0, color='black', linestyle=':', linewidth=1)
    plt.axhline(1.0, color='black', linestyle=':', linewidth=1)
    plt.gca().set_aspect('equal', adjustable='box')
    ax.scatter(max_a,max_g,c=ampls_np,cmap='bwr',norm=cNorm,edgecolors='black',linewidths=0.2,s=40,zorder=10)
    ax.plot([i for i in lims], lims, '--', color='0.1', linewidth=1)
    plt.tight_layout()
    plt.tight_layout()
    plt.savefig("stabl_plot_against_pred.png")
    plt.cla()

file_end = "energy"
with open('stabl_errors_'+file_end,'r') as err_file:
    lines = err_file.readlines()
    time_steps = [i for i in lines[0].split()]
    height_coeff = [i.split()[0] for i in lines[1:]]
    ampls = [[float(i) for i in j.split(' ')[1:]] for j in lines[1:]]
    ampl_array = []
    for i in ampls:
        for j in i:ampl_array.append(j)

print(time_steps)
print(height_coeff)
print(ampl_array)

avg_a=[]
avg_g=[]
for h in height_coeff:
    for dt in time_steps:
        with open(h+"/dt_"+dt+"/log",'r') as log:
            max_split = log.read().split("max: ")[0:]
            leng = len(max_split)
            c_a_vals = [float(max_split[2*i+1].split()[0]) for i in range(leng//2)]
            c_g_vals = [float(max_split[2*i+2].split()[0]) for i in range(leng//2)]
            avg_a.append(sum(c_a_vals)/len(c_a_vals))
            avg_g.append(sum(c_g_vals)/len(c_g_vals))

A_mat = id_mat
for i in range(its):
    if scheme=="notSplit":A_mat=op_split(A_mat)
    elif scheme=="split":A_mat=segregated(A_mat)
    else:A_mat=semi_implicit(A_mat)
    
plot_2d(avg_a,avg_g,ampls,A_mat)
