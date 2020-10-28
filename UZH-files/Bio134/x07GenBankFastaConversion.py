def GenBankToFASTA(CoreFileName):
    fyle = open("files/"+CoreFileName+".genbank.txt", 'r')
    content = fyle.readlines()
    fyle.close()
    originreached = 0
    for i,x in enumerate(content):
        if 'ORIGIN' in x:
            originreached = 1
            start = i
        if originreached  == 1:
            content[i]="".join(x[10:].split()).upper()
    fyle = open("files/"+CoreFileName+".fasta.txt", 'w')
    fyle.write('>'+CoreFileName[3:]+'\n')
    for i,x in enumerate(content):
        if i >= start:
            if not(x=='' or x=='\n'):
                fyle.write(x+'\n')
    fyle.close

def FASTAToGenBank(CoreFileName):
    global content
    global result
    fyle = open("files/"+CoreFileName+".fasta.txt", 'r')
    content = fyle.readlines()
    fyle.close()
    del content[0]
    position=1
    result=[]
    for i,x in enumerate(content):
        if not(x=='' or x=='\n'):
            result.append(['{:9d}'.format(position)])
            position+=60
            for j in range(0,51,10):
                result[i].append(x[j:j+10].lower())
    for y,q in enumerate(result[len(result)-1]):
        if result[len(result)-1][6-y]=='':
            del result[len(result)-1][6-y]
    fyle = open("files/"+CoreFileName+".genbank.txt", 'w')
    fyle.write('>'+CoreFileName[3:]+'\nORIGIN\n')
    for i,x in enumerate(result):
        fyle.write(' '.join(x)+'\n')
    fyle.write('//')
    fyle.close

filename=input("What is the files name? ")
if 'genbank' in filename.partition('.')[2]:
    GenBankToFASTA(filename[:9])
    print('conversion to FASTA complete')
elif 'fasta' in filename.partition('.')[2]:
    FASTAToGenBank(filename[:9])
    print('conversion to GenBank complete')
else:
    print('This file is not supported')
