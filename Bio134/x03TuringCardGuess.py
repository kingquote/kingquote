import numpy.random as rnd
n = 10000
threshold = 116
worked = 0
for i in range(n):
    right = 0
    for j in range(400):
        r = rnd.randint(0,4)
        guess = rnd.randint(0,4)
        if r==guess:
            right += 1
    if right >= threshold:
        worked += 1
print('Probability of guessing right:', worked/n)