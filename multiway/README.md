# Analysis of multiway networks

## MWnets

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

```
Co <- projection(MN,"prov","w")
Co[1:10,1:15]
```
### salton(Co)

Computes the Salton similarity matrix from the given projection matrix `Co`.
```
Sal <- salton(Co); D <- as.dist(1-Sal)
t <- hclust(D,method="ward.D")
plot(t,hang=-1,cex=0.8,main="Provinces / Ward")
```

### recodecol2bins(MN,col1,col2,bins=c(0,1e-323,Inf))

Recodes the given link weight `col1` into bins determined by vector `bins` and stores the resulting weights in `col2`.

bins = (b1,b2, …, bk)

code(w) = i iff w in [ bi, b<i+1> )

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





## magrittr
```
> library(magrittr)
> MN %>% 
+   recodeway2part("prov","IDreg","regs","region") %>% 
+   flatten("w",c("regs","univ","prog","year")) %T>% 
+   str() -> 
+   Mrw
```


