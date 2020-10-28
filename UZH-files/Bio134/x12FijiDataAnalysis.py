import numpy as np
import scipy.stats as ss
import matplotlib.pyplot as plt

def setuparray():
    totallist=[]
    for i in range(6):
        fyle=open('files\\MHV_data\\MHV_results\\MHV_measurements_'+str(i)+'.csv')
        content=fyle.readlines()
        fyle.close()
        del content[0]
        for line in content:
            x=line.split(',')
            for i,y in enumerate(x):
                x[i]=float(x[i])
            if x[1]>10 and x[1]<1000:
                totallist.append(x[1:])
    total=np.array(totallist)
    return total

def testing(data):
    plt.figure(1)
    plt.plot(data[:,0],data[:,1],'o')
    plt.xlabel('Area')
    plt.ylabel('Infection Intensity')
    plt.title('All Areas')
    test=ss.spearmanr(data[:,0],data[:,1])
    return test

def plotting(data):
    temp=(data[:,0]-1)//100
    rate=[]
    for i in range(int(max(temp))):
        rate.append(len(data[:,0][np.array(temp==i) & np.array(data[:,1]>=12)])/len(data[:,0][temp==i]))
    plt.figure(2)
    plt.plot(range(int(max(temp))),rate,'o')
    return rate


data = setuparray()
test = testing(data)
rate = plotting(data)

