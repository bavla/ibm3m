# MWnets 0.0
# by Vladimir Batagelj, November 2022
# https://github.com/bavla/ibm3m/tree/master/multiway
# source("https://raw.githubusercontent.com/bavla/ibm3m/master/multiway/MWnets.R")

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
  if(is.null(w)) W <- rep(1,length(L[[u]])) else W <- L[[w]]
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

mwnX3D <- function(MN,u,v,z,w,pu=NULL,pv=NULL,pz=NULL,
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
  Nu <- MN$nodes[[u]]$ID; Nv <- MN$nodes[[v]]$ID; Nz <- MN$nodes[[z]]$ID
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

# mwnX3D(MN,"prov","univ","prog","w",maxsize=1,col=cluCol,pu=I,pv=J,pz=K,file="students08Clux.x3d")





