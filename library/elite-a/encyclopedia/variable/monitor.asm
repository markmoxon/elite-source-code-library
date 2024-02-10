\ ******************************************************************************
\
\       Name: monitor
\       Type: Variable
\   Category: Encyclopedia
\    Summary: Ship card data for the encyclopedia entry for the Monitor
\  Deep dive: The Encyclopedia Galactica
\
\ ******************************************************************************

.monitor

 EQUB 1                 \ 1: Inservice date:  "3112 ({single cap}ZORGON
 EQUS "3112"            \                      PETTERSON)"
 CTOK 85                \
 CTOK 70                \ Encoded as:         "3112[85][70]"
 EQUB 0

 EQUB 2                 \ 2: Combat factor:   "4"
 EQUS "4"               \
 EQUB 0                 \ Encoded as:         "4"

 EQUB 3                 \ 3: Dimensions:      "100/40/50FT"
 EQUS "100/40/50"       \
 CTOK 42                \ Encoded as:         "100/40/50[42]"
 EQUB 0

 EQUB 4                 \ 4: Speed:           "0.16{all caps}LM{sentence case}"
 EQUS "0.16"            \
 CTOK 64                \ Encoded as:         "0.16[64]"
 EQUB 0

 EQUB 5                 \ 5: Crew:            "7-19"
 EQUS "7-19"            \
 EQUB 0                 \ Encoded as:         "7-19"

 EQUB 6                 \ 6: Range:           "11{all caps}LY{sentence case}"
 EQUS "11"              \
 CTOK 63                \ Encoded as:         "11[63]"
 EQUB 0

IF _RELEASED OR _SOURCE_DISC

 EQUB 7                 \ 7: Cargo space:     "75{all caps}TC{sentence case}"
 EQUS "75"              \
 CTOK 62                \ Encoded as:         "75[62]"
 EQUB 0

ELIF _BUG_FIX

 EQUB 7                 \ 7: Cargo space:     "81{all caps}TC{sentence case}"
 EQUS "81"              \
 CTOK 62                \ Encoded as:         "81[62]"
 EQUB 0

ENDIF

 EQUB 8                 \ 8: Armaments:       "{single cap}KRUGER {all caps}HMB
 CTOK 58                \                      {sentence case} LASER{cr}
 EJMP 1                 \                      GERET STARSEEKER MISSILE"
 EQUS "HMB"             \
 EJMP 2                 \ Encoded as:         "[58]{all caps}HMB{sentence case}
 CTOK 49                \                      [49]{12}[48][46]"
 EJMP 12
 CTOK 48
 CTOK 46
 EQUB 0

 EQUB 9                 \ 9: Hull:            "J6-28{all caps}/4L{sentence
 EQUS "J6-28"           \                      case}"
 CTOK 84                \
 EQUB 0                 \ Encoded as:         "J6-28[84]"

 EQUB 10                \ 10: Drive motors:   "V & K 29.01{cr}LIGHT BLASTERS"
 CTOK 73                \
 EQUS "29.01"           \ Encoded as:         "[73]29.01{12}[55] [74]<244>s"
 EJMP 12
 CTOK 55
 EQUS " "
 CTOK 74
 ETWO 'E', 'R'
 EQUS "s"
 EQUB 0

 EQUB 0

