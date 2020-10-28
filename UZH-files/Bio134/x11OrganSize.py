import matplotlib.pyplot as pl
import numpy
import scipy.stats as sp
from matplotlib.patches import Polygon
from matplotlib.collections import PatchCollection

def get_list(path): #determine x,y-postions of the vertices of all cells
    fyle=open(path)
    inp=fyle.readlines()
    fyle.close
    out=[]
    for i,x in enumerate(inp):
        out.append(x.split())
    out = [list(map(int, line)) for line in out]
    return out
    
    
def cell_positions(path):  #get the x,y-positions of the vertices of all cells
    fyle=open(path)
    inp=fyle.readlines()
    fyle.close
    out=[]
    for i,x in enumerate(inp):
        out.append(x.split())
    out = [list(map(float, line)) for line in out]
    return out
    
def area(cells,vp):#calculate cell areas
    out=[]
    for i,x in enumerate(cells):
        tot=0
        for j,y in enumerate(x):
            tot+=((vp[y][0]*vp[x[j-1]][1])-(vp[y][1]*vp[x[j-1]][0]))
        out.append(tot/2)
    return out


def centroid(cells,vp,areas): #calculate positions of cell centroid and distance of centroid to wingdisc center
    out1=[]
    out2=[]
    for i,x in enumerate(cells):
        totx=0
        toty=0
        for j,y in enumerate(x):
            totx+=((vp[y][0]+vp[x[j-1]][0])*((vp[y][0]*vp[x[j-1]][1])-(vp[y][1]*vp[x[j-1]][0])))
            toty+=((vp[y][1]+vp[x[j-1]][1])*((vp[y][0]*vp[x[j-1]][1])-(vp[y][1]*vp[x[j-1]][0])))
        totx /= (6*areas[i])
        toty /= (6*areas[i])
        dist=((totx**2)+(toty**2))**0.5
        out1.append([totx,toty])
        out2.append(dist)
    return out1,out2

def plotting(areas,dist): #plot cell area against distance from wingdisc center and add a linear fit
    fig=pl.figure()
    pl.plot(dist,areas,'o')
    pl.xlabel('Distance to Center')
    pl.ylabel('Cell Area')
    
    fit = numpy.polyfit(dist,areas,1)
    print('linear fit:',fit)
    fit_fn = numpy.poly1d(fit)    
    pl.plot(dist,areas, 'yo', dist, fit_fn(dist), '--k')

    print('Spearmans:',sp.spearmanr(dist,areas))
    x=numpy.array(dist)
    y=numpy.array(areas)
    a=y[x>(max(dist)/2)]
    b=y[x<(max(dist)/2)]
    print('t-test:',sp.ttest_ind(a, b))


def draw_disc(cells,vp,areas): #draw the wing disc
    patches=[]
    for i,x in enumerate(cells):
        arr=numpy.zeros((len(x),2))
        for j,y in enumerate(x):
            arr[j][0]=vp[y][0]
            arr[j][1]=vp[y][1]
        polygon = Polygon(arr, True)
        patches.append(polygon)
        
    patches = PatchCollection(patches)
    patches.set_cmap('jet')
    for i,x in enumerate(areas):
        if x>14:
            areas[i]=14
    patches.set_array(numpy.array(areas)) #for colors
    fig=pl.figure()
    panel=fig.add_subplot(1,1,1)
    panel.add_collection(patches)
    fig.colorbar(patches)
    panel.autoscale(True)
    panel.set_aspect('equal')
    pl.show()

#do this for a small and a large disc
def analyze_disc(size):
    path=("files\wingdisc\wd-")+size
    cv=get_list(path+'\cv.txt')
    vp=cell_positions(path+('\\vp.txt'))
    areas=area(cv,vp)
    centroids,dist=centroid(cv,vp,areas)
    plotting(areas, dist)
    draw_disc(cv,vp,areas)

print('LARGE:')
analyze_disc('large')
print('\nSMALL:')
analyze_disc('small') 
