# Analysis of multiway networks

[Structure of a multiway network description in R](./structure.md)


## MWnets

  - http://vladowiki.fmf.uni-lj.si/doku.php?id=vlado:work:2m:mwn:genova:ana1
  - http://vladowiki.fmf.uni-lj.si/doku.php?id=vlado:work:2m:mwn:ops
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

Replaces a given pair of ways `way1` and `way2` with a new way `way3`. way3 = { a÷b : a way1 and b way2 co-appear in a multilink of MN }
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

### mwn2net(MN,way1,way2,r=NULL,t=NULL,w=NULL,Net="Pajek.net",encoding="UTF-8")

Exports a multiway network `MN` to Pajek as a (multirelational temporal) two-mode network on node sets `way1` and `way2` (and optional relation  r=`way3` and time instance t=`way4`). Additional ways are producing parallel links.

```
# mwn2net(S2014,"prov","univ",r="prog",w="w",Net="S2014.net")
```

### mwn2clu(MN,way,part,Clu="Pajek.clu",encoding="UTF-8")

Exports the node partition `way$part` as a Pajek clustering file. 

```
# mwn2clu(S2014,"prov","IDreg",Clu="regions.clu")
```

### mwn2vec(MN,way,prop,Vec="Pajek.vec",encoding="UTF-8")

Exports the node property `way$prop` as a Pajek vector file if the property is numerical; otherwise it exports it as a numbered list. 

```
# mwn2vec(S2014,"prov","area",Vec="area.vec")
# mwn2vec(S2014,"prov","capital",Vec="capital.vec")
```

### mwnX3D(MN,u,v,z,w,lu="ID",lv="ID",lz="ID",pu=NULL,pv=NULL,pz=NULL,shape="Box",col=c(1,0,0),bg=c(0.8,0.8,0.8),maxsize=1,file="MWnets.x3d")

Exports a 3D layout description of the 3-way (sub)network of network `MN` on ways `u`, `v`, `z` with weight `w` in X3D format to the selected `file`. The parameters `lu`, `lv`, `lz` are the names of node properties containing node labels.  The vectors `pu`, `pv`, `pz` contain the permutations of nodes in the corresponding ways. The parameter `shape` can be either "Box" or "Sphere". The parameter `col` specifies the color of each link, and `bg` the background color. The parameter `maxsize` controls the maximum size of the shape. 

```
# mwnX3D(MN,"prov","univ","prog","w",lu="province",lv="long",lz="long",maxsize=1,
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

