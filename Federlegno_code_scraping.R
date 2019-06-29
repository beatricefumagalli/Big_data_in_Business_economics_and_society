#####################################################################
#MERIDIANI  ---> Azienda appartenete alla lista per cui fare scraping
#####################################################################
#Setting working directory:
setwd("C:/Users/Beatrice/Documents/CLAMSES/BD_business")

#Import delle librerie:
library(tidyverse)
library(rvest)

#1) Homepage
#Selezione dell'url:
base_url <- "http://www.meridiani.it/"
webpage <- read_html(base_url)  

#Scraping delle singole sezioni:
home1<-html_nodes(webpage,".f-light") 
h1 <- as.character(html_text(home1,trim = T))

home2<-html_nodes(webpage,".div_h2") 
h2 <- as.character(html_text(home2,trim = T))

home3<-html_nodes(webpage,".div_p") 
h3 <- as.character(html_text(home3,trim = T))

home4<-html_nodes(webpage,"h1") 
h4 <- as.character(html_text(home4,trim = T))

home5<-html_nodes(webpage,".div_h1") 
h5 <- as.character(html_text(home5,trim = T))

#2) Pagina interna: Chi siamo:
#Selezione dell'url:
base_url <- "http://www.meridiani.it/en-us/company"
webpage <- read_html(base_url)  

#Scraping delle singole sezioni:
chisiamo1<-html_nodes(webpage,"h1") 
cs1 <- as.character(html_text(chisiamo1,trim = T))

chisiamo2<-html_nodes(webpage,"p") 
cs2 <- as.character(html_text(chisiamo2,trim = T))

chisiamo3<-html_nodes(webpage,".div_p") 
cs3 <- as.character(html_text(chisiamo3,trim = T))
(cs3=unlist(strsplit(gsub("\r"," ",cs3),split="  ")))
(cs3=unlist(strsplit(gsub("\n"," ",cs3),split="  ")))

chisiamo4<-html_nodes(webpage,".div_h1") 
cs4 <- as.character(html_text(chisiamo4,trim = T))

#Salvataggio di tutte le sezioni in un unico vettore:
testo<-c(h1,h2,h3,h4,h5,cs1,cs2,cs3,cs4)

#Export del testo in csv:
write.csv(testo,"Meridiani.csv",row.names = F)


#Il medesimo procedimento va ripetuto manulamente per ognuna della aziende.