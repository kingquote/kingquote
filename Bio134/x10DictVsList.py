import numpy.random as rd
import time

def random_list(length):
    alphabet = 'abcdefghijklmnopqrstuvwxyz'
    l = []
    for i in range(length):
        s = ''
        for j in range(5):
            s += alphabet[rd.randint(0,24)]
        l.append(s)
    return l

def list2dict(lyst):
    dic={}
    for pos,entry in enumerate(lyst):
        if entry in dic:
            dic[entry].append(pos)
        else:
            dic[entry]=[pos]
    return dic
    
rd.seed(0)
l1 = random_list(10000)
l2 = random_list(10000)

time1 = time.time()
common = []
for fruit in l1:
    if fruit in l2:
        if fruit not in common:
            common.append(fruit)
time2 = time.time()
print(common)
print('time spent on list part:', time2 - time1)

time3 = time.time()
d1 = list2dict(l1)
d2 = list2dict(l2)

time4 = time.time()
common = []
for fruit in d1:
    if fruit in d2:
        if fruit not in common:
            common.append(fruit)
time5 = time.time()
print(common)
print('              time spent on dict comparison:', time5 - time4)
print('time spent on dict translation + comparison:', time5 - time3)
#print("         dict comparison / list comparison =",(time3-time1)/(time5-time4))
print("                dict all / list comparison =",(time3-time1)/(time5-time3))