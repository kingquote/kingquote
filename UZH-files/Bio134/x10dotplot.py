import matplotlib.pyplot as plt

def slyce(line, width):
    dic={}
    for i in range(0,len(line)-width+1):
        piece=line[i:i+width]
        if piece not in dic:
            dic[piece]=[i]
        else:
            dic[piece].append(i)
    return dic
    
def match(line1, line2, width):
    d1=slyce(line1, width)
    d2=slyce(line2, width)
    s1=[]
    s2=[]
    for piece in d1:
        if piece in d2:
            for i in range(len(d1[piece])):
                for j in range(len(d1[piece])):
                    s1.append(d1[piece][i])
                    s2.append(d2[piece][j])
    return(s1,s2)
    
def plot(line1, line2, lablex, labley, width):
    tup=match(line1,line2,width)
    fig = plt.figure()
    ax = fig.add_subplot(111)
    ax.plot(tup[0],tup[1],'.')
    plt.title('Dotplot with window size '+str(width))
    plt.xlabel(lablex)
    plt.ylabel(labley)
    plt.show