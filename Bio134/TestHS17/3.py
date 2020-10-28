def maximum(l):
    curmax=0
    pos=-1
    for i,x in enumerate(l):
        if x>curmax:
            curmax=x
            pos=i
    return(curmax,pos)


l = [6, 34, 2, 134, 265, 49]
m = maximum(l)
print(m[0])
print(m[1])