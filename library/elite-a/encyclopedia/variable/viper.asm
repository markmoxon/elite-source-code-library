\ ******************************************************************************
\
\       Name: viper
\       Type: Variable
\   Category: Encyclopedia
\    Summary: Card data for the encyclopedia entry for the Viper
\
\ ******************************************************************************

.viper

 EQUB 1                 \ Inservice date: "2762 ({single cap}FAULCON MANSPACE)"
 EQUS "2762"            \
 CTOK 85                \ Encoded as:     "2762[85]Faulc<223> <239>n[77])"
 EQUS "Faulc"
 ETWO 'O', 'N'
 EQUS " "
 ETWO 'M', 'A'
 EQUS "n"
 CTOK 77
 EQUS ")"
 EQUB 0

 EQUB 2                 \ Combat factor:  "7"
 EQUS "7"               \
 EQUB 0                 \ Encoded as:     "7"

 EQUB 3                 \ Dimensions:     "55/20/50FT"
 EQUS "55/20/50"        \
 CTOK 42                \ Encoded as:     "55/20/50[42]"
 EQUB 0

 EQUB 4                 \ Speed:          "0.32{all caps}LM{sentence case}"
 EQUS "0.32"            \
 CTOK 64                \ Encoded as:     "0.32[64]"
 EQUB 0

 EQUB 5                 \ Crew:           "1-10"
 EQUS "1-10"            \
 EQUB 0                 \ Encoded as:     "1-10"

 EQUB 8                 \ Armaments:      "INGRAM MEGABLAST PULSE LASER{cr}
 CTOK 56                \                  SEEKER X3 MISSILES"
 EQUS " Mega"           \
 CTOK 74                \ Encoded as:     "[56] Mega[74][50][49]{12}[54]<244> X3
 CTOK 50                \                  [46]"
 CTOK 49
 EJMP 12
 CTOK 54
 ETWO 'E', 'R'
 EQUS " X3"
 CTOK 46
 EQUB 0

\EQUB 9                 \ This data is commented out in the original source
\EQUS "9"               \
\CTOK 82                \ It would show the hull as "9{all caps}/1L{sentence
\EQUB 0                 \ case}"

 EQUB 10                \ Drive motors:   "DE{single cap}LACY SUPER THRUST{cr}
 CTOK 71                \                  {all caps}VC{sentence case}10"
 EQUS " Sup"            \
 ETWO 'E', 'R'          \ Encoded as:     "[71] Sup<244> [66]{12}{all caps}VC
 EQUS " "               \                  {sentence case}10"
 CTOK 66
 EJMP 12
 EJMP 1
 EQUS "VC"
 EJMP 2
 EQUS "10"
 EQUB 0

 EQUB 0

