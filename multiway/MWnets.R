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

