\ ******************************************************************************
\
\       Name: mamba
\       Type: Variable
\   Category: Encyclopedia
\    Summary: Ship card data for the encyclopedia entry for the Mamba
\  Deep dive: The Encyclopedia Galactica
\
\ ******************************************************************************

.mamba

 EQUB 1                 \ 1: Inservice date:  "3110 ({single cap}REORTE SHIP
 EQUS "3110"            \                      FEDERATION)"
 CTOK 85                \
 ETWO 'R', 'E'          \ Encoded as:         "3110[85]<242><253>te[67] [76])"
 ETWO 'O', 'R'
 EQUS "te"
 CTOK 67
 EQUS " "
 CTOK 76
 EQUS ")"
 EQUB 0

 EQUB 2                 \ 2: Combat factor:   "8"
 EQUS "8"               \
 EQUB 0                 \ Encoded as:         "8"

 EQUB 3                 \ 3: Dimensions:      "55/12/65FT"
 EQUS "55/12/65"        \
 CTOK 42                \ Encoded as:         "55/12/65[42]"
 EQUB 0

 EQUB 4                 \ 4: Speed:           "0.30{all caps}LM{sentence case}"
 EQUS "0.30"            \
 CTOK 64                \ Encoded as:         "0.30[64]"
 EQUB 0

 EQUB 5                 \ 5: Crew:            "1-2"
 EQUS "1-2"             \
 EQUB 0                 \ Encoded as:         "1-2"

 EQUB 7                 \ 7: Cargo space:     "10{all caps}TC{sentence case}"
 EQUS "10"              \
 CTOK 62                \ Encoded as:         "10[62]"
 EQUB 0

 EQUB 8                 \ 8: Armaments:       "ERGON LASER SYSTEM{cr}
 CTOK 52                \                      {all caps}IFS{sentence case} SEEK
 CTOK 49                \                      & HUNT MISSILES"
 CTOK 51                \
 EJMP 12                \ Encoded as:         "[52][49][51]{12}[86][54] & [79]
 CTOK 86                \                      [46]"
 CTOK 54
 EQUS " & "
 CTOK 79
 CTOK 46
 EQUB 0

\EQUB 9                 \ This data is commented out in the original source
\EQUS "7"               \
\CTOK 82                \ It would show the hull as "7{all caps}/1L{sentence
\EQUB 0                 \ case}"

 EQUB 10                \ 10: Drive motors:   "SEEKLIGHT {all caps}HV{sentence
 CTOK 54                \                      case}THRUST"
 CTOK 55                \
 EQUS " "               \ Encoded as:         "[54][55] {all caps}HV{sentence
 EJMP 1                 \                      case}[66]"
 EQUS "HV"
 EJMP 2
 EQUS " "
 CTOK 66
 EQUB 0

 EQUB 0

