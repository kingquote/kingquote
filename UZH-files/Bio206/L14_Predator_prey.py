import pycxsimulator
from pylab import *
import copy as cp

prey0 = 100 # initial prey population
K = 500. # prey carrying capacity
prey_m = 0.03 # prey max movement size 
prey_d = 1.0 # prey death rate if close to predator
prey_r = 0.1 # reproduction rate of prey

pred0 = 30 # initial predator population
pred_m = 0.05 # prey max movement size
pred_d = 0.1 # predator death rate by starvation 
pred_r = 0.5 # reproduction rate of predator

r = 0.02 # radius of proximity

class agent: # define agent class for preys and predators
    pass

def initialise():
    # we need to start with empty lists of
    # agents, data on prey and predators
    # global elements so that their values can be used by other functions
    global agents, preydata, preddata
    agents = []
    preydata = []
    preddata = []
    for i in range(prey0 + pred0):
    # prey0 + pred0 is total number of agents    
        ag = agent() 
        ag.type = 'prey' if i < prey0 else 'pred' 
        # creates prey0 preys and pred0 predators
        ag.x = random() # creates them in random x,y positions
        ag.y = random()
        agents.append(ag) # appends each created ag to agents list

def observe():
    global agents, preydata, preddata # the three lists required for plotting
    
    subplot(1, 2, 1) # subplot 1: (rows=1, columns=2, position=1 or left) 
    cla() # clear previous plot
    preys = [ag for ag in agents if ag.type == 'prey'] # select preys
    if len(preys) > 0: # if there is still any prey alive
        x = [ag.x for ag in preys] # plot in space
        y = [ag.y for ag in preys]
        plot(x, y, 'b.') # plot in blue, small circle
    predators = [ag for ag in agents if ag.type == 'pred'] #select predators
    if len(predators) > 0:
        x = [ag.x for ag in predators]
        y = [ag.y for ag in predators]
        plot(x, y, 'ro') # red, large circles
    axis('image') # fits plot into limits below
    axis([0, 1, 0, 1]) # x (0, 1) and y (0, 1) limits 

    subplot(1, 2, 2) # rows 1, columns 2, position 2 =  right
    cla()
    plot(preydata, label = 'prey') # plots prey and pred populations
    plot(preddata, label = 'predator')
    legend() # show label above as legend

def update_agent(): # this will update one agent asynchronously, not all live agents
    global agents
    if agents == []: # if all agents are dead, do nothing
        return
    ag = choice(agents) # otherwise select an agent to update

    # simulating random movement
    m = prey_m if ag.type == 'prey' else pred_m # select rates
    ag.x += uniform(-m, m)
    ag.y += uniform(-m, m)
    ag.x = 1 if ag.x > 1 else 0 if ag.x < 0 else ag.x # agent must stay within plot area 
    ag.y = 1 if ag.y > 1 else 0 if ag.y < 0 else ag.y

    # detecting a close agent
    neighbours = [nb for nb in agents if nb.type != ag.type 
                 and (ag.x - nb.x)**2 + (ag.y - nb.y)**2 < r**2]
                # above: if distance to an agent of the other 
                # type is less than radius, include it in neighbour list
    if ag.type == 'prey': # if agent is prey
        if len(neighbours) > 0: # if there are predators nearby
            if random() < prey_d: # agent dies with proability prey_d
                agents.remove(ag)
                return
        if random() < prey_r*(1-sum([1 for x in agents if x.type == 'prey'])/K):
            agents.append(cp.copy(ag))
            # above: prey reproduces with rate prey_r,
            # times how close it is to carrying capacity
            # offspring is a copy of parent, and is appended to agents list
    else: # if agent is predator
        if len(neighbours) == 0: # if there are no preys nearby
            if random() < pred_d: # predator dies with rate pred_d
                agents.remove(ag)
                return
        else: # if there are prey nearby
            if random() < pred_r: # predator reproduces with rate pred_r
                agents.append(cp.copy(ag)) # offspring is a copy of parent and added to agents list 
               
#EX1                
#def update():
#    global agents, preydata, preddata, preymob, predmob
#    t = 0.
#    while t < 1. and len(agents) > 0:
#        t += 1. / len(agents)
#        update_agent()

    preydata.append(sum([1 for x in agents if x.type == 'prey'])) # counts agents per type in each round
    preddata.append(sum([1 for x in agents if x.type == 'pred']))

pycxsimulator.GUI().start(func=[initialise, observe, update_agent])
