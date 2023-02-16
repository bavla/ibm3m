# Obsolete functions
# early versions replaced by more general solutions

library(datastructures)


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
