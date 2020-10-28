# -*- coding: utf-8 -*-
"""
Created on Thu Sep 20 13:34:32 2018

@author: kingquote
"""

import numpy

print('Gib me da recombination frequency')
f = float(input())
if f <= 0 or f >= 0.5:
    print("Hmm that can't be right.. the frequency has to be between 0 and 0.5")
else: 
    print('The map distance is:', (-0.5) * numpy.log(1-(2*f)))