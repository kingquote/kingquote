def dnp(np,dx,a,k):
    return ((dx**k)/(a+(dx**k)))-np
    
def ddp(dp,np,b,h):
    return (1/(1+(b*(np**h))))-dp

time=50
step=0.1
a=0.01  #constants
b=100
k=2
h=2
d1=0.99 #initial Delta in cell 1
n1=1    #initial Notch in cell 1
d2=1    #d2 in this case equal to average of neighboring cells of 1, since there are only two cells
n2=1
former=[d1,n1,d2,n2]

for i in range(int(time/step)):
    new=[]
    new.append((ddp(former[0],former[1],b,h)*step)+former[0])
    new.append((dnp(former[1],former[2],a,k)*step)+former[1])
    new.append((ddp(former[2],former[3],b,h)*step)+former[2])
    new.append((dnp(former[3],former[0],a,k)*step)+former[3])
    former=new

print('d1,n1,d2,n2: ',former)