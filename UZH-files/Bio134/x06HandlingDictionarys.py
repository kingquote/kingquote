person = {}

person['darwin'] = ['Charles Darwin',
                    '12 February 1809','19 April 1882']
person['shakespeare'] = ['William Shakespeare',
                    '26 April 1564','23 April 1616']
person['cervantes'] = ['Miguel de Cervantes',
                    '29 September 1547','23 April 1616']
person['lincoln'] = ['Abraham Lincoln',
                    '12 February 1809','15 April 1865']

dict = {} #death date as key, full name as value

for x in person.keys():
    if person[x][2] in dict:
        dict[person[x][2]].append(person[x][0])
    else:
        dict[person[x][2]] = [person[x][0]]
    
print(dict)