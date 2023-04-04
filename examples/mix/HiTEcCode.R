https://github.com/bavla/ibm3m/

https://github.com/bavla/ibm3m/blob/master/data/str/students.md

http://vladowiki.fmf.uni-lj.si/doku.php?id=vlado:work:2m:mwn:source

https://github.com/bavla/ibm3m

https://github.com/bavla/ibm3m/tree/master/data

--------------------------------------------------------------------------------------------
Robins Bank

> wdir <- "C:/Users/vlado/docs/papers/2022/ifcs2022/genova/MWnets/Bank"
> setwd(wdir)
> library(jsonlite)
> V <- read.table("https://raw.githubusercontent.com/bavla/ibm3m/master/data/bankArc.csv")
> names(V) <- c("P1","P2","R")
> V$w <- rep(1,nrow(V))
> S <- c("BM","DM","A1","A2","A3","T1","T2","T3","T4","T5","T6")
> P <- c("branch manager", "deputy manager", "service adviser 1",                      
+  "service adviser 2", "service adviser 3", "teller 1", "teller 2", 
+  "teller 3", "teller 4", "teller 5", "teller 6" ) 
> R <- c("Advice seeking","Close friendship","Satisfying interaction","Confiding")
> Q <- c("advice","friend","satisfy","confide")
> info <- list(network="Robins bank",
+   title="Robins: organizational structure in a bank branch",
+   by="Garry Robins",
+   ref="Pattison, etal: Statistical Evaluation of Algebraic Constraints for Social Networks. J of Math Psych, 44(2000)4, 536-568",
+   href="https://www.sciencedirect.com/science/article/pii/S0022249699912610",
+   creator="V. Batagelj",
+   date=date() )
> ways=list(P1="first person",P2="second person",R="relation")
> nodes=list(P1=data.frame(ID=S,long=P),P2=data.frame(ID=S),R=data.frame(ID=Q,long=R))
> MN <- list(format="MWnets",info=info,ways=ways,nodes=nodes,links=V,data=list())
> write(toJSON(MN),"RobinsBank.json")

https://github.com/bavla/ibm3m/blob/master/data/str/RobinsBank.md
--------------------------------------------------------------------------------------------
https://www.kaggle.com/datasets/heesoo37/120-years-of-olympic-history-athletes-and-results
http://vladowiki.fmf.uni-lj.si/doku.php?id=vlado:work:2m:mwn:olymp16
--------------------------------------------------------------------------------------------
http://vladowiki.fmf.uni-lj.si/doku.php?id=vlado:work:2m:mwn:x3d:inline
http://vladowiki.fmf.uni-lj.si/doku.php?id=vlado:work:2m:mwn:bank:x3d0
https://castle-engine.io/view3dscene.php
https://www.x3dom.org/

--------------------------------------------------------------------------------------------
> source("https://raw.githubusercontent.com/bavla/ibm3m/master/multiway/MWnets.R")
> Cou <- projection(MN,"P1","w")
> Sau <- salton(Cou); Du <- as.dist(1-Sau); Du[is.na(Du)] <- 1
> tu <- hclust(Du,method="ward")
> plot(tu,hang=-1,cex=1,main="Robins Bank - P1 / Ward")

> Cov <- projection(MN,"P2","w")
> Sav <- salton(Cov); Dv <- as.dist(1-Sav); Dv[is.na(Dv)] <- 1
> tv <- hclust(Dv,method="ward")
> plot(tv,hang=-1,cex=1,main="Robins Bank - P2 / Ward")

> clrs <- c("green4","tomato3","gold1","cadetblue3")
> pie(rep(1,4), col=clrs)
> CC <- col2rgb(clrs)/255
> Col <- cbind(CC[1,MN$links$R],CC[2,MN$links$R],CC[3,MN$links$R])
> MN$nodes$P2$long <- MN$nodes$P1$long
> I <- inv(tu$order); J <- inv(tv$order); K <- c(3,4,1,2)
> mwnX3D(MN,"P1","P2","R","w",maxsize=0.95,pu=I,pv=I,pz=K,
+   lu="long",lv="long",col=Col,file="RbankClu1.x3d")
> mwnX3D(MN,"P1","P2","R","w",maxsize=0.95,pu=J,pv=J,pz=K,
+   lu="long",lv="long",col=Col,file="RbankClu2.x3d")
> mwnX3D(MN,"P1","P2","R","w",maxsize=0.95,pu=I,pv=J,pz=K,
+   lu="long",lv="long",col=Col,file="RbankClu3.x3d")

> Da <- (Du+Dv)/2; ta <- hclust(Da,method="ward")
> plot(ta,hang=-1,cex=1,main="Robins Bank - P1+P2 / Ward")
> L <- inv(ta$order)
> mwnX3D(MN,"P1","P2","R","w",maxsize=0.95,pu=L,pv=L,pz=K,
+   lu="long",lv="long",col=Col,file="RbankClu4.x3d")
--------------------------------------------------------------------------------------------
EU airports

http://complex.unizar.es/~atnmultiplex/
https://github.com/bavla/ibm3m/blob/master/data/str/AirEu2013.md

Pajek: http://mrvar.fdv.uni-lj.si/pajek/

> wdir <- "C:/Users/vlado/DL/data/multi/cores/air"; setwd(wdir)
> library(jsonlite)
> source("https://raw.githubusercontent.com/bavla/Rnet/master/R/Pajek.R")
> source("https://raw.githubusercontent.com/bavla/ibm3m/master/multiway/MWnets.R")
> MN <- fromJSON("https://raw.githubusercontent.com/bavla/ibm3m/master/data/AirEu2013Ext.json")
> str(MN)
> Net <- flatten(MN,"w",c("airA","airB"))
> head(Net$links)
> mwn2net(Net,"airA","airB",ID1="long",ID2="long",w="w",twomode=FALSE,Net="lines.net")


Clustering

> setwd("C:/test/cores")
> library(jsonlite)
> library(Polychrome)
> source("https://raw.githubusercontent.com/bavla/ibm3m/master/multiway/MWnets.R")
> MN <- fromJSON("https://raw.githubusercontent.com/bavla/ibm3m/master/data/AirEu2013Ext.json")
> str(MN)
> MN$nodes$line$short <- substr(MN$nodes$line$ID,1,4)
> Cou <- projection(MN,"airA","w")
> Sau <- salton(Cou); Du <- as.dist(1-Sau); Du[is.na(Du)] <- 1
> tu <- hclust(Du,method="ward")
> plot(tu,hang=-1,cex=0.2,main="EU airports - airports / Ward")
> Coz <- projection(MN,"line","w")
> Saz <- salton(Coz); Dz <- as.dist(1-Saz); Dz[is.na(Dz)] <- 1
> tz <- hclust(Dz,method="ward")
> plot(tz,hang=-1,cex=0.8,main="EU airports - companies / Ward")
> I <- inv(tu$order); K <- inv(tz$order) 
> CC <- col2rgb(createPalette(37,c("#ff0000","#00ff00","#0000ff")))/255
> Col <- cbind(CC[1,MN$links$line],CC[2,MN$links$line],CC[3,MN$links$line])
> mwnX3D(MN,"airA","airB","line","w",maxsize=0.85,pu=I,pv=I,pz=K,lu="long",lv="long",
+   col=Col,file="EUair.x3d")
> row.names(Cou) <- MN$nodes$airA$long  
> svg("airports.svg",width=18,height=8)
> plot(tu,hang=-1,cex=0.2,main="EU airports - airports / Ward")
> dev.off()


http://vladowiki.fmf.uni-lj.si/doku.php?id=vlado:work:svg:ex2
SVG viewer  http://vladowiki.fmf.uni-lj.si/doku.php?id=vlado:work:todo:svg
http://vladowiki.fmf.uni-lj.si/doku.php?id=vlado:work:2m:mwn:x3d:airports
--------------------------------------------------------------------------------------------
Node properties

> wdir <- "C:/Users/vlado/DL/data/multi/cores/air"
> setwd(wdir)
> library(jsonlite)
> source("https://raw.githubusercontent.com/bavla/ibm3m/master/multiway/MWnets.R")
> MN <- fromJSON("https://raw.githubusercontent.com/bavla/ibm3m/master/data/AirEu2013Ext.json")
> str(MN)
> cw <- c("airA","airB","line")
> # complete selection  
> C <- lapply(cw, \(x) 1:nrow(MN$nodes[[x]])); names(C) <- cw
> for(line in 1:37) cat(line,MN$nodes$line$ID[line],pWsum(MN,line,c(3,1,2),C,"w"),"\n")
> Dep <- rep(0,450)
> for(a in 1:450) Dep[a] <- pWsum(MN,a,c(1,2,3),C,"w")
> I <- order(Dep,decreasing=TRUE)
> top20=Dep[I[1:20]]
> names(top20) <- MN$nodes$airA$long[I[1:20]]
> top20
> Lin <- rep(0,37)
> for(line in 1:37) Lin[line] <- pWsum(MN,line,c(3,1,2),C,"w")
> I <- order(Lin,decreasing=TRUE)
> top10 <- Lin[I[1:10]]
> names(top10) <- MN$nodes$line$ID[I[1:10]]
> top10
--------------------------------------------------------------------------------------------
EU Airports / cores

> source("https://raw.githubusercontent.com/bavla/Rnet/master/R/Pajek.R")
> source("https://raw.githubusercontent.com/bavla/ibm3m/master/multiway/MWnets.R")
> cw <- c("airA","airB")
> ci <- unname(sapply(cw,\(x) which(names(MN$ways)==x)))
> pDIV <- function(MN,v,cip,C,...) pDiv(MN,v,cip,C,way="line")
> P <- list(
+   p1 = list(p = pDIV, t = 10, cwp = c("airA","airB"), cip = NULL),
+   p2 = list(p = pDIV, t = 10, cwp = c("airB","airA"), cip = NULL),
+   cways = list(cw=cw,ci=ci)  )
> for(i in 1:(length(P)-1)) P[[i]]$cip <- unname(sapply(P[[i]]$cwp,\(x) which(cw==x)))
> str(P)
> P[[1]]$t <- 13; P[[2]]$t <- 13
> CC <- MWcore(MN,P)
> listCore(MN,CC,P)
> Ap <- MN$nodes$airA$long[CC[[1]]]

> w1 <- CC$airA; w2 <- CC$airB
> Score <- extract(MN,c("airA","airB"),c("w1","w2"))
> act <- as.integer(names(table(Score$links$line)))
> Rcore <- extract(Score,"line","act")
> str(Rcore)
> c27 <- glasbey.colors(27); CC <- col2rgb(c27)/255
> Col <- cbind(CC[1,Rcore$links$line],CC[2,Rcore$links$line],CC[3,Rcore$links$line])
> ts <- c(1,20,10,26,27,19,24,9,7,8,21,13,18,4,2,15,11,23,6,22,5,16,3,12,14,17,25,28)
> t <- inv(ts)
> qs <- c(1,5,10,19,3,7,12,4,16,13,21,8,20,6,11,18,17,2,23,9,15,24,25,14,22,27,26)
> qq <- inv(qs)
> mwnX3D(Rcore,"airA","airB","line","w",pu=t,pv=t,pz=qq,lu="long",lv="long",maxsize=0.85,
+   col=Col,file="EuAirCore13.x3d")

> percents(MN,Rcore,"airA","airB","line","w")

C:\Users\vlado\DL\data\multi\cores\air

--------------------------------------------------------------------------------------------
Additional datasets
http://vladowiki.fmf.uni-lj.si/doku.php?id=vlado:work:2m:mwn
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------





