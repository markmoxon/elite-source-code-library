\ ******************************************************************************
\
\       Name: new_ships
\       Type: Variable
\   Category: Buying ships
\    Summary: Ship names and prices for the different ship types we can buy
\  Deep dive: Buying and flying ships in Elite-A
\
\ ******************************************************************************

.new_ships

IF _SOURCE_DISC

 EQUS "ADDER    "       \ #0 = Adder         = 27,000.0 Cr

.new_price

 EQUD 270000

 EQUS "GECKO    "       \ #1 = Gecko         = 32,500.0 Cr
 EQUD 325000

 EQUS "MORAY    "       \ #2 = Moray         = 36,000.0 Cr
 EQUD 360000

 EQUS "COBRA MK1"       \ #3 = Cobra Mk I    = 39,500.0 Cr
 EQUD 395000

 EQUS "IGUANA   "       \ #4 = Iguana        = 64,000.0 Cr
 EQUD 640000

 EQUS "OPHIDIAN "       \ #5 = Ophidian      = 64,500.0 Cr
 EQUD 645000

 EQUS "CHAMELEON"       \ #6 = Chameleon     = 97,500.0 Cr
 EQUD 975000

 EQUS "COBRA MK3"       \ #7 = Cobra Mk III  = 100,000.0 Cr
 EQUD 1000000

 EQUS "GHAVIAL  "       \ #8 = Ghavial       = 136,500.0 Cr
 EQUD 1365000

 EQUS "F"               \ #9 = Fer-de-Lance  = 143,500.0 Cr
 EQUB 144               \
 EQUS "-DE-L"           \ 144 = Two-letter token 'ER'
 EQUB 155               \ 155 = Two-letter token 'AN'
 EQUB 133               \ 133 = Two-letter token 'CE'
 EQUD 1435000

 EQUS "MONITOR  "       \ #10 = Monitor      = 175,000.0 Cr
 EQUD 1750000

 EQUS "PYTHON   "       \ #11 = Python       = 205,000.0 Cr
 EQUD 2050000

 EQUS "BOA      "       \ #12 = Boa          = 240,000.0 Cr
 EQUD 2400000

 EQUS "ANACONDA "       \ #13 = Anaconda     = 400,000.0 Cr
 EQUD 4000000

 EQUS "ASP MK2  "       \ #14 = Asp Mk II    = 895,000.0 Cr
 EQUD 8950000

ELIF _RELEASED

 EQUS "ADDER    "       \ #0 = Adder         = 31,000.0 Cr

.new_price

 EQUD 310000

 EQUS "GECKO    "       \ #1 = Gecko         = 40,000.0 Cr
 EQUD 400000

 EQUS "MORAY    "       \ #2 = Moray         = 56,500.0 Cr
 EQUD 565000

 EQUS "COBRA MK1"       \ #3 = Cobra Mk I    = 75,000.0 Cr
 EQUD 750000

 EQUS "IGUANA   "       \ #4 = Iguana        = 131,500.0 Cr
 EQUD 1315000

 EQUS "OPHIDIAN "       \ #5 = Ophidian      = 147,000.0 Cr
 EQUD 1470000

 EQUS "CHAMELEON"       \ #6 = Chameleon     = 225,000.0 Cr
 EQUD 2250000

 EQUS "COBRA MK3"       \ #7 = Cobra Mk III  = 287,000.0 Cr
 EQUD 2870000

 EQUS "F"               \ #8 = Fer-de-Lance  = 359,500.0 Cr
 EQUB 144               \
 EQUS "-DE-L"           \ 144 = Two-letter token 'ER'
 EQUB 155               \ 155 = Two-letter token 'AN'
 EQUB 133               \ 133 = Two-letter token 'CE'
 EQUD 3595000

 EQUS "GHAVIAL  "       \ #9 = Ghavial       = 379,500.0 Cr
 EQUD 3795000

 EQUS "MONITOR  "       \ #10 = Monitor      = 585,500.0 Cr
 EQUD 5855000

 EQUS "PYTHON   "       \ #11 = Python       = 762,000.0 Cr
 EQUD 7620000

 EQUS "BOA      "       \ #12 = Boa          = 960,000.0 Cr
 EQUD 9600000

 EQUS "ASP MK2  "       \ #13 = Asp Mk II    = 1012,000.0 Cr
 EQUD 10120000

 EQUS "ANACONDA "       \ #14 = Anaconda     = 1869,500.0 Cr
 EQUD 18695000

ENDIF

