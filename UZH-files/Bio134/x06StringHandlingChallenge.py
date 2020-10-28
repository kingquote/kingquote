fyle = open('files/06challenge.txt','r')
content = fyle.readlines()
fyle.close()

s = ''

for x in content:
    s += x
s = s.partition('*****')[2]
s = s.partition('#####')[0]
for y in "[]{}^!%&'*_+()$#@\n":
    s = s.replace(y,'')

print(s)