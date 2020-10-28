import numpy as np

#ind=ages//6
#no=np.bincount(ind)
#tot=np.bincount(ind,weights)


#a = np.array([0.3,0.2,0.4,0.1,0.5,0.5,0.7,1.0,0.3,0.3,0.2,0.1,\
#      0.8,0.8,0.7,0.6,0.3,0.0,0.1,0.2,0.7,0.4])**2
#a*=10
#a = a.astype(int)
#b=a//2
#o=np.bincount(b)
#print(o)


sex = np.array([0, 1, 1, 0, 0, 1, 0, 0, 1, 1, 1, 1, 0, 0]) # male: 0; female: 1
height = np.array([1.83, 1.72, 1.61, 1.68, 1.79, 1.75, 1.92, 1.76, 1.66, 1.68, 1.69, 1.61, 1.70, 1.78]) # in meters
o=np.bincount(sex,height)
avg=o/np.bincount(sex)
difm=avg[0]-avg[1]
difcm=difm*100