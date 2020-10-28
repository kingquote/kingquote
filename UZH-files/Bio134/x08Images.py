import numpy as np
import matplotlib as mp

h = mp.image.imread('files/08hotspring_pattern.jpg')

print('Average blue value in right border: {:.2f}'.format(np.mean(h[:,-1,2])))
print('   Average red value in top border: {:.2f}'.format(np.mean(h[0,:,0])))



h = mp.image.imread('files/08stinkbug.png')
copy = 1*h

for y in range(1,h.shape[0]-1):
    for x in range(1,h.shape[1]-1):
        for c in range(3):
            h[y,x,c] = np.mean(copy[y-1:y+2,x-1:x+2,c])
            
print('  Red value at [5,499]: {:.3f}'.format(h[5,499,0]))
print('Red value at [181,260]: {:.2f}'.format(h[181,260,1]))
print('    Mean of all pixels: {:.6f}'.format(np.mean(h)))