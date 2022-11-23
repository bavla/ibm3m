# Analysis of multiway networks

## reorderways(MN,ord)

Reorder ways of the multiway network `MN` in the order determined in the vector `ord`. 
```
MNo <- reorderways(MN,c("year","prog","prov","univ")) 
```

## slice(MN,P)

Extract from the multiway network `MN` a subnetwork of links satisfying a predicate `P` on links columns.
```
MS <- slice(MN,"year==3")
```

```

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

```

```
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

```

```
joinways <- function(MN,way1,way2,way3,sep="÷"){
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

```

```
projection <- function(MN,way,w){
  Nw <- names(MN$ways); u <- which(Nw==way)
  nw <- length(MN$ways); nc <- ncol(MN$links)
  Nc <- names(MN$links); v <- which(Nc==w)
  S <- c((1:nw)[-u],u,v)
  MT <- MN$links[S]; Nt <- names(MT)[1:nw]
  ex <- paste("order(",paste(Nt,collapse=","),")",sep="")
  per <- with(MT,eval(str2expression(ex)))
  MP <- with(MT,MT[per,])
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

```

```
salton <- function(Co){
  Sal <- Co; diag(Sal) <- 1; n = nrow(Sal)
  for(u in 1:(n-1)) for(v in (u+1):n) Sal[v,u] <- Sal[u,v] <- Co[u,v]/sqrt(Co[u,u]*Co[v,v])
  return(Sal)
}

```

```
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

```

```
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
```

```


```


