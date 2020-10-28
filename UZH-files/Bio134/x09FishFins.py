import numpy as np
import matplotlib.pyplot as plt
np.set_printoptions(threshold=np.nan)

def OpenFile(name):
    fyle=open('files/'+name,'r')
    l=fyle.readlines()
    fyle.close
    for i in range(len(l)):
        l[i]=l[i].split()
        l[i][0]=int(l[i][0])
        l[i][2]=float(l[i][2])
    return(l)
   
def LtoD(l):
    d={}
    for i in range(len(l)):
        d[l[i][1]]={}
    for i in range(len(l)):
        d[l[i][1]][l[i][0]]  =  l[i][2]
    return(d)

def LtoA(l):
    a=np.zeros((18,7))
    a=a/0
    for i in range(len(l)):
        a[rays[l[i][1]],l[i][0]-1]=l[i][2]
    return(a)

def names_of_rays(rays):
    ray_names = 18*['']
    for ray in rays:
        ray_names[rays[ray]] = ray
    return ray_names

def ray_dictionary():
   rays = {}
   for i in range(9): 
      s = 'D' + str(i+1)
      rays[s] = i 
   for i in range(9):
      s = 'V' + str(9-i)
      rays[s] = i + 9 
   return rays
rays=ray_dictionary()

def plotting(ratios, mean_ratios, ray_names):
    fig = plt.figure()
    ax = fig.add_subplot(111)
    for i in range(ratios.shape[1]): #0 or 1
        ax.plot(ratios[:,i],'.') #something with ratios
    ax.plot(mean_ratios,'k')
    #ax.plot(18*[1],'k')
    plt.ylim([0, 1.6])
    plt.legend(['fish 1', 'fish 2', 'fish 3', 'fish 4', 'fish 5', 'fish 6', 'fish 7', 'mean'])
    plt.title('Change in bifurcation distances upon fin regeneration.')
    plt.xlabel('Ray')
    plt.ylabel('Relative change in bifurcation distance')
    ax.set_xticks(range(len(ray_names)))
    ax.set_xticklabels(ray_names)

a_after=LtoA(OpenFile('09bif_after.txt'))
a_before=LtoA(OpenFile('09bif_before.txt'))

ratios = a_after/a_before
mean_ratios = np.nanmean(ratios,1)

plotting(ratios, mean_ratios, names_of_rays(rays))