def average(yn):
   return(sum(yn)/len(yn))  
    
def standarddev(yn):
    dif=[]
    avg = average(yn)
    for i,x in enumerate(yn):
        dif.append((x-avg)**2)
    return(((1/(len(yn)-1))*sum(dif))**0.5)

def standarderror(yn):
    return standarddev(yn)/(len(yn)**0.5)