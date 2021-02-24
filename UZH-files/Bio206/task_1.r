#proportion test: chisq on dyadsex & samesex
#logistic regression on dyadsex & samesex 


library("readxl")
#creating data frame with dyads
#t to transpose
#if there are multiple entries of the same individual, use unique(t(combn))

#create dataset
#individuals
m.participants <- read_excel("plant_participants.xlsx")
nrow(m.participants) == length(unique(m.participants$ID))
#True means no repetitions in ID


#create dyads
m.dyads <- data.frame(t(combn(m.participants$ID, 2)))
colnames(m.dyads) <- c("ID1", "ID2")

#two ID columns; let's add sex of ID1
#we need to merge files m.dyads and m.participants by ID;
#we are matching m.dyads$ID1 and m.participants$ID

#merge
m.dyads <- merge(m.dyads, m.participants, by.x="ID1", by.y ="ID")

#change column sex to sex1
colnames(m.dyads)[c(3,4,5,6,7,8)] <- c("camp1", "sex1", "age1", "born1", "born_cluster1", "learned1")

#add ID2 sex
m.dyads <- merge(m.dyads, m.participants, by.x="ID2", by.y="ID")

#reordering columns and rows
m.dyads <- m.dyads[,c(2,1,3,4,5,6,7,8,9,10,11,12,13,14)]
m.dyads <- m.dyads[order(m.dyads$ID1),]
#change sex to sex2
colnames(m.dyads)[c(9,10,11,12,13,14)] <- c("camp2", "sex2", "age2", "born2", "born_cluster2", "learned2")

#creating dyad variables

#dyad ID: paste IDs together
m.dyads$dyadID <- paste(m.dyads$ID1, m.dyads$ID2, sep = "_")

#dyad sex
#paste0: no space
#m.dyads$dyadsex <- paste0(m.dyads$sex1, m.dyads$sex2)
#this is better as mf becomes fm
m.dyads$dyadsex <- paste0(pmin(m.dyads$sex1, m.dyads$sex2),
                          pmax(m.dyads$sex1, m.dyads$sex2))
#variable same vs different sex
m.dyads$samesex <- ifelse(m.dyads$dyadsex == "mm" | m.dyads$dyadsex == "ff", 1, 0)

#plant knowledge
m.plants <- read_excel("plant_knowledge.xlsx")
nplants <- ncol(m.plants) - 1
nindiv <- nrow(m.plants)
ndyads <- nrow(m.dyads)
#replicate lines to match number of shared traits per dyad (=plant number)
m.dyads <- m.dyads[rep(1:ndyads,each=nplants),]

#create plant knowledge column in m.dyads file
#repeat=  number of plants; times = nymber of dyads 
m.dyads$plant <- rep(1:nplants, times = ndyads)

#create a file with plant knowledge and shared plant knowledge
#make a file with ID and plant
m.plants2 <- m.plants[rep(1:nrow(m.plants), each=nplants),]
#but only want the ID column
m.plants2 <- subset(m.plants2, select=ID)
#change it to ID1
colnames(m.plants2)[1] <- "ID1" 
#add plant column
m.plants2$plant <- rep(1:nplants, times = nindiv)

#create a plant knowledge column
#transpose whole m.plant file into single column of plant knowledge
#but first exclude the columns that are not about plant knowledge
m.plants3 <- subset(m.plants, select = -c(ID))
m.plants2$know <- c(t(m.plants3))

#merge dyads and plant file
#first include ID1 knowledge
m.dyads <- merge(m.dyads, m.plants2, by = c("ID1", "plant"))
#reorder by ID 
m.dyads <- m.dyads[order(m.dyads$ID1, m.dyads$ID2),]
#Id1 knowledge: change name from know to know1
colnames(m.dyads)[19] <- "know1"

#then ID2 knowledge
#change column names to allow proper matching
colnames(m.plants2)[1] <- "ID2"
colnames(m.plants2)[3] <- "know2"
m.dyads <- merge(m.dyads, m.plants2, by = c("ID2", "plant"))
#reorder columns and rows
m.dyads <- m.dyads[c(3,1,16,4,5,6,7,8,9,10,11,12,13,14,15,17,18,2,19,20)]
m.dyads <- m.dyads[order(m.dyads$ID1,m.dyads$ID2),]

#create shared knowledge variable
m.dyads$shared <- ifelse(m.dyads$know1 == 1 & m.dyads$know2 == 1, 1, 0)