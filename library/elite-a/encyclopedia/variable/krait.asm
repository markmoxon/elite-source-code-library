\ ******************************************************************************
\
\       Name: krait
\       Type: Variable
\   Category: Encyclopedia
\    Summary: Ship card data for the encyclopedia entry for the Krait
\
\ ******************************************************************************

.krait

 EQUB 1                 \ 1: Inservice date:  "3027 ({single cap}DE{single cap}
 EQUS "3027"            \                      LACY SHIPWORKS, ININES)"
 CTOK 85                \
 CTOK 71                \ Encoded as:         "3027[85][71][67]W<253>ks, <240>
 CTOK 67                \                      <240><237>)"
 EQUS "W"
 ETWO 'O', 'R'
 EQUS "ks, "
 ETWO 'I', 'N'
 ETWO 'I', 'N'
 ETWO 'E', 'S'
 EQUS ")"
 EQUB 0

 EQUB 2                 \ 2: Combat factor:   "7"
 EQUS "7"               \
 EQUB 0                 \ Encoded as:         "7"

 EQUB 3                 \ 3: Dimensions:      "80/20/90FT"
 EQUS "80/20/90"        \
 CTOK 42                \ Encoded as:         "80/20/90[42]"
 EQUB 0

 EQUB 4                 \ 4: Speed:           "0.30{all caps}LM{sentence case}"
 EQUS "0.30"            \
 CTOK 64                \ Encoded as:         "0.30[64]"
 EQUB 0

 EQUB 5                 \ 5: Crew:            "1"
 EQUS "1"               \
 EQUB 0                 \ Encoded as:         "1"

 EQUB 7                 \ 7: Cargo space:     "10{all caps}TC{sentence case}"
 EQUS "10"              \
 CTOK 62                \ Encoded as:         "10[62]"
 EQUB 0

 EQUB 8                 \ 8: Armaments:       "ERGON LASER SYSTEM"
 CTOK 52                \
 CTOK 49                \ Encoded as:         "[52][49][51]"
 CTOK 51
 EQUB 0

\EQUB 9                 \ This data is commented out in the original source
\EQUS "8"               \
\CTOK 83                \ It would show the hull as "8{all caps}/2L{sentence
\EQUB 0                 \ case}"

 EQUB 10                \ 10: Drive motors:   "DE{single cap}LACY SPIN{single
 CTOK 71                \                      cap}IONIC ZX14"
 EQUS " Sp"             \
 ETWO 'I', 'N'          \ Encoded as:         "[71] Sp<240>[78] ZX14"
 CTOK 78
 EQUS " ZX14"
 EQUB 0

 EQUB 0

