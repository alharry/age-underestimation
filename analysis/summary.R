# Summary statistics and data analysis

# All records
nstudy <- n_distinct(data$Study)
byMethod <- group_by(data, Study, Method) %>% summarise() %>% group_by(Method) %>% 
  summarise(n = n())

# Now remove studies that can't be used
data1 <- filter(data, !is.na(Age.underestimation))
nspp <- n_distinct(data1$Species)
taxon <- table(data1$Taxon)
byOrder <- with(data1, tapply(Order, Taxon, n_distinct)) %>% t() %>% data.frame()
byGenus <- with(data1, tapply(Genus,Taxon,n_distinct)) %>% t() %>% data.frame()
bySpp <- with(data1, tapply(Species, Taxon, n_distinct)) %>% t() %>% data.frame()
Structure <- with(data1, table(Structure, Prep))
Underestimate <- with(data1, table(Method, Age.underestimation))
PostFrancis <- with(filter(data1, Year > 2007, Method == "Bomb radiocarbon"), table(Age.underestimation))
DeltaMeanMean <- with(filter(data1, Method == "Bomb radiocarbon", Age.underestimation == "Yes"), mean(Magnitude.mean, na.rm = T)) %>% round(0)
DeltaMaxMean <- with(filter(data1, Method == "Bomb radiocarbon", Age.underestimation == "Yes"), mean(Magnitude.max, na.rm = T)) %>% round(0)
DeltaMeanRange <- with(filter(data1, Method == "Bomb radiocarbon", Age.underestimation == "Yes"), range(Magnitude.mean, na.rm = T))
DeltaMaxRange <- with(filter(data1, Method == "Bomb radiocarbon", Age.underestimation == "Yes"), range(Magnitude.max, na.rm = T))
UnderestimateGenus <- filter(data1, Age.underestimation %in% c("Yes")) %>%  summarise(n_distinct(Genus))
UnderSpecies <- filter(data1, Age.underestimation == "Yes") %>% group_by(Method) %>%  summarise(n_distinct(Method, Species))
UnderGenus <- filter(data1, Age.underestimation == "Yes") %>% group_by(Method) %>%  summarise(n_distinct(Method, Genus))

# Proportion of lifespan valid
Prop.valid <- filter(data1, Method == "Bomb radiocarbon", Age.underestimation == "Yes") %>% 
  mutate(Study = factor(paste(G, ". ", spp, " (", Region, Suffix, ")", sep = ""))) %>% 
  select(Study, Max.validated, Max.actual.age) %>% 
  mutate(Prop.valid = round(Max.validated/Max.actual.age, 2) * 100) %>% 
  arrange(desc(Prop.valid))

data1 <- mutate(data1, Max.overall = pmax(Max.vertebral.age, Max.actual.age,  na.rm = T)) %>% 
  mutate(Valid = Max.overall - Max.vertebral.age + Max.validated - Min.validated) %>% 
  mutate(Prop.valid = Valid/Max.overall, Prop.unvalid = 1 - Prop.valid)

# Now analyse individual data
dataIND <- read_csv("../data/data1.csv") %>% mutate(Agedif = Age/Count) %>% 
  mutate(Agedif2 = Age - Count) %>% mutate(Agedif2 = ifelse(Agedif2 < 0, 0, Agedif2)) %>% 
  mutate(Length = Length/Linf, Age = Age/Amax) %>% 
  mutate(Binary = as.numeric(ifelse(Agedif2 > 0, T, F)))

# Model incidence as a function of length and age seprately
m1 <- glm(Binary ~ Length, family = binomial(logit), filter(dataIND, Agedif < 3))
m2 <- glm(Binary ~ Age, family = binomial(logit), filter(dataIND, Agedif < 3))

