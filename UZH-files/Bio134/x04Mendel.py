import numpy.random as rd
from datetime import datetime

for z in range(1):
    
    startTime = datetime.now()
    
    men_dom = [5474,6022,705,882,428,651,787,372,353,64,71,60,67,72,65]
    men_rec = [1850,2001,224,299,152,207,277,193,166,36,29,40,33,28,35]
    plantnum = 15*[0]
    expected_dom = 15*[0]
    mendel_closer = 15*[0]
    sim_closer = 15*[0]
    
    def expecteddom(i):
        global expected_dom
        global plantnum
        plantnum[i] = men_dom[i]+men_rec[i]
        if i<7:
            expected_dom[i] = plantnum[i]*0.75
        else:
            expected_dom[i] = plantnum[i]*(2/3)
    
    def sim(i):
        total = 0
        for k in range(plantnum[i]):
            simulate = rd.randint(1,13)
            if i < 7:
                if simulate < 10:
                    total += 1
            else:
                if simulate < 9:
                    total += 1
        return total
    
    def mendelcloser(simdom):
        if abs(simdom - expected_dom[i]) > abs(men_dom[i] - expected_dom[i]):
            return 1
        elif abs(simdom - expected_dom[i]) < abs(men_dom[i] - expected_dom[i]):
            return 0
        else:
            return
    
    
    for i in range(15):
        expecteddom(i)   
        for j in range(1000):
            sim_dom = sim(i)
            closer = mendelcloser(sim_dom)
            if closer == 1:
                mendel_closer[i] += 1
            elif closer == 0:
                sim_closer[i] += 1
    
    t =str(z)+':   '+ str(datetime.now() - startTime) + '\n'
    print('Mendel was closer:', mendel_closer)
    print('   Sim was closer:', sim_closer)
    print('Run ',z,' took:',t)
#    fyle = open('files/04MendelTesting.txt','a')
#    fyle.write(t)
#    fyle.close()