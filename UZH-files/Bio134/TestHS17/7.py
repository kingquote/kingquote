import numpy as np

def erode(inp):
    out=0*inp
    im=np.ones(shape=(inp.shape[0]+2,inp.shape[1]+2))
    im[1:-1,1:-1]=inp[:,:]                              #set up im as inp surrounded by ones(will be 'ignored' by min) -> makes edges easier
    for i in range(1,im.shape[0]-1):
        for j in range(1,im.shape[1]-1):
            out[i-1,j-1]=min([im[i-1,j-1],im[i,j-1],im[i+1,j-1],im[i-1,j],im[i,j],im[i+1,j],im[i-1,j+1],im[i,j+1],im[i+1,j+1]])


    return(out)


im = np.array([[0.6, 0.1, 0.4, 0.5, 0.6],
               [0.6, 0.5, 0.9, 0.2, 0.7],
               [0.3, 0.9, 0.7, 0.5, 0.9],
               [0.8, 0.5, 0.4, 0.8, 0.6]])
print(erode(im))