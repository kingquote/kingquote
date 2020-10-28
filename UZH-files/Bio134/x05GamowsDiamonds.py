bases = ['A','C','G','T']
diamonds = []
solution = []
for i in range(20):
    solution.append([])
    
for b1 in bases:
    for b2 in bases:
        for b3 in bases:
            for b4 in bases:
                known = 0
                diamond = []
                cd1 = b1+b2+b3+b4
                cd2 = b1+b4+b3+b2
                cd3 = b3+b4+b1+b2
                cd4 = b3+b2+b1+b4
                for i,x in enumerate(diamonds):
                    if cd1 in x:
                        known = 1
                if b2 == 'A':
                    opposite = 'T'
                elif b2 == 'T':
                    opposite = 'A'
                elif b2 == 'G':
                    opposite = 'C'
                elif b2 == 'C':
                    opposite = 'G'
                if known == 0 and b4 == opposite:
                    diamond.append(cd1)
                    if not(cd2==cd1):
                        diamond.append(cd2)
                    if not(cd3==cd1 or cd3==cd2):
                        diamond.append(cd3)
                    if not(cd4==cd1 or cd4==cd2 or cd4==cd3):
                        diamond.append(cd4)
                    diamonds.append(diamond)
for b1 in bases:
    for b2 in bases:
        for b3 in bases:
            current_triple = [b1,b2,b3]
            current_opposite = [0,0,0]
            for i,base in enumerate(current_triple):
                if base == 'A':
                    current_opposite[i] = 'T'
                elif base == 'T':
                    current_opposite[i] = 'A'
                elif base == 'G':
                    current_opposite[i] = 'C'
                elif base == 'C':
                    current_opposite[i] = 'G'
            base_diamond = current_triple[0]+current_triple[1]+current_opposite[2]+current_opposite[1]
            for i,d in enumerate(diamonds):
                if base_diamond in d:
                    solution[i].append(b1+b2+b3)                                     

print(solution[12][2])