\ ******************************************************************************
\
\       Name: ophidian
\       Type: Variable
\   Category: Encyclopedia
\    Summary: Ship card data for the encyclopedia entry for the Ophidian
\  Deep dive: The Encyclopedia Galactica
\
\ ******************************************************************************

.ophidian

 EQUB 1                 \ 1: Inservice date:  "2981 ({single cap}OUTWORLD
 EQUS "2981"            \                      WORKSHOPS)"
 CTOK 85                \
 CTOK 69                \ Encoded as:         "2981[85][69][81]"
 CTOK 81
 EQUB 0

 EQUB 2                 \ 2: Combat factor:   "8"
 EQUS "8"               \
 EQUB 0                 \ Encoded as:         "8"

 EQUB 3                 \ 3: Dimensions:      "65/15/30FT"
 EQUS "65/15/30"        \
 CTOK 42                \ Encoded as:         "65/15/30[42]"
 EQUB 0

 EQUB 4                 \ 4: Speed:           "0.34{all caps}LM{sentence case}"
 EQUS "0.34"            \
 CTOK 64                \ Encoded as:         "0.34[64]"
 EQUB 0

 EQUB 5                 \ 5: Crew:            "1-3"
 EQUS "1-3"             \
 EQUB 0                 \ Encoded as:         "1-3"

 EQUB 6                 \ 6: Range:           "7{all caps}LY{sentence case}"
 EQUS "7"               \
 CTOK 63                \ Encoded as:         "7[63]"
 EQUB 0

IF _RELEASED OR _SOURCE_DISC

 EQUB 7                 \ 7: Cargo space:     "20{all caps}TC{sentence case}"
 EQUS "20"              \
 CTOK 62                \ Encoded as:         "20[62]"
 EQUB 0

ELIF _BUG_FIX

 EQUB 7                 \ 7: Cargo space:     "24{all caps}TC{sentence case}"
 EQUS "24"              \
 CTOK 62                \ Encoded as:         "24[62]"
 EQUB 0

ENDIF

 EQUB 8                 \ 8: Armaments:       "LANCE & FERMAN LASER{cr}
 CTOK 57                \                      SEEKER X1 MISSILES"
 CTOK 49                \
 EJMP 12                \ Encoded as:         "[57][49]{12}[54]<244> X1[46]"
 CTOK 54
 ETWO 'E', 'R'
 EQUS " X1"
 CTOK 46
 EQUB 0

 EQUB 9                 \ 9: Hull:            "D4-16{all caps}/1L{sentence
 EQUS "D4-16"           \                      case}"
 CTOK 82                \
 EQUB 0                 \ Encoded as:         "D4-16[82]"

 EQUB 10                \ 10: Drive motors:   "VOLTAIRE STINGER{cr}
 CTOK 60                \                      PULSEDRIVE"
 EQUS " "               \
 ETWO 'S', 'T'          \ Encoded as:         "[60] <222><240>g<244>{12}Pul<218>
 ETWO 'I', 'N'          \                      [53]"
 EQUS "g"
 ETWO 'E', 'R'
 EJMP 12
 EQUS "Pul"
 ETWO 'S', 'E'
 CTOK 53
 EQUB 0

 EQUB 0

