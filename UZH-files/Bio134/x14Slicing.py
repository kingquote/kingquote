import numpy as np

def La(prot):
    N = len(prot)
    dprot = np.zeros(N)
#    for i in range(1,N-1):
#        dprot[i] = -2*prot[i] + prot[i-1] + prot[i+1]
    dprot[1:len(prot)-1]=-2*prot[1:-1] + prot[0:-2] + prot[2:]
    dprot[0] = -prot[0] + prot[1]
    dprot[-1] = -prot[-1] + prot[-2]
    return dprot
    
N = 20
np.random.seed(0)
a = np.zeros(N) + 1 + 0.3 * np.random.rand(N)
print(La(a))

#Output with old for loop:
#[ 0.04991276 -0.08364056  0.01636374 -0.01900446  0.10304031 -0.12916386
# 0.19874781 -0.11468881 -0.1956333   0.29655143 -0.20133409  0.09059393
# 0.09552073 -0.3636338   0.26119615 -0.02490124  0.26379371 -0.26005936
# 0.04389555 -0.02755662]