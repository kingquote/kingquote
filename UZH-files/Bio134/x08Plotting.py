from numpy import linspace, pi, cos, sin
import matplotlib.pyplot as pl

def spiral(l,t):
    z = linspace(1,t,99999)
    x = l**(4*z) * cos(2*pi*z)
    y = l**(4*z) * sin(2*pi*z)
    
    pl.subplot(1,1,1)
    pl.plot(x,y,color='yellow',markeredgecolor='yellow')
    R = 100
    pl.xlim(-R,R)
    pl.ylim(-R,R)
    
    ax = pl.gca()   # stands for get-current-axes
    ax.set_aspect('equal') 
    ax.xaxis.set_visible(False)
    ax.yaxis.set_visible(False)
    ax.set_facecolor("black")

    pl.show()

def panels():
    pl.figure(1)         # first figure
    pl.subplot(211)      # first subplot in first figure (2 rows, 1 column, 1st panel)
    pl.plot([1, 2, 1])          
    pl.subplot(212)      # the second subplot in the first figure, 2nd panel
    pl.plot([3, 2, 1])
    
    pl.figure(2)         # a second figure
    pl.plot([4, 5, 6])   # creates a subplot(111) by default
    
    pl.show()

spiral(1.2,6)
#panels()