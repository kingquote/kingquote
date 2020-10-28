def compare(seq,seqlist):
    maxlen=0
    for i,x in enumerate(seqlist):
        if len(x)>maxlen:
            maxlen=len(x)
    xes=maxlen*'x'
    seq=xes+seq+xes   #increase lenght of single seq with series of x-es to left and right
    out=[]
    for i,x in enumerate(seqlist):              #i is sequence
        maxlap=0
        for j in range(len(seq)-maxlen):        #j is positioning of sequence
            total=0
            for k,y in enumerate(seqlist[i]):   #k is character in sequence
                if y==seq[j+k]:
                    total+=1
            if total>maxlap:
                maxlap=total
        out.append(maxlap)
    return(out)
    
    




#seq = 'ggta'
#seqlist = ['gtacct', 'ctccgg', 'ccgctacg']
#print(compare(seq, seqlist))

seq = 'ccagcgta'
seqlist = ['cgctttacctgcc', 'ggttagttcatgg',
'atcgttacgcggtata', 'agcctatagccc']
print(compare(seq, seqlist))