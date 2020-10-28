import matplotlib.pyplot as plt
G=0.05
S=0.1
N=0.0001
H=0.0002

T=700
Step=1/(24*60)
X=1000
Y=100

t = G*T
ts= G*Step
x = (N/G)*X
y = (H/G)*Y
k = S/G

xprog=[]
yprog=[]

for i in range(int(t/ts)):
    dx=x-x*y
    dy=x*y-k*y
    x=x+dx*ts
    y=y+dy*ts
    xprog.append(x/(N/G))
    yprog.append(y/(H/G))
    
plt.figure(1)
plt.plot(xprog,label='Prey')
plt.plot(yprog,label='Predator')
plt.legend()
print('On day',t/G,'there are',int(x/(N/G)),'predators and',int(y/(H/G)),'prey.')