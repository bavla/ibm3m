# Analysis of multiway networks

[Structure of a multiway network description in R](./structure.md)


## MWnets

  - https://raw.githubusercontent.com/bavla/ibm3m/master/multiway/MWnets.R

```
source("https://raw.githubusercontent.com/bavla/ibm3m/master/multiway/MWnets.R")
```

### reorderways(MN,ord)

Reorder ways of the multiway network `MN` in the order determined in the vector `ord`. 
```
MNo <- reorderways(MN,c("year","prog","prov","univ")) 
```

### slice(MN,P)

Extract from the multiway network `MN` a subnetwork of links satisfying a predicate `P` on links columns.
```
MS <- slice(MN,"year==3")
```

### extract(MN,ways,clus)

Extract from the multiway network `MN` a subnetwork determined by selected ways and corresponding clusters (vectors containing list of nodes).
```
w1 <- (1:107)[core$prov==10]
w2 <- (1:79)[core$univ==10]
Score <- extract(S10,c("prov","univ"),c("w1","w2"))
```


### flatten(MN,col,by,FUN="sum")

Removes ways that are not listed in the vector `by` and applies   `FUN` on the weights   `col` for so obtained duplicates.

It can be used, `by` contains a complete list of ways, to aggregate duplicate links in the original data. 

A selected way $V_i$ is removed from the network.
$$V' = ( V_1, V_2, \ldots, V_{i-1}, V_{i+1}, \ldots, V_k )$$
$$w'(v_1, v_2, \ldots, v_{i-1}, v_{i+1}, \ldots, v_k) = \sum_{v \in V_i} w(v_1, v_2, \ldots, v_{i-1},v, v_{i+1}, \ldots, v_k)$$

```
MNf <- flatten(MN,"w",c("year","prov","univ"))
Mf <- flatten(MN,"w",c("prov","univ"))
head(Mf$links)
```

### reorderlinks(MN,per=NULL)

Reorders the links (rows) by the given permutation  `per`.
  - `per = NULL` - random
  - `per =` permutation vector
  - `per =` expression
```
n <- nrow(MN$links); per <- sample(1:n,n)
Mor <- reorderlinks(MN)
Mop <- reorderlinks(MN,per)
Mo <- reorderlinks(MN,"order(prov,univ,prog,year)")
str(Mo)
head(Mo$links)
```

### joinways(MN,way1,way2,way3,sep="÷")

Replaces a given pair of ways `way1` and `way2` with a new way `way3`. way3 = { a÷b : a ∈ `way1` and b ∈ `way2` co-appear in a link of `MN` }
```
Mj <- joinways(MN,"prog","univ","prun")
```

### projection(MN,way,w)

Computes the projection matrix of the multiway network `MN` to the way `way` using the weight `w`.

Assume that we selected the way $V_1$. A projection to a selected way is a generalization of the projection of two-mode networks. The projection creates an ordinary weighted network $(V_1,A,p)$, $A \subseteq V_1 \times V_1$ and $p : A \to R$. 

Let $u,t \in V_1$ then 
$$p(u,t) = \sum_{(v_2,\ldots,v_k) \in V_2\times\cdots\times V_k} w(u,v_2,\ldots,v_k) \cdot w(t,v_2,\ldots,v_k).$$
This network can be analyzed using traditional methods for the analysis of weighted networks. Sometimes it is more appropriate to apply projection(s) to a normalized version of the original multi-way network.
```
Co <- projection(MN,"prov","w")
Co[1:10,1:15]
```
### salton(Co)

Computes the Salton similarity matrix from the given projection matrix `Co`.

From the projection $p$ we can get the corresponding measure of similarity -- Salton index $S(u,t)$ [onBibNet]().
$$S(u,t) = \frac{p(u,t)}{\sqrt{p(u,u) \cdot p(t,t)}}$$
that can be used for clustering the set $V_1$.
```
Sal <- salton(Co); D <- as.dist(1-Sal)
t <- hclust(D,method="ward.D")
plot(t,hang=-1,cex=0.8,main="Provinces / Ward")
```

### projection2(MN,way,w,z)

It is a generalization of the function `projection`. It computes the projection matrix of the multiway network `MN` to the way `way` using the weights `w` and `z`.

The `projection2` creates an ordinary weighted network $(V_1,A,p_2)$, $A \subseteq V_1 \times V_1$ and $p_2 : A \to R$. 

Let $u,t \in V_1$ then 
$$p_2(u,t) = \sum_{(v_2,\ldots,v_k) \in V_2\times\cdots\times V_k} w(u,v_2,\ldots,v_k) \cdot z(t,v_2,\ldots,v_k).$$

The main reason for introducing `projection2` is to provide support for an approach similar to that from the section
"Bibliographic coupling and co-citation" from the paper [On fractional approach to analysis of linked networks](https://link.springer.com/article/10.1007/s11192-020-03383-y).

It holds
  - $p\langle w \rangle = p_2\langle w, w \rangle$
  - $p_2\langle w, z \rangle = p_2\langle z, w \rangle$
```
Co <- projection(MN,"prog","w")
Co2 <- projection2(MN,"prog","w","w")
Co2[1:10,1:10] 
Co[1:10,1:10]
MN$links$one <- rep(1,length(MN$links[[w]]))
CoA <- projection2(MN,"prog","w","one")
CoB <- projection2(MN,"prog","one","w")
CoA[1:10,1:10]
CoB[1:10,1:10]
```

### recodecol2bins(MN,col1,col2,bins=c(0,1e-323,Inf))

Recodes the given link weight `col1` into bins determined by vector `bins` and stores the resulting weights in `col2`.

$bins = (b_1,b_2, \ldots, b_k)$

$code(w) = i$ iff $w \in [ b_i, b_{i+1} )$

```
Mc <- recodecol2bins(MN,"w","code",bins=c(1,5,10,20,Inf))
```

### recodeway2part(MN,way1,part,way2,desc)

Recodes the given link way `way1` according to its nodes partition `part` and stores the result in the same place and renames it `way2`. `desc` is a descriptive name of the new way `way2`.
```
Mr <- recodeway2part(MN,"prov","IDreg","regs","region")
Mre <- flatten(Mr,"w",c("regs","univ","prog","year"))
```

### relCore(MN,way1,way2,way3)

Determine the relational core of the multiway network `MN` for nodes of `way1` and `way2` of the same mode and relational way `way3`.

http://vladowiki.fmf.uni-lj.si/doku.php?id=vlado:work:2m:mwn:rcores

```
> core <- relCore(MN,"airA","airB","line")
```

### relCore2(MN,way1,way2,way3)

Determine the two-mode relational core of the multiway network `MN` for nodes of `way1` and `way2` (of different modes) and relational way `way3`.

```
> core <- relCore2(S,"prov","univ","prog")
> str(core)
List of 2
 $ prov: num [1:107] 9 9 10 10 9 9 10 7 10 9 ...
 $ univ: num [1:79] 7 2 6 2 7 8 8 3 9 2 ...
```
### p(MN,u,C,way1,way2,...)
Returns a node property of the node `u` for cluster `C` and selected ways `way1` and `way2`. The function `p` can be selected among

#### pDeg(MN,u,C,way1,way2)
Degree of the node `V`.

#### pSum(MN,u,C,way1,way2,weight=)
Sum of weights of links in the node `u`.

#### pMax(MN,u,C,way1,way2,weight=)
Maximum of weights of links in the node `u`.

#### pRel(MN,u,C,way1,way2,way3=)
Number of different realations of type `way3` in the node `u`.

### GenCoresDec(MN,way1,way2,way3=,weight=,p=)
Generalized cores decomposition of the multiway network `MN` for the node property `p`.

```
core <- GenCoresDec(MV,"SOURCE","TARGET",way3="LINKTYPE",p=pRel)
core <- GenCoresDec(MV,"SOURCE","TARGET",weight="WEIGHT",p=pSum)
core <- GenCoresDec(MV,"SOURCE","TARGET",p=pDeg)
EU <- fromJSON("https://raw.githubusercontent.com/bavla/ibm3m/master/data/AirEu2013Ext.json")
core1 <- relCore(EU,"airA","airB","line")
core2 <- GenCoresDec(EU,"airA","airB",way3="line",p=pRel)
```

### Gen2modeCore(MN,way1,way2,f1,f2,t1,t2)

Generalized two-mode cores of the multiway network `MN` for the node properties `f1` and `f2` at levels `t1` and `t2`.
```
PSum <- function(MN,u,C,way1,way2,...) pSum(MN,u,C,way1,way2,weight="w",...)
cores <- Gen2modeCore(IS,"prov","univ",PSum,PSum,1500,1500)
Cprov <- cores$core1; Cuniv <- cores$core2
```



### mwn2net(MN,way1,way2,r=NULL,t=NULL,w=NULL,Net="Pajek.net",encoding="UTF-8")

Exports a multiway network `MN` to Pajek as a (multirelational temporal) two-mode network on node sets `way1` and `way2` (and optional relation  r=`way3` and time instance t=`way4`). Additional ways are producing parallel links.

```
mwn2net(S2014,"prov","univ",r="prog",w="w",Net="S2014.net")
```

### mwn2clu(MN,way,part,Clu="Pajek.clu",encoding="UTF-8")

Exports the node partition `way$part` as a Pajek clustering file. 

```
mwn2clu(S2014,"prov","IDreg",Clu="regions.clu")
```

### mwn2vec(MN,way,prop,Vec="Pajek.vec",encoding="UTF-8")

Exports the node property `way$prop` as a Pajek vector file if the property is numerical; otherwise it exports it as a numbered list. 

```
mwn2vec(S2014,"prov","area",Vec="area.vec")
mwn2vec(S2014,"prov","capital",Vec="capital.vec")
```

### mwnX3D(MN,u,v,z,w,lu="ID",lv="ID",lz="ID",pu=NULL,pv=NULL,pz=NULL,shape="Box",col=c(1,0,0),bg=c(0.8,0.8,0.8),maxsize=1,file="MWnets.x3d")

Exports a 3D layout description of the 3-way (sub)network of network `MN` on ways `u`, `v`, `z` with weight `w` in X3D format to the selected `file`. The parameters `lu`, `lv`, `lz` are the names of node properties containing node labels.  The vectors `pu`, `pv`, `pz` contain the permutations of nodes in the corresponding ways. The parameter `shape` can be either "Box" or "Sphere". The parameter `col` specifies the color of each link, and `bg` the background color. The parameter `maxsize` controls the maximum size of the shape. 

```
> mwnX3D(MN,"prov","univ","prog","w",lu="province",lv="long",lz="long",maxsize=1,
+ col=cluCol,pu=I,pv=J,pz=K,file="students08Clux.x3d")
```




## magrittr
```
> library(magrittr)
> MN %>% 
+   recodeway2part("prov","IDreg","regs","region") %>% 
+   flatten("w",c("regs","univ","prog","year")) %T>% 
+   str() -> 
+   Mrw
```

## References

- Batagelj, Vladimir; Ferligoj, Anuška; Doreian, Patrick: Indirect Blockmodeling of 3-Way Networks. In: Brito, P, Cucumel, G, Bertrand, P, de Carvalho, F (eds)
Selected Contributions in Data Analysis and Classification pp 151–159, Springer, 2007; [preprint](http://vlado.fmf.uni-lj.si/vlado/papers/ibm3mode.pdf)
- Borgatti, Stephen P.; Everett, Martin G.: Regular blockmodels of multiway, multimode matrices. Social Networks 14 (1992) 31-120
- Coleman, J.; Katz, E.; Menzel, H.: The Diffusion of an Innovation Among Physicians. Sociometry (1957) 20:253-270.
- de Domenico, Manlio: [Data sets](https://manliodedomenico.com/data.php)
- Genova, Vincenzo Giuseppe ; Giordano, Giuseppe; Ragozini, Giancarlo; Vitale, Maria Prosperina: Clustering student mobility data in 3-way networks. IFCS 2022, Porto
- Kapferer, B.: Strategy and transaction in an African factory. (1972)
- Krackhardt, David: Cognitive social structures. Social Networks, 9 (1987), 104-134.
- Lazega, Emmanuel: The Collegial Phenomenon: The Social Mechanisms of Cooperation Among Peers in a Corporate Law Partnership. Oxford University Press (2001)
- Mendeley [data](https://data.mendeley.com/research-data/?search=network)

