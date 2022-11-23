# Analysis of multiway networks

## MWnets

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
```
MNf <- flatten(MN,"w",c("year","prov","univ"))
Mf <- flatten(MN,"w",c("prov","univ"))
head(Mf$links)
```

### reorderlinks(MN,per=NULL)

per = NULL - random

per = permutation vector

per = expression
```
n <- nrow(MN$links); per <- sample(1:n,n)
Mor <- reorderlinks(MN)
Mop <- reorderlinks(MN,per)
Mo <- reorderlinks(MN,"order(prov,univ,prog,year)")
str(Mo)
head(Mo$links)
```

### joinways(MN,way1,way2,way3,sep="÷")
```
Mj <- joinways(MN,"prog","univ","prun")
```

### projection(MN,way,w)

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

```
Mc <- recodecol2bins(MN,"w","code",bins=c(1,5,10,20,Inf))
```

### recodeway2part(MN,way1,part,way2,desc)

Recodes the given link way `way1` according to its nodes partition `part` and stores the result in the same place and renames it `way2`. `desc` is a descriptive name of the new way `way2`.
```
Mr <- recodeway2part(MN,"prov","IDreg","regs","region")
Mre <- flatten(Mr,"w",c("regs","univ","prog","year"))
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


