lys = [['snow', 'bright'], ['green', 'hat'], ['run', 'stone']]

out=[]
for i,x in enumerate(lys):
    for j,y in enumerate(lys[i]):
        if j>=len(out):
            out.append([])
        out[j].append(lys[i][j])
        out[j][i]=out[j][i].replace('a','A')
        out[j][i]=out[j][i].replace('e','E')
        out[j][i]=out[j][i].replace('i','I')
        out[j][i]=out[j][i].replace('o','O')
        out[j][i]=out[j][i].replace('u','U')
print(out)
