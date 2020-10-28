x = 200 #number of days
y = 24*60 #time units per day
n = float(1000) #number of prey
m = float(100) #number of predators

for i in range(1,x*y+1):
    N = 0.0002*n*m/y #dependent decrease this time unit
    M = 0.0001*n*m/y #dependent increase this time unit
    n = n*(1+0.05/y) - N #with natural increase/decrease
    m = m*(1-0.1/y) + M
print('On day',x,'there are',int(m),'predators and',int(n),'prey.')