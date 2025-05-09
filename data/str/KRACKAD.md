# KRACKAD

```
List of 6
 $ format: chr "MWnets"
 $ info  :List of 7
  ..$ network: chr "KRACKAD"
  ..$ title  : chr "Who does X go to for advice and help with work?"
  ..$ by     : chr "David Krackhardt"
  ..$ ref    : chr "Krackhardt D.(1987). Cognitive social structures. Social Networks, 9, 104-134."
  ..$ href   : chr "http://vlado.fmf.uni-lj.si/pub/networks/data/ucinet/ucidata.htm#krackoff"
  ..$ creator: chr "V. Batagelj"
  ..$ date   : chr "Sat Nov 26 16:13:45 2022"
 $ ways  :List of 3
  ..$ advice: chr "advice"
  ..$ friend: chr "friendship"
  ..$ report: chr "Reports_to"
 $ nodes :List of 3
  ..$ advice:'data.frame':      21 obs. of  5 variables:
  .. ..$ ID    : chr [1:21] "A1" "A2" "A3" "A4" ...
  .. ..$ age   : int [1:21] 33 42 40 33 32 59 55 34 62 37 ...
  .. ..$ tenure: num [1:21] 9.33 19.58 12.75 7.5 3.33 ...
  .. ..$ level : int [1:21] 3 2 3 3 3 3 1 3 3 3 ...
  .. ..$ dept  : int [1:21] 4 4 2 4 2 1 0 1 2 3 ...
  ..$ friend:'data.frame':      21 obs. of  1 variable:
  .. ..$ ID: chr [1:21] "A1" "A2" "A3" "A4" ...
  ..$ report:'data.frame':      21 obs. of  1 variable:
  .. ..$ ID: chr [1:21] "A1" "A2" "A3" "A4" ...
 $ links :'data.frame': 2735 obs. of  4 variables:
  ..$ advice: num [1:2735] 1 1 1 1 1 1 1 1 1 1 ...
  ..$ friend: num [1:2735] 2 2 2 2 2 2 2 2 2 2 ...
  ..$ report: num [1:2735] 1 2 3 4 5 6 7 8 9 10 ...
  ..$ w     : num [1:2735] 1 1 1 1 1 1 1 1 1 1 ...
 $ data  : list()
```
Krackhardt CSS

Two networks from the paper Krackhardt D.(1987): [Cognitive social structures](https://www.heinz.cmu.edu/faculty-research/profiles/krackhardt-davidm/_files/1987-cognitive-social-structures.pdf). Social Networks, 9, 104-134.
The relation queried was "Who does X go to for advice and help with work?" (KRACKAD) and "Who is a friend of X?" (KRACKFR).
