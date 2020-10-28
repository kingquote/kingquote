import matplotlib.pyplot as pl

fyle=open('weights.csv')
lines=fyle.readlines()
fyle.close()

ages=[]
avgs=[]
for i,x in enumerate(lines):  
    lines[i]=lines[i].split(',')
    counter=0
    sums=0
    for j,y in enumerate(lines[i]):
        lines[i][j]=int(lines[i][j]) #input formatting   
        if j != 0:
            sums+=lines[i][j]
            counter+=1
    avg=sums/counter
    ages.append(lines[i][0])
    avgs.append(avg)

pl.plot(ages,avgs)
pl.savefig('weights.png')
pl.show()