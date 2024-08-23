> M <- read.csv2("media2.csv")
> MM <- DF2MWN(M,c("cntry","ppltrst","pplfair","pplhlp"),
+ network="ESSmedia-ppl",title="ESS media 2023")
> str(MM)
List of 6
 $ format: chr "MWnets"
 $ info  :List of 4
  ..$ network: chr "ESSmedia-ppl"
  ..$ title  : chr "ESS media 2023"
  ..$ by     : chr "DF2MWN"
  ..$ date   : chr "Sun Aug 18 03:32:46 2024"
 $ ways  :List of 4
  ..$ cntry  : chr "cntry"
  ..$ ppltrst: chr "ppltrst"
  ..$ pplfair: chr "pplfair"
  ..$ pplhlp : chr "pplhlp"
 $ nodes :List of 4
  ..$ cntry  :'data.frame':     22 obs. of  1 variable:
  .. ..$ ID: chr [1:22] "BE" "BG" "CH" "CZ" ...
  ..$ ppltrst:'data.frame':     14 obs. of  1 variable:
  .. ..$ ID: chr [1:14] "0" "1" "2" "3" ...
  ..$ pplfair:'data.frame':     14 obs. of  1 variable:
  .. ..$ ID: chr [1:14] "0" "1" "2" "3" ...
  ..$ pplhlp :'data.frame':     14 obs. of  1 variable:
  .. ..$ ID: chr [1:14] "0" "1" "2" "3" ...
 $ links :'data.frame': 37611 obs. of  5 variables:
  ..$ one    : num [1:37611] 1 1 1 1 1 1 1 1 1 1 ...
  ..$ cntry  : int [1:37611] 1 1 1 1 1 1 1 1 1 1 ...
  ..$ ppltrst: int [1:37611] 7 4 7 8 4 5 2 7 8 9 ...
  ..$ pplfair: int [1:37611] 8 5 9 6 9 5 6 5 9 9 ...
  ..$ pplhlp : int [1:37611] 5 4 6 6 9 5 4 4 3 6 ...
 $ data  : list()
