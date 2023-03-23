# Indirect block modeling of 3-mode data and analysis of multiway networks

In 2006 we developed **ibm3m** an R package for indirect block modeling of 3-mode data. 

In november 2022 we started a more general approach to analysis of multiway networks. We developed a [JSON format](./multiway/structure.md) for description of multiway networks, collected some [examples](./data/README.md) of multiway networks available on the WWW, and started development of the R package [MWnets](./multiway/README.md) implementing methods for multiway network analysis. The advances in the development were reported at the [Sredin seminar](./docs).


## ibm3m
ibm3m - indirect block modeling of 3-mode data

The first version was developed in 2006 by Vladimir Batagelj, University of Ljubljana, Slovenia (Bled, July 15-17, 2006
and Ljubljana, July 18-21, 2006). The package was described in the paper (see the file 3-wayBM.pdf) 

Batagelj, V., Ferligoj, A., Doreian, P.: Indirect Blockmodeling of 3-Way Networks. In: Selected Contributions in Data Analysis and Classification, Springer, 2007, pp.151-159.

The file ibm3m.R contains the following functions

dist3m(a,t,d)

rndMat3m(m,n,p=0.3)

readDL3m(f,...)

kin3m(fkin,tit,a,px,py,pz,rad=0.3)

saveTriplets3m(f,a,head=TRUE,tit="ibm3m",lsep=":")

The file tests.R contains example blockmodelings (random, Krackard, Lazega).

The 3-mode networks can be prepared in
- UCINET DL matrix format; see file krack.dat
- as triplets: see files test.tri and triplet.dat
