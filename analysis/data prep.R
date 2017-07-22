data <- read.csv("../data/data.csv") %>% tbl_df() %>%
  filter(Method %in% c("Chemical", "Bomb radiocarbon")) %>%
  mutate(MethodShort = mapvalues(Method, from = c("Chemical", "Bomb radiocarbon"), to = c("C", "R"))) %>%
  droplevels() %>%
  mutate(Order2 = mapvalues(Order, from = levels(Order),
  to = c("Ground sharks", "Horn sharks", "Mackerel sharks", "Stingrays and relatives", 
   "Carpet sharks", "Skates and guitarfishes", "Dogfish", "Angel sharks"))) %>%
  mutate(Taxon = mapvalues(Order, from = levels(Order), to = c("Shark", "Shark", "Shark", "Ray", "Shark", "Ray", "Shark", "Shark"))) %>%
  separate(Structure, into = c("Structure", "Prep"), sep = "-") %>%
  separate(Species, into = c("G", "spp"), sep = " ", remove = F) %>%
  mutate(G = substring(G, 1, 1)) %>%
  mutate(Freq = factor(Freq, levels(Freq)[c(1, 2, 3, 5, 4)])) %>%
  mutate(Age.underestimation = factor(Age.underestimation, levels(Age.underestimation)[c(3,2,1)])) %>%
  mutate(Max.overall = pmax(Max.vertebral.age, Max.actual.age, na.rm = T)) %>%
  mutate(Valid = Max.overall - Max.vertebral.age + Max.validated - Min.validated) %>%
  mutate(Prop.valid = Valid/Max.overall, Prop.unvalid = 1 - Prop.valid)
  
