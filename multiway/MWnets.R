# MWnets 0.0
# by Vladimir Batagelj, November 2022
# https://github.com/bavla/ibm3m/tree/master/multiway
# source("https://raw.githubusercontent.com/bavla/ibm3m/master/multiway/MWnets.R")

library(datastructures)

inv <- function(p){q <- p; q[p] <- 1:length(p); return(q)}

reorderways <- function(MN,ord){
  Cols <- colnames(MN$links); info <- MN$info
  if(!is.numeric(ord)) ord <- match(ord,Cols)
  nc <- length(Cols); nl <- length(ord)
  MNr <- MN$links[c(ord,(nl+1):nc)]
  event <- list(op="reorderways",par=Cols[ord],date=date())
  info$trace[[length(info$trace)+1]] <- event
  return(list(format="MWnets",info=info,ways=MN$ways[ord],
    nodes=MN$nodes[ord],links=MNr,data=MN$data))
}

# MNo <- reorderways(MN,c("year","prog","prov","univ")) 

slice <- function(MN,P){
  info <- MN$info
  MNr <- with(MN$links,MN$links[eval(str2expression(P)),])
  event <- list(op="slice",P=P,date=date())
  info$trace[[length(info$trace)+1]] <- event
  return(list(format="MWnets",info=info,ways=MN$ways,
    nodes=MN$nodes,links=MNr,data=MN$data))
}

# MS <- slice(MN,"year==3")

flatten <- function(MN,col,by,FUN="sum"){
  Cols <- colnames(MN$links); byList <- list()
  if(!is.numeric(col)) col <- which(Cols==col)
  if(!is.numeric(by)) by <- match(by,Cols)
  for(i in 1:length(by)) byList[i] <- MN$links[by[i]]
  MNr <- aggregate(MN$links[col],by=byList,FUN=FUN)
  colnames(MNr) <- c(Cols[by],Cols[col])
  event <- list(op="flatten",par=Cols[c(by,col)],FUN=FUN,date=date())
  info <- MN$info
  info$trace[[length(info$trace)+1]] <- event
  return(list(format="MWnets",info=info,ways=MN$ways[by],
    nodes=MN$nodes[by],links=MNr,data=MN$data))
}

# MNf <- flatten(MN,5,c(4,1,2))
# Mf <- flatten(MN,"w",c("prov","univ"))
# head(Mf$links)

reorderlinks <- function(MN,per=NULL){
  info <- MN$info; P <- "user"
  if(is.null(per)){n <- nrow(MN$links); per <- sample(1:n,n); P <- "random"} else
  if(length(per)==1){P <- per; per <- with(MN$links,eval(str2expression(per)))}
  MNr <- with(MN$links,MN$links[per,])
  event <- list(op="reorderlinks",per=P,date=date())
  info$trace[[length(info$trace)+1]] <- event
  return(list(format="MWnets",info=info,ways=MN$ways,
    nodes=MN$nodes,links=MNr,data=MN$data)) 
}

# n <- nrow(MN$links); per <- sample(1:n,n)
# Mo <- reorderlinks(MN)
# Mo <- reorderlinks(MN,per)
# Mo <- reorderlinks(MN,"order(prov,univ,prog,year)")
# str(Mo)
# head(Mo$links)

joinways <- function(MN,way1,way2,way3,sep="#"){
  info <- MN$info; Nw <- names(MN$ways)
  Nu <- MN$nodes[[way1]]$ID; Nv <- MN$nodes[[way2]]$ID
  i <- which(Nw==way1); j <- which(Nw==way2)
  U <- Nu[MN$links[[i]]]; V <- Nv[MN$links[[j]]]
  UV <- paste(U,V,sep=sep); UP <- factor(UV)
  event <- list(op="joinways",ways=c(way1,way2,way3),sep=sep,date=date())
  info$trace[[length(info$trace)+1]] <- event
  lab <- paste(MN$ways[[way1]],MN$ways[[way2]],sep=" and ")
  ways <- MN$ways[-c(i,j)]; ways[[way3]] <- lab 
  nodes <- MN$nodes[-c(i,j)]; nodes[[way3]] <- data.frame(ID=levels(UP))
  nw <- length(MN$ways); nc <- ncol(MN$links)
  links <- MN$links[1:nw][-c(i,j)]; links[way3] <- as.integer(UP)
  links <- cbind(links,MN$links[(nw+1):nc])
  return(list(format="MWnets",info=info,ways=ways,nodes=nodes,
    links=links,data=MN$data)) 
}

# Mj <- joinways(MN,"prog","univ","prun")

projection <- function(MN,way,w){
  Nw <- names(MN$ways); u <- which(Nw==way)
  nw <- length(MN$ways); nc <- ncol(MN$links)
  Nc <- names(MN$links); v <- which(Nc==w)
  S <- c((1:nw)[-u],u,v)
  MT <- MN$links[S]; Nt <- names(MT)[1:nw]
  ex <- paste("order(",paste(Nt,collapse=","),")",sep="")
  per <- with(MT,eval(str2expression(ex)))
  MP <- MT[per,]
  I <- c(1); nm <- nw-1; nS <- length(MN$nodes[[way]]$ID)
  for(i in 2:nrow(MP)) if(!all(MP[i-1,1:nm]==MP[i,1:nm])) I <- c(I,i)
  I <- c(I,nrow(MP)+1)
  Co <- matrix(0,nrow=nS,ncol=nS)
  colnames(Co) <- rownames(Co) <- MN$nodes[[way]]$ID
  for(i in 1:(length(I)-1)){
    i1 <- I[i]; i2 <- I[i+1]-1
    for(j in i1:i2) {
      u <- MP[[way]][j]
      for(k in j:i2){
        v <- MP[[way]][k]
        Co[u,v] <- Co[u,v] + MP[[w]][j] * MP[[w]][k]
      }    
    }
  }
  D <- diag(Co); diag(Co) <- 0; Co <- Co + t(Co); diag(Co) <- D
  return(Co)
}

# Co <- projection(MN,"prov","w")
# Co[1:10,1:15]

salton <- function(Co){
  Sal <- Co; diag(Sal) <- 1; n = nrow(Sal)
  for(u in 1:(n-1)) for(v in (u+1):n) Sal[v,u] <- Sal[u,v] <- Co[u,v]/sqrt(Co[u,u]*Co[v,v])
  return(Sal)
}

projection2 <- function(MN,way,w,z){
  Nw <- names(MN$ways); u <- which(Nw==way)
  nw <- length(MN$ways); nc <- ncol(MN$links)
  Nc <- names(MN$links); v <- which(Nc==w); t <- which(Nc==z)
  S <- c((1:nw)[-u],u,v,t) 
  MT <- MN$links[S]; Nt <- names(MT)[1:nw]
  ex <- paste("order(",paste(Nt,collapse=","),")",sep="")
  per <- with(MT,eval(str2expression(ex)))
  MP <- MT[per,]
  I <- c(1); nm <- nw-1; nS <- length(MN$nodes[[way]]$ID)
  for(i in 2:nrow(MP)) if(!all(MP[i-1,1:nm]==MP[i,1:nm])) I <- c(I,i)
  I <- c(I,nrow(MP)+1)
  Co <- matrix(0,nrow=nS,ncol=nS)
  colnames(Co) <- rownames(Co) <- MN$nodes[[way]]$ID
  for(i in 1:(length(I)-1)){
    i1 <- I[i]; i2 <- I[i+1]-1
    for(j in i1:i2) {
      u <- MP[[way]][j]
      for(k in i1:i2){
        v <- MP[[way]][k]
        Co[u,v] <- Co[u,v] + MP[[w]][j] * MP[[z]][k]
      }    
    }
  }
  return(Co)
}

# Co <- projection(MN,"prog","w")
# Co2 <- projection2(MN,"prog","w","w")
# Co2[1:10,1:10] 
# Co[1:10,1:10]
# MN$links$one <- rep(1,length(MN$links[[w]]))
# CoA <- projection2(MN,"prog","w","one")
# CoB <- projection2(MN,"prog","one","w")
# CoA[1:10,1:10]
# CoB[1:10,1:10]

recodecol2bins <- function(MN,col1,col2,bins=c(0,1e-323,Inf)){
  info <- MN$info; MNr <- MN$links
  w <- MNr[[col1]]; w1 <- rep(0,length(w))
  for(i in 1:length(w)){
    j <- 0
    while(w[i]>=bins[j+1]) j <- j+1 
    w1[i] <- j
  }
  MNr[[col2]] <- as.integer(w1)
  event <- list(op="recodecol2bins",cols=c(col1,col2),bins=bins,date=date())
  info$trace[[length(info$trace)+1]] <- event
  return(list(format="MWnets",info=info,ways=MN$ways,nodes=MN$nodes,
    links=MNr,data=MN$data)) 
}

# Mc <- recodecol2bins(MN,"w","code",bins=c(1,5,10,20,Inf))

recodeway2part <- function(MN,way1,part,way2,desc){
  info <- MN$info; Mt <- MN$links; W <- Mt[[way1]]
  R <- MN$nodes$prov[[part]]; r <- factor(R)
  C <- r[W]; Mt[[way1]] <- as.integer(C)
  N <- names(Mt); N[which(N==way1)] <- way2; names(Mt) <- N
  Mw <- MN$ways; Mw[[way1]] <- desc
  N <- names(Mw); N[which(N==way1)] <- way2; names(Mw) <- N
  Mn <- MN$nodes; Md <- MN$data
  if(way2 %in% names(Md)){
    Mn[[way1]] <- Md[[way2]]
    Md <- Md[-which(names(Md)==way2)] 
  } else {
    Mn[[way1]] <- data.frame(ID=levels(r))
  }
  N <- names(Mn); N[which(N==way1)] <- way2; names(Mn) <- N
  event <- list(op="recodeway2part",pars=c(way1,part,way2),desc=desc,date=date())
  info$trace[[length(info$trace)+1]] <- event
  return(list(format="MWnets",info=info,ways=Mw,nodes=Mn,links=Mt,data=Md)) 
}

# Mr <- recodeway2part(MN,"prov","IDreg","regs","region")
# Mre <- flatten(Mr,"w",c("regs","univ","prog","year"))

mwn2net <- function(MN,way1,way2,r=NULL,t=NULL,w=NULL,twomode=TRUE,Net="Pajek.net",encoding="UTF-8"){
  N <- MN$nodes; L <- MN$links; R <- NULL; T <- NULL
  U <- N[[way1]]$ID[L[[way1]]]; V <- N[[way2]]$ID[L[[way2]]]
  if(is.null(w)) W <- rep(1,length(L[[way1]])) else W <- L[[w]]
  if(!is.null(r)) R <- N[[r]]$ID[L[[r]]]
  if(!is.null(t)) T <- N[[t]]$ID[L[[t]]]
  uvrwt2net(U,V,w=W,r=R,t=T,Net=Net,twomode=twomode,encoding=encoding)
}

# mwn2net(S2014,"prov","univ",r="prog",w="w",Net="S2014.net")

mwn2clu <- function(MN,way,part,Clu="Pajek.clu",encoding="UTF-8"){
  C <- MN$nodes[[way]][[part]]; n <- length(C); clu <- file(Clu,"w")
  p <- factor(C); L <- levels(p)
  cat("% mwn2clu",date(),"\n% Categories:\n",file=clu)
  for(i in 1:length(L)) cat('% ',i,' "',L[i],'"\n',sep="",file=clu)
  cat("*vertices",n,"\n",file=clu)
  cat(as.integer(p),sep="\n",file=clu)
  close(clu)
}

# mwn2clu(S2014,"prov","IDreg",Clu="regions.clu")

mwn2vec <- function(MN,way,prop,Vec="Pajek.vec",encoding="UTF-8"){
  V <- MN$nodes[[way]][[prop]]; n <- length(V); vec <- file(Vec,"w")
  cat("% mwn2vec",date(),"\n*vertices",n,"\n",file=vec)
  if(is.numeric(V)) cat(V,sep="\n",file=vec) else
    for(i in 1:n) cat(i,' "',V[i],'"\n',sep='',file=vec)
  close(vec)
}

# mwn2vec(S2014,"prov","area",Vec="area.vec")
# mwn2vec(S2014,"prov","capital",Vec="capital.vec")

mwnX3D <- function(MN,u,v,z,w,pu=NULL,pv=NULL,pz=NULL,lu="ID",lv="ID",lz="ID",
  shape="Box",col=c(1,0,0),bg=c(0.8,0.8,0.8),maxsize=1,file="MWnets.x3d"){
Ha <- '<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE X3D PUBLIC "ISO//Web3D//DTD X3D 3.0//EN" "http://www.web3d.org/specifications/x3d-3.0.dtd">
<X3D version="3.0" profile="Immersive" xmlns:xsd="http://www.w3.org/2001/XMLSchema-instance" xsd:noNamespaceSchemaLocation="http://www.web3d.org/specifications/x3d-3.0.xsd">
<head>
<meta name="title" content="MWnets"/>
<meta name="created" content="'
Hb <- '"/>
<meta name="generator" content="MWnets by Vladimir Batagelj: https://github.com/bavla/ibm3m/tree/master/multiway"/>
</head>'
B <- '
<Scene>

  <Background skyColor="'

  x3d <- file(file,"w")
  n <- length(MN$links[[w]]); nu <- length(MN$nodes[[u]]$ID)
  nv <- length(MN$nodes[[v]]$ID); nz <- length(MN$nodes[[z]]$ID)
  U <- MN$links[[u]]; V <- MN$links[[v]]; Z <- MN$links[[z]]
  Nu <- MN$nodes[[u]][[lu]]; Nv <- MN$nodes[[v]][[lv]]; Nz <- MN$nodes[[z]][[lz]]
  W <- MN$links[[w]]; maxw <- max(W)
  if(is.null(pu)) pu <- 1:n
  if(is.null(pv)) pv <- 1:n
  if(is.null(pz)) pz <- 1:n

cell <- function(i){
  cat('  <Anchor description="link',i,':',Nu[U[i]],',',Nv[V[i]],
    ',',Nz[Z[i]],',',W[i],'">\n',file=x3d)
  cat('  <Transform translation="',pu[U[i]]-nu/2," ",nv/2-pv[V[i]]," ",
    pz[Z[i]]-nz/2,'">\n',sep="",file=x3d)
  cat('  <Shape>              <!-- Link ',i,' -->\n',
    ' <Appearance><Material diffuseColor="',
    if(length(col)==3) col else col[i,],
    '"/></Appearance>\n',sep=" ",file=x3d) 
  a <- maxsize*(W[i]/maxw)**(1/3)
  if(shape=="Box") cat('  <Box size="',a,a,a,'"/>\n',file=x3d) else
     cat('  <Sphere radius="',a/2,'"/>\n',file=x3d) 
  cat('  </Shape>\n  </Transform>\n  </Anchor>\n\n',file=x3d)
}

  cat(Ha,date(),Hb,"\n",sep="",file=x3d) 
  cat(B,bg,'"/>\n\n',file=x3d)
  for(i in 1:n) cell(i)
  cat('</Scene>\n</X3D>\n',file=x3d)
  close(x3d)
}

# mwnX3D(MN,"prov","univ","prog","w",lu="province",lv="long",lz="long",maxsize=0.8,col=cluCol,pu=I,pv=J,pz=K,file="students08Clux.x3d")

relCore <- function(MN,way1,way2,way3){
  U <- MN$links[[way1]]; V <- MN$links[[way2]]; R <- MN$links[[way3]]
  n <- length(MN$nodes[[way1]]$ID); dmin <- -1
  m <- length(U); act <- rep(TRUE,n); I <- 1:m; core <- rep(NA,n) 
  while(any(act)){
    C <- vector("list",n)
    for(i in I){ u <- U[i]; v <- V[i]
      if(act[u]&&act[v]){ r <- R[i]
        C[[u]] <- union(C[[u]],r); C[[v]] <- union(C[[v]],r)
      } else I <- setdiff(I, i)
    }
    deg <- sapply(C,length); dmin <- max(dmin,min(deg[act]))
    sel <- which((deg<=dmin)&act); core[sel] <- dmin; act[sel] <- FALSE
  }
  return(core)
}

# core <- relCore(MN,"airA","airB","line")

relCore2 <- function(MN,way1,way2,way3){
  U <- MN$links[[way1]]; V <- MN$links[[way2]]; R <- MN$links[[way3]]
  n1 <- length(MN$nodes[[way1]]$ID); n2 <- length(MN$nodes[[way2]]$ID)
  n <- n1+n2; dmin <- -1
  m <- length(U); act <- rep(TRUE,n); I <- 1:m; core <- rep(NA,n) 
  while(any(act)){
    C <- vector("list",n)
    for(i in I){ u <- U[i]; v <- n1+V[i]
      if(act[u]&&act[v]){ r <- R[i]
        C[[u]] <- union(C[[u]],r); C[[v]] <- union(C[[v]],r)
      } else I <- setdiff(I, i)
    }
    deg <- sapply(C,length); dmin <- max(dmin,min(deg[act]))
    sel <- which((deg<=dmin)&act); core[sel] <- dmin; act[sel] <- FALSE
  }
  res <- list(); res[[way1]] <- core[1:n1]; res[[way2]] <- core[(n1+1):n]
  return(res)
}


# core <- relCore2(S,"prov","univ","prog")

extract <- function(MN,ways,clus){
  N <- MN$nodes; L <- MN$links; info <- MN$info
  P <- paste(paste(ways,clus,sep="/"),collapse=",")
  event <- list(op="extract",P=P,date=date())
  info$trace[[length(info$trace)+1]] <- event
  OK <- rep(TRUE,nrow(MN$links))
  for(i in 1:length(ways)){ clu <- eval(str2expression(clus[i]))
    N[[ways[i]]] <- T <- N[[ways[i]]][clu,]
    if(typeof(T)=="character") N[[ways[i]]] <- data.frame(ID=as.vector(T))
    L[[ways[i]]] <- as.integer(factor(L[[ways[i]]],levels=clu))
    OK <- OK & !is.na(L[[ways[i]]])
  }
  Sc <- list(format="MWnets",info=info,ways=MN$ways,
    nodes=N,links=L[OK,],data=MN$data)
  return(Sc)
}


# Score <- extract(S10,c("prov","univ"),c("w1","w2"))

pDeg <- function(MN,u,C,way1,way2,...){
  L <- MN$links; IU <- which(L[[way1]]==u) 
  IC <- IU[L[[way2]][IU] %in% C]
  return(length(IC))
}

pSum <- function(MN,u,C,way1,way2,weight=NULL,...){
  L <- MN$links; IU <- which(L[[way1]]==u) 
  W <- L[[weight]][IU[L[[way2]][IU] %in% C]]
  return(sum(W))
}

pMax <- function(MN,u,C,way1,way2,weight=NULL,...){
  L <- MN$links; IU <- which(L[[way1]]==u) 
  W <- L[[weight]][IU[L[[way2]][IU] %in% C]]
  return(max(W))
}

pRel <- function(MN,u,C,way1,way2,way3=NULL,...){
  L <- MN$links; IU <- which(L[[way1]]==u) 
  IC <- IU[L[[way2]][IU] %in% C]
  return(length(union(NULL,L[[way3]][IC])))
}

GenCoresDec <- function(MN,way1,way2,p=NULL,...){ # way3=, weight=
  n <- nrow(MN$nodes[[1]]); C <- 1:n; core <- P <- rep(NA,n)
  L <- MN$links; H <- fibonacci_heap("numeric")
  for(v in 1:n) P[v] <- p(MN,v,C,way1,way2,...)  
  H <- insert(H,as.numeric(P),1:n); mval <- 0
  while(size(H)>0){
    t <- pop(H); val <- as.numeric(names(t)); t <- t[[1]]
    C <- setdiff(C,t); core[t] <- mval <- max(mval,val)
    IU <- which(L[[way1]]==t) 
    NtC <- IU[L[[way2]][IU] %in% C]
    for(e in NtC){
      v <- L[[way2]][e]; pv <- as.numeric(p(MN,v,C,way1,way2,...))
      hand <- handle(H,value=as.integer(v))[[1]]
      if(pv<hand$key) decrease_key(H,hand$key,pv,hand$handle)
    }
  }
  return(core)
}

report2modeCore <- function(MN,way1,way2,f1,f2,cores,short=30,...){
  n1 <- nrow(MN$nodes[[way1]]); n2 <- nrow(MN$nodes[[way2]])
  cat("Core report:\nn1 =",n1,"  n2 =",n2,"\n")
  cat("Core1:",cores$core1,"\nCore2:",cores$core2,"\n")
  F1 <- sapply(1:n1,function(u) f1(MN,u,cores$core2,way1,way2))
  F2 <- sapply(1:n2,function(v) f2(MN,v,cores$core1,way2,way1))
  if(max(n1,n2)<=short) cat("deg1:",F1,"\ndeg2:",F2,"\n\n") else{
    print(table(F1)); print(table(F2))}
}

Gen2modeCore <- function(MN,way1,way2,f1,f2,t1,t2){ # way3=, weight=
remove <- function(MN,Ha,Hb,waya,wayb,Ca,Cb,fb,ta,...){
  C <- c()
  while(size(Ha)>0) {
    top <- peek(Ha); val <- as.numeric(names(top)); u <- top[[1]]
    if(val >= ta) return(C)
    top <- pop(Ha); L <- MN$links; Ca <- setdiff(Ca,u); C <- c(C,u)
    IU <- which(L[[waya]]==u) 
    NtC <- IU[L[[wayb]][IU] %in% Cb]
    for(e in NtC){
      v <- L[[wayb]][e]; pv <- as.numeric(fb(MN,v,Ca,wayb,waya,...))
      hand <- handle(Hb,value=as.integer(v))
      if(length(hand)>0){hand <- hand[[1]]
        if(pv<hand$key) decrease_key(Hb,hand$key,pv,hand$handle)
      } 
    } 
  } 
  return(C)
}
  n1 <- nrow(MN$nodes[[way1]]); n2 <- nrow(MN$nodes[[way2]])
  C1 <- 1:n1; C2 <- 1:n2; change <- TRUE
  F1 <- sapply(1:n1,function(u) f1(MN,u,C2,way1,way2))
  F2 <- sapply(1:n2,function(v) f2(MN,v,C1,way2,way1))
  H1 <- fibonacci_heap("numeric"); H2 <- fibonacci_heap("numeric")
  H1 <- insert(H1,as.numeric(F1),C1); H2 <- insert(H2,as.numeric(F2),C2)
  while(change){change <- FALSE
    r <- remove(MN,H1,H2,way1,way2,C1,C2,f2,t1)
    if(length(r)>0) {C1 <- setdiff(C1,r); change <- TRUE}
    r <- remove(MN,H2,H1,way2,way1,C2,C1,f1,t2)
    if(length(r)>0) {C2 <- setdiff(C2,r); change <- TRUE}
    F1 <- sapply(1:n1,function(u) f1(MN,u,C2,way1,way2))
    F2 <- sapply(1:n2,function(v) f2(MN,v,C1,way2,way1))
  }
  return(list(core1=C1,core2=C2))
}

# p <- pSum
# for(v in 1:8) cat(v,p(MN,v,C,"U","V",weight="w"),"\n")
# (core <- GenCoresDec(MN,"U","V",weight="w"))
# (core <- GenCoresDec(MV,"SOURCE","TARGET",way3="LINKTYPE",p=pRel))
# (core <- GenCoresDec(MV,"SOURCE","TARGET",weight="WEIGHT",p=pSum))
# (core <- GenCoresDec(MV,"SOURCE","TARGET",p=pDeg))
# EU <- fromJSON("https://raw.githubusercontent.com/bavla/ibm3m/master/data/AirEu2013Ext.json")
# core1 <- relCore(EU,"airA","airB","line")
# core2 <- GenCoresDec(EU,"airA","airB",way3="line",p=pRel)
# cores <- Gen2modeCore(MA,"an","pl",pDeg,pDeg,4,4)
# report2modeCore(MA,"an","pl",pDeg,pDeg,cores)

DF2MWN <- function(DF,ways,w=NULL,network="test",title="Test"){
  info <- list(network=network,title=title,by="DF2MWN",date=date())
  Ways <- as.list(ways); names(Ways) <- ways
  data <- list()
  nodes <- NULL; links <- data.frame(one=rep(1,nrow(DF)))
  for(way in ways){
    q <- factor(DF[[way]])
    nodes[[way]] <- data.frame(ID=levels(q))
    links[[way]] <- as.integer(q)
  }
  for(way in w) links[[way]] <-DF[[way]]
  return(list(format="MWnets",info=info,ways=Ways,nodes=nodes,links=links,data=data)) 
}

# MT <- DF2MWN(CH,c("primary","location","arrest","domestic","ward","fbi"),
#   network="ChicagoCrime22",title="City of Chicago incidents of crime 2022")

pCnt <- function(MN,v,cip,C){ 
  OK <- function(e){
    for(j in 2:length(cip)){
      r <- cip[j]; z <- ci[r]
      if(!(MN$links[e,z] %in% C[[r]])) return(FALSE)
    }
    return(TRUE)
  } 
  I <- which(MN$links[[ci[cip[1]]]]==v)
  cnt <- 0
  for(e in I) if(OK(e)) cnt <- cnt+1
  return(cnt)
}

pWsum <- function(MN,v,cip,C,weight="w"){ # ci=ci,cip=cip,C=C
  OK <- function(e){
    for(j in 2:length(cip)){
      r <- cip[j]; z <- ci[r]
      if(!(MN$links[e,z] %in% C[[r]])) return(FALSE)
    }
    return(TRUE)
  } 
  I <- which(MN$links[[ci[cip[1]]]]==v)
  s <- 0
  for(e in I) if(OK(e)) s <- s + MN$links[e,weight]
  return(s)
}

pWmax <- function(MN,v,cip,C,weight="w"){ 
  OK <- function(e){
    for(j in 2:length(cip)){
      r <- cip[j]; z <- ci[r]
      if(!(MN$links[e,z] %in% C[[r]])) return(FALSE)
    }
    return(TRUE)
  } 
  I <- which(MN$links[[ci[cip[1]]]]==v)
  s <- 0
  for(e in I) if(OK(e)) s <- max(s, MN$links[e,weight])
  return(s)
}

pDiv <- function(MN,v,cip,C,way=NULL){ 
  OK <- function(e){
    for(j in 2:length(cip)){
      r <- cip[j]; z <- ci[r]
      if(!(MN$links[e,z] %in% C[[r]])) return(FALSE)
    }
    return(TRUE)
  } 
  I <- which(MN$links[[ci[cip[1]]]]==v)
  return(length(union(NULL,MN$links[[way]][I[sapply(I,OK)]])))
}

pAttr <- function(MN,v,cip,C,way=NULL,attr=NULL,FUN=sum){ 
  OK <- function(e){
    for(j in 2:length(cip)){
      r <- cip[j]; z <- ci[r]
      if(!(MN$links[e,z] %in% C[[r]])) return(FALSE)
    }
    return(TRUE)
  } 
  I <- which(MN$links[[ci[cip[1]]]]==v)
  U <- union(NULL,MN$links[[way]][I[sapply(I,OK)]])
  return(FUN(MN$nodes[[way]][[attr]][U]))
}


MWcore <- function(MN,P,cw,trace=FALSE){
  C <- sapply(cw, \(x) 1:nrow(MN$nodes[[x]]))
  repeat{
    exit <- TRUE
    for(w in 1:length(P)){
      cip <- P[[w]]$cip; p <- P[[w]]$p; thresh <- P[[w]]$t
      R <- c(); r <- cip[1]
      for(v in C[[r]]) {
        pv <- p(MN,v,cip,C)
        if(pv < thresh) {R <- union(R,v); exit <- FALSE}
      }
      C[[r]] <- setdiff(C[[r]],R)
      if(trace) cat(w,P[[w]]$cwp[1],r,":",cip,"/",thresh,"\n",R,"\n")
    }
    if(exit) break
  }
  return(C)
}

listCoreOld <- function(MN,C,P,sorted=TRUE){
  for(w in 1:length(P)){
    cip <- P[[w]]$cip; p <- P[[w]]$p
    nw <- nrow(MN$nodes[[P[[w]]$cwp[1]]])
    r <- cip[1]; core <- list(); N <- MN$nodes[[P[[w]]$cwp[1]]]$ID
    for(v in 1:nw) if(v %in% C[[r]]) core[[N[v]]] <- p(MN,v,cip,C)
    cat(w,P[[w]]$cwp[1],":",thresh, nw, cip,"\n")
    T <- unlist(core,use.name=TRUE); if(sorted) T <- rev(sort(T))
    print(T)
  }
}

listCore <- function(MN,C,P){
  for(i in 1:length(P)){
    cip <- P[[i]]$cip; p <- P[[i]]$p; thresh <- P[[i]]$t
    nw <- nrow(MN$nodes[[P[[i]]$cwp[1]]]); T <- rep(0,nw)
    r <- cip[1]; core <- list(); N <- MN$nodes[[cw[i]]]$ID
    for(v in 1:nw) if(v %in% C[[r]]) core[[N[v]]] <- p(MN,v,cip,C)
    cat(i,P[[i]]$cwp[1],":",thresh, nw, cip,"\n")
    print(unlist(core,use.name=TRUE))
  }
}
                 
