# Multiway network data sets

| Network | Columns |  Sizes | Structure |
| :---         |     :---       |     :---       |      :---:   |
| [KRACKAD](https://raw.githubusercontent.com/bavla/ibm3m/master/data/KRACKAD.json)   | (advice, friend, report, w=1)    | (21, 21, 21, 2735)     | [str](https://github.com/bavla/ibm3m/blob/master/data/str/KRACKAD.md)     |
| [KRACKFR](https://raw.githubusercontent.com/bavla/ibm3m/master/data/KRACKFR.json)   | (advice, friend, report, w=1)    | (21, 21, 21, 790)      | [str](https://github.com/bavla/ibm3m/blob/master/data/str/KRACKFR.md)     |
| [Lazega](https://raw.githubusercontent.com/bavla/ibm3m/master/data/lazega36.json)   | (way1, way2, way3, w=1)      | (36, 36, 36, 3045)       | [str](https://github.com/bavla/ibm3m/blob/master/data/str/Lazega36.md)      |
| [Random35](https://raw.githubusercontent.com/bavla/ibm3m/master/data/random35.json)   | (X, Y, Z, w=1)      | (35, 35, 35, 12777)      | [str](https://github.com/bavla/ibm3m/blob/master/data/str/random35.md)     |
| [Polit](https://raw.githubusercontent.com/bavla/ibm3m/master/data/polit.json)   | (P1, P2, S, w)      | (12, 12, 2, 288)      | [str](https://github.com/bavla/ibm3m/blob/master/data/str/polit.md)     |
| [Kinship](https://raw.githubusercontent.com/bavla/ibm3m/master/data/kinship.json)   | (T1, T2, K, w)      | (15, 15, 6, 1350)      | [str](https://github.com/bavla/ibm3m/blob/master/data/str/kinship.md)     |
| [AirEu2013](https://raw.githubusercontent.com/bavla/ibm3m/master/data/AirEu2013.json)  | (airA, airB, line, w=1)  | (450, 450, 37, 7176)   | [str](https://github.com/bavla/ibm3m/blob/master/data/str/AirEu2013.md)  |
| students  | (prov, univ, prog, year, w)      | (107, 79, 11, 4, 37205)       | [str](https://github.com/bavla/ibm3m/blob/master/data/str/students.md)      |

## Krackhardt CSS

Two networks from the paper Krackhardt D.(1987): [Cognitive social structures](https://www.heinz.cmu.edu/faculty-research/profiles/krackhardt-davidm/_files/1987-cognitive-social-structures.pdf). Social Networks, 9, 104-134.
The relation queried was "Who does X go to for advice and help with work?" (KRACKAD) and "Who is a friend of X?" (KRACKFR).

## Lazega's lawyers / 36 partners

[Lazega](https://raw.githubusercontent.com/bavla/ibm3m/master/data/lazega36.json)

## Random multiway network from IBM3M

[Random35](https://raw.githubusercontent.com/bavla/ibm3m/master/data/random35.json)

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
## European airlines 2013

[AirEu2013](https://raw.githubusercontent.com/bavla/ibm3m/master/data/AirEu2013.json)

## Students
