import numpy as np

def special_dilation(im):
    for i in range(im.shape[0]):           #rows
        for j in range(im.shape[1]-1):     #columns except left border
            for k in range(im.shape[2]):   #color channels
                if im[i][j][k] < im[i][j+1][k]:
                    im[i][j][k]=im[i][j+1][k]
    return im

im = np.array([[[0.6,0.5,0.7],[0.0,0.3,0.2],[0.7,0.5,0.1]],\
               [[0.4,0.8,0.7],[0.5,0.3,0.2],[0.6,0.5,0.3]],\
               [[0.7,0.7,0.6],[0.8,0.4,0.3],[0.4,0.8,0.3]]])
    
im_new = special_dilation(im)
print (im_new)
print (np.sum(im_new))


#Wanted Output (each Pixel Value replaced by maximum between itself and its right neighbour)
#[[[ 0.6  0.5  0.7]
#  [ 0.7  0.5  0.2]
#  [ 0.7  0.5  0.1]]
#
# [[ 0.5  0.8  0.7]
#  [ 0.6  0.5  0.3]
#  [ 0.6  0.5  0.3]]
#
# [[ 0.8  0.7  0.6]
#  [ 0.8  0.8  0.3]
#  [ 0.4  0.8  0.3]]]
#14.8