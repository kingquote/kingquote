import pycxsimulator
from pylab import *

def setupfunct(n = 1000, r = 0.1, thresh = 0.5):
    class agent:
        pass

    def initialise():
        global agents
        agents = []
        for i in range(n):
            ag = agent()
            ag.type = randint(2)
            ag.x = random()
            ag.y = random()
            agents.append(ag)
        
    def observe():
        global agents
        cla()
        red = [ag for ag in agents if ag.type == 0]
        blue = [ag for ag in agents if ag.type == 1]
        plot([ag.x for ag in red], [ag.y for ag in red], 'ro')
        plot([ag.x for ag in blue], [ag.y for ag in blue], 'bo')
        axis('image')
        axis([0, 1, 0, 1])

    def update():
        global agents
        ag = choice(agents)
        neighbours = [nb for nb in agents
                    if (ag.x - nb.x)**2 + (ag.y - nb.y)**2 < r**2 and nb != ag]
        if len(neighbours) > 0:
            q = len([nb for nb in neighbours if nb.type == ag.type]) \
                / float(len(neighbours))
            if q < thresh:
                ag.x, ag.y = random(), random()
    funct = [initialise, observe, update]
    return(funct)
    

pycxsimulator.GUI().start(func=setupfunct(n = 100, r = 0.1, thresh = 0.5))

pycxsimulator.GUI().start(func=setupfunct(n = 1000, r = 0.1, thresh = 0.5))