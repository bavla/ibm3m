# ibm3m - indirect block modeling of 3-mode data
# Vladimir Batagelj, University of Ljubljana, Slovenia
# Bled, July 15-17, 2006
# Ljubljana, July 18-21, 2006
# http://vlado.fmf.uni-lj.si/pub/networks/progs/ibm3m.zip

D3m <- function(x,y){sum(abs(as.vector(x)-as.vector(y)))}

odd <- function(n){ 2*trunc(n/2) != n }

mod <- function(a,b){ a - b*trunc(a/b) }

show3m <- function(a){
## Remove all dimension names from an array for compact printing.
  d <- list()
  l <- 0
  for(i in dim(a)) {d[[l <- l+1]] <- rep("",i)}
  dimnames(a) <- d
  a
}

labs3m <- function(n){
  if ((n<1)|(n>61)) stop("Wrong n: d in 1:61\n")
  ch <- "123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
  lab <- vector()
  for (i in 1:n) lab[i] <- substr(ch,i,i)
  lab
}

dist3m <- function(a,t,d){
  if ((t<0)|(t>2)) stop("Wrong type: t in 0:2\n")
  do <- array()
  if (t==0) {
    if ((d<1)|(d>3)) stop("Wrong dimension: d in 1:3\n")
    if (d==2) a <- aperm(a,c(2,1,3))
    else if (d==3) a <- aperm(a,c(3,1,2))
    n <- dim(a)[1]
    labs <- dimnames(a)[[1]]
    attributes(do) <- list(Size=n,Labels=labs,Diag=FALSE,
      method='3-mode',class='dist')
    ind <- 0
    for (i in 1:(n-1)){
      for (j in (i+1):n){
        ind <- ind+1
        do[ind] <- D3m(a[i,,],a[j,,])
      }
    }
  } else if (t==1) {
    if ((d<1)|(d>3)) stop("Wrong dimension: d in 1:3\n")
    if (d==2) a <- aperm(a,c(2,1,3))
    else if (d==3) a <- aperm(a,c(3,1,2))
    n <- dim(a)[1]
    labs <- dimnames(a)[[1]]
    attributes(do) <- list(Size=n,Labels=labs,Diag=FALSE,
      method='3-mode', class='dist')
    ind <- 0
    for (i in 1:(n-1)){
      for (j in (i+1):n){
        ind <- ind+1
        do[ind] <- D3m(a[,i,-c(i,j)],a[,j,-c(i,j)]) +
                   D3m(a[,-c(i,j),i],a[,-c(i,j),j]) +
                   D3m(a[,i,j],a[,j,i]) + D3m(a[,i,i],a[,j,j])
      }
    }
  } else {
    n <- dim(a)[1]
    labs <- dimnames(a)[[1]]
    attributes(do) <- list(Size=n,Labels=labs,Diag=FALSE,
      method='3-mode', class='dist')
    ind <- 0
    for (i in 1:(n-1)){
      for (j in (i+1):n){
        ind <- ind+1
        do[ind] <- D3m(a[i,-c(i,j),-c(i,j)],a[j,-c(i,j),-c(i,j)]) +
                   D3m(a[-c(i,j),i,-c(i,j)],a[-c(i,j),j,-c(i,j)]) +
                   D3m(a[-c(i,j),-c(i,j),i],a[-c(i,j),-c(i,j),j]) +
                   D3m(a[i,j,-c(i,j)],a[j,i,-c(i,j)]) +
                   D3m(a[i,-c(i,j),j],a[j,-c(i,j),i]) +
                   D3m(a[-c(i,j),i,j],a[-c(i,j),j,i]) +
                   D3m(a[i,i,-c(i,j)],a[j,j,-c(i,j)]) +
                   D3m(a[i,-c(i,j),i],a[j,-c(i,j),j]) +
                   D3m(a[-c(i,j),i,i],a[-c(i,j),j,j]) +
                   D3m(a[i,i,j],a[j,j,i]) + D3m(a[i,j,i],a[j,i,j])+
                   D3m(a[j,i,i],a[i,j,j]) + D3m(a[i,i,i],a[j,j,j])
      }
    }
  }
  do
}

rndMat3m <- function(m,n,p=0.3){
  mx <- m[1]; my <- m[2]; mz <- m[3]
  nx <- n[1]; ny <- n[2]; nz <- n[3]
  px <- sample(seq(mx),nx,replace=TRUE)
  if (ny==0) {
    ny <- nx
    if (my==0) { my <- mx; py <- px }
    else { py <- sample(seq(my),ny,replace=TRUE) }
  } else { py <- sample(seq(my),ny,replace=TRUE) }
  if (nz==0) {
    nz <- ny
    if (mz==0) { mz <- my; pz <- py }
    else { pz <- sample(seq(mz),nz,replace=TRUE) }
  } else { pz <- sample(seq(mz),nz,replace=TRUE) }
  b <- array(as.numeric(runif(mx*my*mz)<p),dim=c(mx,my,mz))
  a <- array(0,dim=c(nx,ny,nz))
  for (i in 1:nx){
    for (r in 1:ny){
      for (v in 1:nz){
        a[i,r,v] <- b[px[i],py[r],pz[v]]
      }
    }
  }
  dimnames(a) <- list(labs3m(nx),labs3m(ny),labs3m(nz))
  a
}

readTriplets3m <- function(f,n=c(0,0,0),head=TRUE,lsep=":",...){
  sk <- 0
  if (head) {
    sk <- 6
    h <- readLines(f,n=sk)
    n <- as.numeric(unlist(strsplit(h[3]," ")))
    lx <- unlist(strsplit(h[4],lsep))
    ly <- unlist(strsplit(h[5],lsep))
    lz <- unlist(strsplit(h[6],lsep))
  }
  t <- read.table(f,skip=sk)
  nt <- dim(t)[1]
  nx <- n[1]; ny <- n[2]; nz <- n[3]
  if (nx == 0) { nx <- max(t$V1) }
  if (ny == 0) { ny <- max(t$V2) }
  if (nz == 0) { nz <- max(t$V3) }
  z <- array(0,c(nx,ny,nz))
  for (i in 1:nt) { z[t$V1[i],t$V2[i],t$V3[i]] <- 1 }
  if (head) {dimnames(z) <- list(lx,ly,lz)}
  else {dimnames(z) <- list(labs3m(nx),labs3m(ny),labs3m(nz))}
  z
}

readDL3m <- function(f,...){
  dl <- readLines(f,n=1)
  if (dl != 'DL') stop("Not a DL file\n")
  h <- readLines(f,n=2)
  hs <- unlist(strsplit(unlist(strsplit(h[2]," ")),"="))
  n1 <- as.numeric(hs[2])
  n3 <- as.numeric(hs[4])
  t <- scan(f,skip=5+n1)
  z <- array(0,c(n1,n1,n3))
  s <- 0
  for (k in 1:n3) {
    for (i in 1:n1) {
      for (j in 1:n1) {
        s <- s+1
        z[i,j,k] <- t[s]
      }
    }
  }
  z
}

kin3m <- function(fkin,tit,a,px,py,pz,rad=0.3){
  kin <- file(fkin,"w")
  nx <- dim(a)[1]
  ny <- dim(a)[2]
  nz <- dim(a)[3]
  lx <- dimnames(a)[[1]]
  ly <- dimnames(a)[[2]]
  lz <- dimnames(a)[[3]]
  cat("@text\n",tit,"\n",date(),"\nScene obtained using Ibm3m\n",
  "indirect block modeling for 3-mode data\n",
  "by Vladimir Batagelj\nUniversity of Ljubljana, Slovenia\n",
  "@kinemage 1\n@caption\n",tit,
  "\n@fontsizeword 18\n@zoom 1.00\n@thinline\n@zclipoff\n",
  "@group {Complete} dominant animate movieview = 1\n",
  "@balllist 0 color=cyan radius=",rad,"\n",file=kin,sep="")
  for (i in 1:nx){
    for (r in 1:ny){
      for (v in 1:nz){
        if (a[px[i],py[r],pz[v]] == 1) {
          cat("{",lx[px[i]],ly[py[r]],lz[pz[v]],"} ",
           i," ",r," ",v,"\n",file=kin,sep="")
        }
      }
    }
  }
  close(kin)
}

renum3m <- function(p,q){
  n <- length(p); j <- 0
  t <- rep(0,n+1); s <- rep(0,n)
  for(i in 1:n){t[i+1] <- q[p[i]]}
  for(i in 1:n){if (t[i]!=t[i+1]) {j <- j+1}; s[i] <- j}
  s
}

kinBlocks3m <- function(fkin,tit,a,rx,ry,rz,k=c(2,2,2),rad=0.3){
  kin <- file(fkin,"w")
  nx <- dim(a)[1]; Nx <- nx+1; kx <- k[1]
  ny <- dim(a)[2]; Ny <- ny+1; ky <- k[2]
  nz <- dim(a)[3]; Nz <- nz+1; kz <- k[3]
  lx <- dimnames(a)[[1]]
  ly <- dimnames(a)[[2]]
  lz <- dimnames(a)[[3]]
  px <- rx$order; qx <- cutree(rx,k=kx); sx <- renum3m(px,qx)
  py <- ry$order; qy <- cutree(ry,k=ky); sy <- renum3m(py,qy)
  pz <- rz$order; qz <- cutree(rz,k=kz); sz <- renum3m(pz,qz)
  cat("@text\n",tit,"\n",date(),"\nScene obtained using Ibm3m\n",
  "indirect block modeling for 3-mode data\n",
  "by Vladimir Batagelj\nUniversity of Ljubljana, Slovenia\n",
  "@kinemage 1\n@caption\n",tit,
  "\n@fontsizeword 18\n@zoom 1.00\n@thinline\n@zclipoff\n",file=kin,sep="")
# complete
  cat("@group {Complete} dominant animate movieview = 1\n",
  "@balllist 1 color=cyan radius=",rad,"\n",file=kin,sep="")
  for (i in 1:nx){
    for (r in 1:ny){
      for (v in 1:nz){
        if ((a[px[i],py[r],pz[v]] == 1)&(odd(sx[i]+sy[r]+sz[v]))) {
          cat("{",lx[px[i]],":",ly[py[r]],":",lz[pz[v]],"} ",
           i," ",r," ",v,"\n",file=kin,sep="")
        }
      }
    }
  }
  cat("@balllist 2 color=red radius=",rad,"\n",file=kin,sep="")
  for (i in 1:nx){
    for (r in 1:ny){
      for (v in 1:nz){
        if ((a[px[i],py[r],pz[v]] == 1)&(!odd(sx[i]+sy[r]+sz[v]))) {
          cat("{",lx[px[i]],":",ly[py[r]],":",lz[pz[v]],"} ",
           i," ",r," ",v,"\n",file=kin,sep="")
        }
      }
    }
  }
# X-layers
  for (s in 1:kx){
    cat("@group {X-layer ",s,"} dominant animate movieview = 1\n",file=kin,sep="")
    cat("@balllist 1 color=cyan radius=",rad,"\n",file=kin,sep="")
    for (i in 1:nx){ if (sx[i]==s){
      for (r in 1:ny){
        for (v in 1:nz){
          if ((a[px[i],py[r],pz[v]] == 1)&(odd(sx[i]+sy[r]+sz[v]))) {
            cat("{",lx[px[i]],":",ly[py[r]],":",lz[pz[v]],"} ",
             i," ",r," ",v,"\n",file=kin,sep="")
          }
        }
      }
    }}
    cat("@balllist 2 color=red radius=",rad,"\n",file=kin,sep="")
    for (i in 1:nx){ if (sx[i]==s){
      for (r in 1:ny){
        for (v in 1:nz){
          if ((a[px[i],py[r],pz[v]] == 1)&(!odd(sx[i]+sy[r]+sz[v]))) {
            cat("{",lx[px[i]],":",ly[py[r]],":",lz[pz[v]],"} ",
             i," ",r," ",v,"\n",file=kin,sep="")
          }
        }
      }
    }}
  }
# Y-layers
  for (s in 1:ky){
    cat("@group {Y-layer ",s,"} dominant animate movieview = 1\n",file=kin,sep="")
    cat("@balllist 1 color=cyan radius=",rad,"\n",file=kin,sep="")
    for (r in 1:ny){ if (sy[r]==s){
      for (i in 1:nx){
        for (v in 1:nz){
          if ((a[px[i],py[r],pz[v]] == 1)&(odd(sx[i]+sy[r]+sz[v]))) {
            cat("{",lx[px[i]],":",ly[py[r]],":",lz[pz[v]],"} ",
             i," ",r," ",v,"\n",file=kin,sep="")
          }
        }
      }
    }}
    cat("@balllist 2 color=red radius=",rad,"\n",file=kin,sep="")
    for (r in 1:ny){ if (sy[r]==s){
      for (i in 1:nx){
        for (v in 1:nz){
          if ((a[px[i],py[r],pz[v]] == 1)&(!odd(sx[i]+sy[r]+sz[v]))) {
            cat("{",lx[px[i]],":",ly[py[r]],":",lz[pz[v]],"} ",
             i," ",r," ",v,"\n",file=kin,sep="")
          }
        }
      }
    }}
  }
# Z-layers
  for (s in 1:kz){
    cat("@group {Z-layer ",s,"} dominant animate movieview = 1\n",file=kin,sep="")
    cat("@balllist 1 color=cyan radius=",rad,"\n",file=kin,sep="")
    for (v in 1:nz){ if (sz[v]==s){
      for (r in 1:ny){
        for (i in 1:nx){
          if ((a[px[i],py[r],pz[v]] == 1)&(odd(sx[i]+sy[r]+sz[v]))) {
            cat("{",lx[px[i]],":",ly[py[r]],":",lz[pz[v]],"} ",
             i," ",r," ",v,"\n",file=kin,sep="")
          }
        }
      }
    }}
    cat("@balllist 2 color=red radius=",rad,"\n",file=kin,sep="")
    for (v in 1:nz){ if (sz[v]==s){
      for (r in 1:ny){
        for (i in 1:nx){
          if ((a[px[i],py[r],pz[v]] == 1)&(!odd(sx[i]+sy[r]+sz[v]))) {
            cat("{",lx[px[i]],":",ly[py[r]],":",lz[pz[v]],"} ",
             i," ",r," ",v,"\n",file=kin,sep="")
          }
        }
      }
    }}
  }
# coordinate system
  cat("@group {System} dominant animate movieview = 1\n",
    "@balllist 0 color=white radius=0.7\n{0} 0 0 0\n",
    "@balllist 1 color=green radius=0.7\n{X} ",Nx," 0 0\n",
    "@balllist 2 color=orange radius=0.7\n{Y} 0 ",Ny," 0\n",
    "@balllist 3 color=blue radius=0.7\n{Z} 0 0 ",Nz,"\n",
    "@balllist 4 color=yellow radius=0.5\n",
    "{XY} ",Nx," ",Ny," 0\n{XZ} ",Nx," 0 ",Nz,
    "\n{YZ} 0 ",Ny," ",Nz,"\n{XYZ} ",Nx," ",Ny," ",Nz,"\n",
    file=kin,sep="")
  cat("@vectorlist {} color=yellowtint width=2\nP 0,0,0\n",
    Nx,",0,0\nP 0,0,0\n0,",Ny,",0\nP 0,0,0\n0,0,",Nz,
    "\nP ",Nx,",0,0\n",Nx,",",Ny,",0\nP ",Nx,",0,0\n",
    Nx,",0,",Nz,"\nP 0,",Ny,",0\n",Nx,",",Ny,",0\nP 0,",Ny,",0\n",
    "0,",Ny,",",Nz,"\nP 0,0,",Nz,"\n",Nx,",0,",Nz,"\nP 0,0,",Nz,
    "\n0,",Ny,",",Nz,"\nP ",Nx,",",Ny,",0\n",Nx,",",Ny,",",Nz,
    "\nP ",Nx,",",Ny,",",Nz,"\n",Nx,",0,",Nz,
    "\nP ",Nx,",",Ny,",",Nz,"\n0,",Ny,",",Nz,file=kin,sep="")
  close(kin)
}

saveTriplets3m <- function(f,a,head=TRUE,tit="ibm3m",lsep=":"){
  tri <- file(f,"w")
  nx <- dim(a)[1]
  ny <- dim(a)[2]
  nz <- dim(a)[3]
  if (head) {
    la <- dimnames(a)[[1]]
    lx <- la[1]; for (i in 2:nx) {lx <- paste(lx,la[i],sep=lsep)}
    la <- dimnames(a)[[2]]
    ly <- la[1]; for (i in 2:ny) {ly <- paste(ly,la[i],sep=lsep)}
    la <- dimnames(a)[[3]]
    lz <- la[1]; for (i in 2:nz) {lz <- paste(lz,la[i],sep=lsep)}
    cat(tit,"\n",date(),"\n",nx," ",ny," ",nz,"\n",
    lx,"\n",ly,"\n",lz,"\n",file=tri,sep="")
  }
  for (i in 1:nx){
    for (r in 1:ny){
      for (v in 1:nz){
        if (a[i,r,v] == 1) {
          cat(i," ",r," ",v,"\n",file=tri,sep="")
        }
      }
    }
  }
  close(tri)
}


