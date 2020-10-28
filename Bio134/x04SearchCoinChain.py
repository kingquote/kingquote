# -*- coding: utf-8 -*-

import numpy.random as rd
rd.seed(0)
chain = 1
lastnr = 0
tries = 0
while chain < 8:
    tries += 1
    r = rd.randint(1,3)
    if r == lastnr:
        chain +=1
    else:
        lastnr = r
        chain = 1
print(tries)