def findoverlap(string1,string2):
    overlap=0
    for i in range(len(string1)):
        if string1[-i:]==string2[:i]:
            overlap=i
    return overlap
def next(stringnr):
    global text
    text+=s[stringnr]
    maxi=0
    goal=0
    for i in enumerate(dict[stringnr][1]):
        if dict[stringnr][1][i][1]>maxi and stringnr[stringnr[1][i][0]][0]>0:
            maxi = dict[stringnr][1][i][1]

        
        
#s=['the men and women merely players;/','one man in his time',"All the world's",'their entrances,/And one man','stage,/And all the men and women','They have their exits and their entrances,/',"world's a stage,/And all",'their entrances,/And one man','in his time plays many parts.','merely players;/They have']
s=['Kate, when France','France is mine','is mine and','and I am/yours','yours then','then yours is France','France and you are mine','One woman is','woman is fair,','is fair, yet I am','yet I am well;','I am well; another','another is wise, yet I am well;','yet I am well; another virtuous,','another virtuous, yet I am well;','well; but till all','all graces be','be in one woman','one woman, one','one woman shall','shall not come in my grace.']
dict={}
for j,string1 in enumerate(s):
    overlaps=[]
    for i,string2 in enumerate(s):
        overlap=findoverlap(string1,string2)
        if overlap>0:
            overlaps.append((i,overlap))
    dict[j]=[1,overlaps]
    print(j,' : ',overlaps)
revorder=[]
