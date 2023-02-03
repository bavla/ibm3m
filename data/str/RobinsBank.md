# RobinsBank

```
List of 6
 $ format: chr "MWnets"
 $ info  :List of 7
  ..$ network: chr "Robins bank"
  ..$ title  : chr "Robins: organizational structure in a bank branch"
  ..$ by     : chr "Garry Robins"
  ..$ ref    : chr "Pattison, Wasserman, Robins, Kanfer: Statistical Evaluation of Algebraic Constraints for Social Networks. J of "| __truncated__
  ..$ href   : chr "https://www.sciencedirect.com/science/article/pii/S0022249699912610"
  ..$ creator: chr "V. Batagelj"
  ..$ date   : chr "Sun Dec 11 05:51:10 2022"
 $ ways  :List of 3
  ..$ P1: chr "first person"
  ..$ P2: chr "second person"
  ..$ R : chr "relation"
 $ nodes :List of 3
  ..$ P1:'data.frame':  11 obs. of  2 variables:
  .. ..$ ID  : chr [1:11] "BM" "DM" "A1" "A2" ...
  .. ..$ long: chr [1:11] "branch manager" "deputy manager" "service adviser 1" "service adviser 2" ...
  ..$ P2:'data.frame':  11 obs. of  1 variable:
  .. ..$ ID: chr [1:11] "BM" "DM" "A1" "A2" ...
  ..$ R :'data.frame':  4 obs. of  2 variables:
  .. ..$ ID  : chr [1:4] "advice" "friend" "satisfy" "confide"
  .. ..$ long: chr [1:4] "Advice seeking" "Close friendship" "Satisfying interaction" "Confiding"
 $ links :'data.frame': 128 obs. of  4 variables:
  ..$ P1: int [1:128] 1 1 1 2 3 4 6 6 6 7 ...
  ..$ P2: int [1:128] 2 3 4 1 2 1 3 4 5 1 ...
  ..$ R : int [1:128] 1 1 1 1 1 1 1 1 1 1 ...
  ..$ w : num [1:128] 1 1 1 1 1 1 1 1 1 1 ...
 $ data  : list()
```

Robins bank - organizational structure in a bank branch

Data from a study of structure in a number of branches of
a large Australian bank (Robins, 1994; Robins, Pattison, 6 Langan-Fox, 1997).
The relations presented are from one branch in response to
questions: (1) With whom might you check out a course of action if an issue arises
in your work? (the advice-seeking relation); (2) With whom do you feel that your
work interactions are particularly satisfying? (the satisfying interaction relation);
(3) In whom do you feel you would be able to confide if a problem arose that you
did not want everyone to know about? (the confiding relation); (4) Whom do you
consider to be a particularly close friend? (the close friend relation). We note that
the first listed respondent is the Branch manager, the second is the deputy manager,
the third, fourth, and fifth respondents are service advisers (a middle ranking
position within the branch), and the remaining respondents are tellers.
