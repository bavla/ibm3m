# Kinship

```
List of 6
 $ format: chr "MWnets"
 $ info  :List of 7
  ..$ network: chr "Kinship"
  ..$ title  : chr "Rosenberg and Kim (1975) Kinship Terms"
  ..$ by     : chr "S. Rosenberg and M. P. Kim"
  ..$ ref    : chr "S. Rosenberg and M. P. Kim (1975). The method of sorting as a data-gathering procedure in multivariate research"| __truncated__
  ..$ href   : chr "http://vladowiki.fmf.uni-lj.si/doku.php?id=notes:da:clu:mul"
  ..$ creator: chr "V. Batagelj"
  ..$ date   : chr "Thu Dec  1 17:36:22 2022"
 $ ways  :List of 3
  ..$ T1: chr "first term"
  ..$ T2: chr "second term"
  ..$ K : chr "subjects"
 $ nodes :List of 3
  ..$ T1:'data.frame':  15 obs. of  3 variables:
  .. ..$ ID  : chr [1:15] "Aunt" "Brother" "Cousin" "Daughter" ...
  .. ..$ IDen: chr [1:15] "FCA:aunt" "MN*:brot" "*C*:cous" "FND:daug" ...
  .. ..$ IDsi: chr [1:15] "teta" "brat" "bra/sestrična" "hči" ...
  ..$ T2:'data.frame':  15 obs. of  1 variable:
  .. ..$ ID: chr [1:15] "Aunt" "Brother" "Cousin" "Daughter" ...
  ..$ K :'data.frame':  6 obs. of  1 variable:
  .. ..$ ID: chr [1:6] "K1" "K2" "K3" "K4" ...
 $ links :'data.frame': 1350 obs. of  4 variables:
  ..$ T1: int [1:1350] 1 1 1 1 1 1 1 1 1 1 ...
  ..$ T2: int [1:1350] 1 2 3 4 5 6 7 8 9 10 ...
  ..$ K : int [1:1350] 1 1 1 1 1 1 1 1 1 1 ...
  ..$ w : int [1:1350] 0 79 56 36 76 34 76 36 77 33 ...
 $ data  : list()
```

Kinship - Rosenberg and Kim (1975) Kinship Terms

http://vladowiki.fmf.uni-lj.si/doku.php?id=notes:da:clu:mul

The objects (units) in this study were the 15 kinship terms:
aunt,
brother,
cousin,
daughter,
father,
granddaughter,
grandfather,
grandmother,
grandson,
mother,
nephew,
niece,
sister,
son,
uncle.

The sources of data were k=6 mutually exclusive groups of college students, each of whom received a set of 15 slips of paper, each containing one of the kinship terms. The paradigm for data collection was a “sorting” task, in which a subject is asked to produce a partition of the (15) objects, on the basis of perceived psychological similarity. Eighty-five male and eighty-five female subjects were run in the condition where subjects gave only a single-sort of the terms. A different group of subjects (eighty males and eight females) was told in advance that after making their first sort, they would be asked to give additional subjective partitions of these stimuli using “a different basis of meaning each time”. The authors used only the data of the first and second sorting for these groups of subjects. Thus, we have the k=6 conditions as our source for the analysis.

Each subject's data can be coded as a symmetric 15×15 binary (0,1) co-occurrence matrix in which a one indicates that kinship terms of the corresponding row and column were sorted into the same group by the subject. The resulting co-occurrence matrices are then summed within each condition to yield an aggregate matrix. Thus, each of the six matrices is a similarity matrix. They were converted to dissimilarity ones by subtracting each entry from the number of subjects in the respective conditions.

  - https://rdrr.io/cran/clue/man/Kinship82.html
  - https://www.tandfonline.com/doi/abs/10.1207/s15327906mbr1004_7

S. Rosenberg and M. P. Kim (1975). The method of sorting as a data-gathering procedure
    in multivariate research. Multivariate Behavioral Research, 10, 489–502.
    
