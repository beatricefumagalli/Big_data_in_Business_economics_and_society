#Import del dataset:
dati<-read.csv("tab_finale_parsec.csv",header=T,sep=";")

#Richiamo della libreria necessaria e eventuale istallazione:
#install.packages("parsec")
library(parsec)

#Selezione delle colonne numeriche del dataset:
#Se gli indici delle variabili dovessero cambiare modificare gli indici di selezione.
df<-dati[,4:7]
#Imputazione della ragione sociale (univoca) come nome di riga
#(questo procedimento non è necessario)
rownames(df)<-dati$azienda

#Imputazione dei profili:
pp<-pop2prof(df,labtype = "profiles")
#Visualizzazione profili:
pp$profiles

#Generazione degli indici per poter risalire dal profilo alla ragione sociale
# a cui è associato il determinato profilo.
id <- c()
for (i in 1:nrow(df)){
  id[i] <- paste(as.character(df[i,]),collapse = "")
}
n <- rownames(as.data.frame(pp$freq))
index <- match(id,n)

#Plot del diagramma di Hasse:
plot(getzeta(pp),labels)

#generazione matrice mutal ranking probability:
mrp <- MRP(getzeta(pp), method = "exact")
#Vettore contenente il ranking dei profili
rank <- svd(mrp)$v[,1]

#Creazione della variabile ranking nel dataset con ranking associato attraverso indice
#ad ogni determinata azienda.
dati$ranking <- rank[index]
#Ordinamento del dataset in base a ranking decrescente
dati<-dati[order(dati$ranking,decreasing = T),]

#Export tabella con dati ranking:
write.csv(dati,"dati_mg_ranked.csv")

#APPENDICE ANALISI:--------------------------------

#1) Analisi grafica

#Import librerie:
library(RColorBrewer)
library(ggplot2)

#Boxplot
ggplot(dati, aes(x=sistema, y=ranking, fill=sistema)) +
  geom_boxplot() + scale_fill_brewer(palette="PuBu")+ theme_light()

ggplot(dati, aes(x=dimensione, y=ranking, fill=dimensione)) +
  geom_boxplot()+ scale_fill_brewer(palette="PuBu")+ theme_light()

#Barplot
ggplot(data=dati, aes(x=reorder(azienda,-ranking), y=ranking)) +
  geom_bar(stat="identity", fill="lightseagreen")+
  geom_text(aes(label=round(ranking,3)), vjust=-0.3, size=3.5)+
  theme_minimal()+
  theme(axis.text.x=element_text(angle=30,hjust=1))


#2) Test kruskal-Wallis
medie <- dati$ranking[dati$dimensione=="media"]
grandi <- dati$ranking[dati$dimensione=="grande"]
x <- list(g1=medie,g2=grandi)
kruskal.test(x)

arr <- dati$ranking[dati$sistema=="Sistema ARREDAMENTO"]
uff <- dati$ranking[dati$sistema=="Sistema UFFICIO"]
ill <- dati$ranking[dati$sistema=="Sistema ILLUMINAZIONE"]
xs <- list(g1=arr,g2=uff,g3=ill)
kruskal.test(xs)
