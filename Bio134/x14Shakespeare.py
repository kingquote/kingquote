fyle=open('files\\14text.txt','r')
inp=fyle.readlines()
fyle.close()

for l in inp:
    line=l.split()
    second=''
    counter=0
    for i,word in enumerate(line):
        if i==1:
            second=word
        counter+=1
    print( ('{:4d} '+second).format(counter))