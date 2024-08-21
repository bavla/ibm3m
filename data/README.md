# Multiway network data sets


| Network | Columns |  Sizes | Structure |
| :---         |     :---       |     :---       |      :---:   |
| [VisTest](https://raw.githubusercontent.com/bavla/ibm3m/master/data/VisTest.json)   | (SOURCE, TARGET, LINKTYPE, DATE, WEIGHT)    | (8, 8, 4, 4, 18)     | [str](https://github.com/bavla/ibm3m/blob/master/data/str/VisTest.md)     |
| [CoresTest](https://raw.githubusercontent.com/bavla/ibm3m/master/data/coresTest.json)   | (U, V, w=1)    | (21, 20, 58)     | [str](https://github.com/bavla/ibm3m/blob/master/data/str/coresTest.md)     |
| [GcoresTest](https://raw.githubusercontent.com/bavla/ibm3m/master/data/GcoresTest.json)   | (U, V, w)    | (8, 8, 32)     | [str](https://github.com/bavla/ibm3m/blob/master/data/str/GcoresTest.md)     |
| [TwoModeTest](https://raw.githubusercontent.com/bavla/ibm3m/master/TwoModeTest.json)   | (U, V, w=1)    | (6, 8, 25)     | [str](https://github.com/bavla/ibm3m/blob/master/data/str/TwoModeTest.md)     |
| [KRACKAD](https://raw.githubusercontent.com/bavla/ibm3m/master/data/KRACKAD.json)   | (advice, friend, report, w=1)    | (21, 21, 21, 2735)     | [str](https://github.com/bavla/ibm3m/blob/master/data/str/KRACKAD.md)     |
| [KRACKFR](https://raw.githubusercontent.com/bavla/ibm3m/master/data/KRACKFR.json)   | (advice, friend, report, w=1)    | (21, 21, 21, 790)      | [str](https://github.com/bavla/ibm3m/blob/master/data/str/KRACKFR.md)     |
| [Lazega](https://raw.githubusercontent.com/bavla/ibm3m/master/data/lazega36.json)   | (way1, way2, way3, w=1)      | (36, 36, 36, 3045)       | [str](https://github.com/bavla/ibm3m/blob/master/data/str/Lazega36.md)      |
| [RobinsBank](https://raw.githubusercontent.com/bavla/ibm3m/master/data/RobinsBank.json)   | (P1, P2, R, w=1)      | (11, 11, 4, 128)       | [str](https://github.com/bavla/ibm3m/blob/master/data/str/RobinsBank.md)      |
| [WiringRoom](https://raw.githubusercontent.com/bavla/ibm3m/master/data/WiringRoom.json)   | (P1, P2, R, w)      | (14, 14, 6, 189)       | [str](https://github.com/bavla/ibm3m/blob/master/data/str/WiringRoom.md)      |
| [Random35](https://raw.githubusercontent.com/bavla/ibm3m/master/data/random35.json)   | (X, Y, Z, w=1)      | (35, 35, 35, 12777)      | [str](https://github.com/bavla/ibm3m/blob/master/data/str/random35.md)     |
| [marmello77](https://raw.githubusercontent.com/bavla/ibm3m/master/data/marmello77.json)   | (an, pl, R, w)      | (9, 34, 2, 72)      | [str](https://github.com/bavla/ibm3m/blob/master/data/str/marmello77.md)     |
| [CSaarhus](https://raw.githubusercontent.com/bavla/ibm3m/master/data/CSaarhus.json)   | (P1, P2, R, w=1)      | (61, 61, 5, 620)      | [str](https://github.com/bavla/ibm3m/blob/master/data/str/CSaarhus.md)     |
| [Vickers](https://raw.githubusercontent.com/bavla/ibm3m/master/data/Vickers.json)   | (S1, S1, R, w=1)      | (29, 29, 3, 740)      | [str](https://github.com/bavla/ibm3m/blob/master/data/str/vickers.md)     |
| [Students CSN](https://raw.githubusercontent.com/bavla/ibm3m/master/data/Students.json)   | (S1, S1, R, w=1)      | (185, 185, 3, 360)      | [str](https://github.com/bavla/ibm3m/blob/master/data/str/studentsCSN.md)     |
| [Polit](https://raw.githubusercontent.com/bavla/ibm3m/master/data/polit.json)   | (P1, P2, S, w)      | (12, 12, 2, 288)      | [str](https://github.com/bavla/ibm3m/blob/master/data/str/polit.md)     |
| [Kinship](https://raw.githubusercontent.com/bavla/ibm3m/master/data/kinship.json)   | (T1, T2, K, w)      | (15, 15, 6, 1350)      | [str](https://github.com/bavla/ibm3m/blob/master/data/str/kinship.md)     |
| [Birds](https://github.com/bavla/ibm3m/raw/master/data/birds.zip)   | (V1, V2, type, w)      | collection 19 nets      | [str](https://github.com/bavla/ibm3m/blob/master/data/str/birds.md)     |
| [tableware](https://raw.githubusercontent.com/bavla/ibm3m/master/data/tableware.json)   | (FROM, TO, TYPE, PERIOD, WEIGHT)      | (69, 69, 2, 3, 1590)      | [str](https://github.com/bavla/ibm3m/blob/master/data/str/tableware.md)     |
| [Olympics](https://raw.githubusercontent.com/bavla/ibm3m/master/data/Olympics1.json)  | (Olympics, Country, Discipline, w)  | (9, 127, 41, 2843)   | [str](https://github.com/bavla/ibm3m/blob/master/data/str/Olympics1.md)  |
| [ESS media](https://raw.githubusercontent.com/bavla/ibm3m/master/data/ESSmedia.json)  | (Country, Trust, Fair, Help, w)  | (22, 14, 14, 2843)   | [str](https://github.com/bavla/ibm3m/blob/master/data/str/ESSmedia.md)  |
| [Chicago crime](https://raw.githubusercontent.com/bavla/ibm3m/master/data/ChicagoCrime1.json)  | (primary, location, ward, w)  | (31, 135, 50, 18598)   | [str](https://github.com/bavla/ibm3m/blob/master/data/str/ChicagoCrime1.md)  |
| [AirEu2013](https://raw.githubusercontent.com/bavla/ibm3m/master/data/AirEu2013Ext.json)  | (airA, airB, line, w=1)  | (450, 450, 37, 7176)   | [str](https://github.com/bavla/ibm3m/blob/master/data/str/AirEu2013.md)  |
| students  | (prov, univ, prog, year, w)      | (107, 79, 11, 4, 37205)       | [str](https://github.com/bavla/ibm3m/blob/master/data/str/students.md)      |



