fyle = open('files/05crick.txt', 'r')
t = fyle.readlines()
fyle.close()

fyle = open('files/05crick_copy.txt','w')
for i in range(len(t)):
    t[i] = t[i].strip('\r\n')
    fyle.write(t[i])
fyle.close()

fyle = open('files/05crick_copy.txt','r')
s = fyle.read()
print(s)
fyle.close()