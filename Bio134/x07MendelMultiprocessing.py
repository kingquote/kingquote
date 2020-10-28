from multiprocessing import Pool
import numpy.random as rd
from datetime import datetime

for z in range(1):
    
    startTime = datetime.now()
    
    men_dom = [5474,6022,705,882,428,651,787,372,353,64,71,60,67,72,65]
    men_rec = [1850,2001,224,299,152,207,277,193,166,36,29,40,33,28,35]
    plantnum = 15*[0]
    expected_dom = 15*[0]
    mendel_closer = []
    sim_closer = []
    for i in range(15):
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
    
    def mendelcloser(simdom,i):
        if abs(simdom - expected_dom[i]) > abs(men_dom[i] - expected_dom[i]):
            return 1
        elif abs(simdom - expected_dom[i]) < abs(men_dom[i] - expected_dom[i]):
            return 0
        else:
            return
    
    def experiment(i):
        mendelwon = 0
        simwon = 0 
        for j in range(1000):
            sim_dom = sim(i)
            closer = mendelcloser(sim_dom,i)
            if closer == 1:
                mendelwon += 1
            elif closer == 0:
                simwon += 1
        return mendelwon,simwon
    
    if __name__ == '__main__':
        __spec__ = None
        with Pool() as pool:
            PoolMap = (pool.map(experiment, range(15)))
            
        for i in range(15):
            mendel_closer.append(PoolMap[i][0])
            sim_closer.append(PoolMap[i][1])
    
        t =str(z)+':   '+ str(datetime.now() - startTime) + '\n'
        print('Mendel was closer:', mendel_closer)
        print('   Sim was closer:', sim_closer)
        print('Run ',t)
#        fyle = open('files/04MendelTesting.txt','a')
#        fyle.write(t)
#        fyle.close()
