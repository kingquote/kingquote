# -*- coding: utf-8 -*-


bases = ['A','T','C','G']
count = 1
for b1 in bases:
    for b2 in bases:
        for b3 in bases:
            if not(b1 == b2 == b3):
                if b1 == b2 or b2 == b3:
                    print(count, b1+b2+b3)
                    count += 1
     