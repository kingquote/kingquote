bases=['a','t','g','c']
l=[]
for b1 in bases:
    for b2 in bases:
        for b3 in bases:
            if (b1==b2 or b2==b3) and b1!=b3:
                l.append(b1+b2+b3)
            if b1==b3 and b2!=b1:
                l.append(b1+b2+b3)
l.sort()

print(l[9])