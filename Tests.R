# tests for
# ibm3m - indirect block modeling of 3-mode data
# Vladimir Batagelj, University of Ljubljana, Slovenia
# Bled, July 15-17, 2006
# Ljubljana, July 18-21, 2006
# http://vlado.fmf.uni-lj.si/pub/networks/progs/ibm3m.zip

rndTest <- function(m=c(3,3,3),n=c(30,30,30),p=0.35){
  t <- rndMat3m(m,n,p)
  saveTriplets3m('test.tri',t,tit="random test")
  dx <- dist3m(t,0,1)
  rx <- agnes(dx,method='ward')
  dy <- dist3m(t,0,2)
  ry <- agnes(dy,method='ward')
  dz <- dist3m(t,0,3)
  rz <- agnes(dz,method='ward')
  pdf('testXD.pdf'); plot(rx,which.plots=2,nmax.lab=50,cex=0.6); dev.off()
  pdf('testYD.pdf'); plot(ry,which.plots=2,nmax.lab=50,cex=0.6); dev.off()
  pdf('testZD.pdf'); plot(rz,which.plots=2,nmax.lab=50,cex=0.6); dev.off()
  kin3m('testOrg.kin',"test - original",t,seq(n[1]),seq(n[2]),seq(n[3]))
  kinBlocks3m('testXYZ.kin',"test - all different",t,rx,ry,rz,m)
  if (n[2]==n[3]){
    rb <- agnes(dist3m(t,1,1),method='ward')
    pdf('testBD.pdf'); plot(rb,which.plots=2,nmax.lab=50,cex=0.6); dev.off()
    kinBlocks3m('testXYY.kin',"test - two equal",t,rx,rb,rb,m)
  }
  if ((n[1]==n[2])&(n[2]==n[3])){
    ra <- agnes(dist3m(t,2,0),method='ward')
    pdf('testAD.pdf'); plot(ra,which.plots=2,nmax.lab=50,cex=0.6); dev.off()
    kinBlocks3m('testXXX.kin',"test - all equal",t,ra,ra,ra,m)
  }
}

LazegaTest <- function(){
  a <- readTriplets3m('triplet.dat',head=FALSE)
  labs <- paste('L',1:36,sep='')
  dimnames(a) <- list(labs,labs,labs)
  rx <- agnes(dist3m(a,0,1),method='ward')
  ry <- agnes(dist3m(a,0,2),method='ward')
  rz <- agnes(dist3m(a,0,3),method='ward')
  rb <- agnes(dist3m(a,1,1),method='ward')
  ra <- agnes(dist3m(a,2,0),method='ward')
  pdf('LazegaXD.pdf'); plot(rx,which.plots=2,nmax.lab=50,cex=0.7); dev.off()
  pdf('LazegaYD.pdf'); plot(ry,which.plots=2,nmax.lab=50,cex=0.7); dev.off()
  pdf('LazegaZD.pdf'); plot(rz,which.plots=2,nmax.lab=50,cex=0.7); dev.off()
  pdf('LazegaBD.pdf'); plot(rb,which.plots=2,nmax.lab=50,cex=0.7); dev.off()
  pdf('LazegaAD.pdf'); plot(ra,which.plots=2,nmax.lab=50,cex=0.7); dev.off()
  pe <- seq(36)
  kin3m('LazegaOrg.kin',"Lazega's Lawyers - original",a,pe,pe,pe)
  kinBlocks3m('LazegaXYZ.kin',"Lazega's Lawyers - all different",
    a,rx,ry,rz,c(6,4,3))
  kinBlocks3m('LazegaXYY.kin',"Lazega's Lawyers - two equal",
    a,rx,rb,rb,c(6,5,5))
  kinBlocks3m('LazegaXXX.kin',"Lazega's Lawyers - all equal",
    a,ra,ra,ra,c(7,7,7))
}

KrackTest <- function(){
  kr <- readDL3m('krack.dat')
  labs <- paste('A',1:21,sep='')
  dimnames(kr) <- list(labs,labs,labs)
  rx <- agnes(dist3m(kr,0,1),method='ward')
  ry <- agnes(dist3m(kr,0,2),method='ward')
  rz <- agnes(dist3m(kr,0,3),method='ward')
  rb <- agnes(dist3m(kr,1,1),method='ward')
  ra <- agnes(dist3m(kr,2,0),method='ward')
  pdf('KrackXD.pdf'); plot(rx,which.plots=2,nmax.lab=50,cex=0.8); dev.off()
  pdf('KrackYD.pdf'); plot(ry,which.plots=2,nmax.lab=50,cex=0.8); dev.off()
  pdf('KrackZD.pdf'); plot(rz,which.plots=2,nmax.lab=50,cex=0.8); dev.off()
  pdf('KrackBD.pdf'); plot(rb,which.plots=2,nmax.lab=50,cex=0.8); dev.off()
  pdf('KrackAD.pdf'); plot(ra,which.plots=2,nmax.lab=50,cex=0.8); dev.off()
  pe <- seq(21)
  kin3m('KrackOrg.kin',"Krackhardt - original",kr,pe,pe,pe)
  kinBlocks3m('KrackXYZ.kin',"Krackhardt - all different",
    kr,rx,ry,rz,c(4,4,4))
  kinBlocks3m('KrackXYY.kin',"Krackhardt - two equal",kr,rx,rb,rb,c(4,5,5))
  kinBlocks3m('KrackXXX.kin',"Krackhardt - all equal",kr,ra,ra,ra,c(6,6,6))
}
