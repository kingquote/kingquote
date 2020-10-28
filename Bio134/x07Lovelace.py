import math
def lovelace(n):
    if n==0:
        return 1
    total=0
    for i in range(0,n):
        total+=((math.factorial(n) * lovelace(i)) / ((math.factorial(i) * math.factorial(n-i+2))))
    return (-1*total)

for i in range(9):
    print(i,': {:.6f}'.format(lovelace(i)))