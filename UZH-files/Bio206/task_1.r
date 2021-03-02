##Init
library("readxl")
try(setwd(dirname(rstudioapi::getActiveDocumentContext()$path)), silent = TRUE)
#not necessary in VSCode, just let it error out there

##Data Ingest
m_participants <- read_excel("plant_participants.xlsx")
m_plants <- read_excel("plant_knowledge.xlsx")

##Pre-Prep
#individuals
m_participants <- subset(m_participants, select = -c(6))
nrow(m_participants) == length(unique(m_participants$id))
#True means no repetitions in id

#plants
m_plants <- subset(m_plants, select = -c(5, 17, 25, 27))

##Data Prep
#create_dyads
m_dyads <- data.frame(t(combn(m_participants$id, 2)))
colnames(m_dyads) <- c("id1", "id2")

#two id columns; let's add sex of id1
#we need to merge files m_dyads and m_participants by id;
#we are matching m_dyads$id1 and m_participants$id

#merge
m_dyads <- merge(m_dyads, m_participants, by.x = "id1", by.y = "id")

#change column sex to sex1
colnames(m_dyads)[c(3, 4, 5, 6, 7)] <-
    c("camp1", "sex1", "age1", "born1", "learned1")

#add id2 sex
m_dyads <- merge(m_dyads, m_participants, by.x = "id2", by.y = "id")

#reordering columns and rows
m_dyads <- m_dyads[, c(2, 1, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12)]
m_dyads <- m_dyads[order(m_dyads$id1), ]
#change sex to sex2
colnames(m_dyads)[c(8, 9, 10, 11, 12)] <-
    c("camp2", "sex2", "age2", "born2", "learned2")

#creating dyad variables

#dyad id: paste ids together
m_dyads$dyadid <- paste(m_dyads$id1, m_dyads$id2, sep = "_")

#dyad sex
#paste0: no space
#this is better as mf becomes fm
m_dyads$dyadsex <- paste0(pmin(m_dyads$sex1, m_dyads$sex2),
                          pmax(m_dyads$sex1, m_dyads$sex2))
#variable same vs different sex
m_dyads$dyadsamesex <- ifelse(m_dyads$dyadsex == "mm" |
                        m_dyads$dyadsex == "ff", 1, 0)

#plant knowledge
nplants <- ncol(m_plants) - 1
nindiv <- nrow(m_plants)
ndyads <- nrow(m_dyads)
#replicate lines to match number of shared traits per dyad (=plant number)
m_dyads <- m_dyads[rep(1:ndyads, each = nplants), ]

#create plant knowledge column in m_dyads file
#repeat=  number of_plants; times = nymber of_dyads
m_dyads$plant <- rep(1:nplants, times = ndyads)

#create a file with plant knowledge and shared plant knowledge
#make a file with id and plant
m_plants2 <- m_plants[rep(1:nindiv, each = nplants), ]
#but only want the id column
m_plants2 <- subset(m_plants2, select = id)
#change it to id1
colnames(m_plants2)[1] <- "id1"
#add plant column
m_plants2$plant <- rep(1:nplants, times = nindiv)

#create a plant knowledge column
#transpose whole m.plant file into single column of plant knowledge
#but first exclude the columns that are not about plant knowledge
m_plants3 <- subset(m_plants, select = -c(id))
m_plants2$know <- c(t(m_plants3))

#merge_dyads and plant file
#first include id1 knowledge
m_dyads <- merge(m_dyads, m_plants2, by = c("id1", "plant"))
#reorder by id
m_dyads <- m_dyads[order(m_dyads$id1, m_dyads$id2), ]
#id1 knowledge: change name from know to know1
colnames(m_dyads)[17] <- "know1"

#then id2 knowledge
#change column names to allow proper matching
colnames(m_plants2)[1] <- "id2"
colnames(m_plants2)[3] <- "know2"
m_dyads <- merge(m_dyads, m_plants2, by = c("id2", "plant"))
#reorder columns and rows
index <- grep("^dyadid$", colnames(m_dyads))
cols <- ncol(m_dyads)
m_dyads <- m_dyads[c(3, 1, index, 4:(index - 1),
    (index + 1):(cols - 2), 2, cols - 1, cols)]
m_dyads <- m_dyads[order(m_dyads$id1, m_dyads$id2), ]

#create shared knowledge variable
m_dyads$shared <- ifelse(m_dyads$know1 == 1 & m_dyads$know2 == 1, 1, 0)