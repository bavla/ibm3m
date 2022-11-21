reorderways <- function(MN,ord){
  Cols <- colnames(MN$links); info <- MN$info
  if(!is.numeric(ord)) ord <- match(ord,Cols)
  nc <- length(Cols); nl <- length(ord)
  MNr <- MN$links[c(ord,(nl+1):nc)]
  event <- list(op="reorderways",par=Cols[ord],date=date())
  info$trace[[length(info$trace)+1]] <- event
  return(list(format="MWnets",info=info,ways=MN$ways[ord],
    nodes=MN$nodes[ord],links=MNr))
}

# MNo <- reorderways(MN,c("year","prog","prov","univ")) 

slice <- function(MN,P){
  info <- MN$info
  MNr <- with(MN$links,MN$links[eval(str2expression(P)),])
  event <- list(op="slice",P=P,date=date())
  info$trace[[length(info$trace)+1]] <- event
  return(list(format="MWnets",info=info,ways=MN$ways,
    nodes=MN$nodes,links=MNr))
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
    nodes=MN$nodes[by],links=MNr))
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
    nodes=MN$nodes,links=MNr)) 
}

# n <- nrow(MN$links); per <- sample(1:n,n)
# Mo <- reorderlinks(MN)
# Mo <- reorderlinks(MN,per)
# Mo <- reorderlinks(MN,"order(prov,univ,prog,year)")
# str(Mo)
# head(Mo$links)

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
  return(list(format="MWnets",info=info,ways=ways,nodes=nodes,links=links)) 
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

salton <- function(Co){
  Sal <- Co; diag(Sal) <- 1; n = nrow(Sal)
  for(u in 1:(n-1)) for(v in (u+1):n) Sal[v,u] <- Sal[u,v] <- Co[u,v]/sqrt(Co[u,u]*Co[v,v])
  return(Sal)
}

