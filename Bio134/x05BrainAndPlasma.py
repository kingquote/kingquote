file_brain = open('files/05human_brain_proteins.csv', 'r')
raw_brain=file_brain.readlines()
file_brain.close()
del raw_brain[0]
file_plasma = open('files/05human_plasma_proteins.csv', 'r')
raw_plasma=file_plasma.readlines()
file_plasma.close()
del raw_plasma[0]

brain_content = []
plasma_content = []
both = []
plasma_only = []
brain_only = []
temp = []

for i,x in enumerate(raw_brain):
    temp = x.split(',')
    brain_content.append(temp[0])
for i,x in enumerate(raw_plasma):
    temp = x.split(',')
    plasma_content.append(temp[0])
    
for i,x in enumerate(brain_content):
    if x in plasma_content:
        both.append(x)
    else:
        brain_only.append(x)
for i,x in enumerate(plasma_content):
    if not (x in brain_content):
        plasma_only.append(x)
        
brain_only = sorted(brain_only)
plasma_only = sorted(plasma_only)
both = sorted(both)

print('len(brain_content)=',len(brain_content))
print('len(plasma_content)=',len(plasma_content))
print('len(brain_only)=',len(brain_only))
print('brain_only[567]=',brain_only[567])
print('len(plasma_only)=',len(plasma_only))
print('plasma_only[567]=',plasma_only[567])
print('len(both)=',len(both))
print('both[567]=',both[567])