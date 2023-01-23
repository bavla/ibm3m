# Multiway network data sets


| Network | Columns |  Sizes | Structure |
| :---         |     :---       |     :---       |      :---:   |
| [VisTest](https://raw.githubusercontent.com/bavla/ibm3m/master/data/VisTest.json)   | (SOURCE, TARGET, LINKTYPE, DATE, WEIGHT)    | (8, 8, 4, 4, 18)     | [str](https://github.com/bavla/ibm3m/blob/master/data/str/VisTest.md)     |
| [CoresTest](https://raw.githubusercontent.com/bavla/ibm3m/master/data/coresTest.json)   | (U, V, w)    | (20, 20, 56)     | [str](https://github.com/bavla/ibm3m/blob/master/data/str/coresTest.md)     |
| [GcoresTest](https://raw.githubusercontent.com/bavla/ibm3m/master/data/GcoresTest.json)   | (U, V, w)    | (8, 8, 32)     | [str](https://github.com/bavla/ibm3m/blob/master/data/str/GcoresTest.md)     |
| [TwoModeTest](https://raw.githubusercontent.com/bavla/ibm3m/master/TwoModeTest.json)   | (U, V, w)    | (6, 8, 22)     | [str](https://github.com/bavla/ibm3m/blob/master/data/str/TwoModeTest.md)     |
| [KRACKAD](https://raw.githubusercontent.com/bavla/ibm3m/master/data/KRACKAD.json)   | (advice, friend, report, w=1)    | (21, 21, 21, 2735)     | [str](https://github.com/bavla/ibm3m/blob/master/data/str/KRACKAD.md)     |
| [KRACKFR](https://raw.githubusercontent.com/bavla/ibm3m/master/data/KRACKFR.json)   | (advice, friend, report, w=1)    | (21, 21, 21, 790)      | [str](https://github.com/bavla/ibm3m/blob/master/data/str/KRACKFR.md)     |
| [Lazega](https://raw.githubusercontent.com/bavla/ibm3m/master/data/lazega36.json)   | (way1, way2, way3, w=1)      | (36, 36, 36, 3045)       | [str](https://github.com/bavla/ibm3m/blob/master/data/str/Lazega36.md)      |
| [RobinsBank](https://raw.githubusercontent.com/bavla/ibm3m/master/data/RobinsBank.json)   | (P1, P2, R, w=1)      | (11, 11, 4, 128)       | [str](https://github.com/bavla/ibm3m/blob/master/data/str/RobinsBank.md)      |
| [Random35](https://raw.githubusercontent.com/bavla/ibm3m/master/data/random35.json)   | (X, Y, Z, w=1)      | (35, 35, 35, 12777)      | [str](https://github.com/bavla/ibm3m/blob/master/data/str/random35.md)     |
| [marmello77](https://raw.githubusercontent.com/bavla/ibm3m/master/data/marmello77.json)   | (an, pl, R, w)      | (9, 34, 2, 72)      | [str](https://github.com/bavla/ibm3m/blob/master/data/str/marmello77.md)     |
| [CSaarhus](https://raw.githubusercontent.com/bavla/ibm3m/master/data/CSaarhus.json)   | (P1, P2, R, w=1)      | (61, 61, 5, 620)      | [str](https://github.com/bavla/ibm3m/blob/master/data/str/CSaarhus.md)     |
| [Vickers](https://raw.githubusercontent.com/bavla/ibm3m/master/data/Vickers.json)   | (S1, S1, R, w=1)      | (29, 29, 3, 740)      | [str](https://github.com/bavla/ibm3m/blob/master/data/str/vickers.md)     |
| [Polit](https://raw.githubusercontent.com/bavla/ibm3m/master/data/polit.json)   | (P1, P2, S, w)      | (12, 12, 2, 288)      | [str](https://github.com/bavla/ibm3m/blob/master/data/str/polit.md)     |
| [Kinship](https://raw.githubusercontent.com/bavla/ibm3m/master/data/kinship.json)   | (T1, T2, K, w)      | (15, 15, 6, 1350)      | [str](https://github.com/bavla/ibm3m/blob/master/data/str/kinship.md)     |
| [Birds](https://github.com/bavla/ibm3m/raw/master/data/birds.zip)   | (V1, V2, type, w)      | collection 19 nets      | [str](https://github.com/bavla/ibm3m/blob/master/data/str/birds.md)     |
| [tableware](https://raw.githubusercontent.com/bavla/ibm3m/master/data/tableware.json)   | (FROM, TO, TYPE, PERIOD, WEIGHT)      | (69, 69, 2, 3, 1590)      | [str](https://github.com/bavla/ibm3m/blob/master/data/str/tableware.md)     |
| [AirEu2013](https://raw.githubusercontent.com/bavla/ibm3m/master/data/AirEu2013Ext.json)  | (airA, airB, line, w=1)  | (450, 450, 37, 7176)   | [str](https://github.com/bavla/ibm3m/blob/master/data/str/AirEu2013.md)  |
| students  | (prov, univ, prog, year, w)      | (107, 79, 11, 4, 37205)       | [str](https://github.com/bavla/ibm3m/blob/master/data/str/students.md)      |



## Krackhardt CSS

Two networks from the paper Krackhardt D.(1987): [Cognitive social structures](https://www.heinz.cmu.edu/faculty-research/profiles/krackhardt-davidm/_files/1987-cognitive-social-structures.pdf). Social Networks, 9, 104-134.
The relation queried was "Who does X go to for advice and help with work?" (KRACKAD) and "Who is a friend of X?" (KRACKFR).

## Lazega's lawyers / 36 partners

[Lazega](https://raw.githubusercontent.com/bavla/ibm3m/master/data/lazega36.json)

## Robins bank - organizational structure in a bank branch

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

## Random multiway network from IBM3M

[Random35](https://raw.githubusercontent.com/bavla/ibm3m/master/data/random35.json)

## CS Aarhus

## Vickers

## Politicians - Dissimilarity ratings of Second World War politicians by two subjects

http://vladowiki.fmf.uni-lj.si/doku.php?id=notes:da:clu:mul

Dissimilarity ratings of 12  Second World War politicians  (Hitler, Mussolini, Churchill, Eisenhower, Stalin, Attlee, Franco, De Gaulle, MaoTseTung, Truman, Chamberlain, Tito) were made by two subjects.

Source: B.S. Everitt: Introduction to optimization methods and their application in statistics. Chapman and Hall, London, 1987, p. 72.

## Kinship - Rosenberg and Kim (1975) Kinship Terms

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
    
## European airlines 2013

[AirEu2013](https://raw.githubusercontent.com/bavla/ibm3m/master/data/AirEu2013.json)

## Students

http://vladowiki.fmf.uni-lj.si/doku.php?id=vlado:work:2m:mwn:tnet

