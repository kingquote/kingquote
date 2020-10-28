import numpy as np
a = np.array([[3, 6, 8], [8, 3, 1], [2, 4, 2], [9, 2, 0]])
#for i in range(a.shape[0]):
#    for j in range(a.shape[1]-1):
#        if i>0:
#            a[i,j] += 2
a[1:,:-1]+=2
print(a)
