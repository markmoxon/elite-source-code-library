\ ******************************************************************************
\
\       Name: fer_de_lance
\       Type: Variable
\   Category: Encyclopedia
\    Summary: Card data for the encyclopedia entry for the Fer-de-Lance
\
\ ******************************************************************************

.fer_de_lance

 EQUB 1                 \ Inservice date: "3100 ({single cap}ZORGON PETTERSON)"
 EQUS "3100"            \
 CTOK 85                \ Encoded as:     "3100[85][70]"
 CTOK 70
 EQUB 0

 EQUB 2                 \ Combat factor:  "6"
 EQUS "6"               \
 EQUB 0                 \ Encoded as:     "6"

 EQUB 3                 \ Dimensions:     "85/20/45FT"
 EQUS "85/20/45"        \
 CTOK 42                \ Encoded as:     "85/20/45[42]"
 EQUB 0

 EQUB 4                 \ Speed:          "0.30{all caps}LM{sentence case}"
 EQUS "0.30"            \
 CTOK 64                \ Encoded as:     "0.30[64]"
 EQUB 0

 EQUB 5                 \ Crew:           "1-3"
 EQUS "1-3"             \
 EQUB 0                 \ Encoded as:     "1-3"

 EQUB 6                 \ Range:          "8.5{all caps}LY{sentence case}"
 EQUS "8.5"             \
 CTOK 63                \ Encoded as:     "8.5[63]"
 EQUB 0

 EQUB 7                 \ Cargo space:    "2{all caps}TC{sentence case}"
 EQUS "2"               \
 CTOK 62                \ Encoded as:     "2[62]"
 EQUB 0

 EQUB 8                 \ Armaments:      "ERGON LASER SYSTEM{cr}
 CTOK 52                \                  {all caps}IFS{sentence case} SEEK &
 CTOK 49                \                  HUNT MISSILES"
 CTOK 51                \
 EJMP 12                \ Encoded as:     "[52][49][51]{12}[86][54] & [79][46]"
 CTOK 86
 CTOK 54
 EQUS " & "
 CTOK 79
 CTOK 46
 EQUB 0

 EQUB 9                 \ Hull:           "H7-28{all caps}/4L{sentence case}"
 EQUS "H7-28"           \
 CTOK 84                \ Encoded as:     "H7-28[84]"
 EQUB 0

 EQUB 10                \ Drive motors:   "TITRONIX INTERSUN{cr}
 EQUS "T"               \                  {all caps}LT{sentence case} {single
 ETWO 'I', 'T'          \                  cap}IONIC"
 EQUS "r"               \
 ETWO 'O', 'N'          \ Encoded as:     "T<219>r<223>ix <240>t<244>sun{12}
 EQUS "ix "             \                  {all caps}LT{sentence case} [78]"
 ETWO 'I', 'N'
 EQUS "t"
 ETWO 'E', 'R'
 EQUS "sun"
 EJMP 12
 EJMP 1
 EQUS "LT"
 EJMP 2
 EQUS " "
 CTOK 78
 EQUB 0

 EQUB 0

