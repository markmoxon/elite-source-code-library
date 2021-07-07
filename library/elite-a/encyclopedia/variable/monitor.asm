\ ******************************************************************************
\
\       Name: monitor
\       Type: Variable
\   Category: Encyclopedia
\    Summary: Card data for the encyclopedia entry for the Monitor
\
\ ******************************************************************************

.monitor

 EQUB 1                 \ Inservice date: ""
 EQUS "3112"            \
 CTOK 85                \ Encoded as:     ""
 CTOK 70
 EQUB 0

 EQUB 2                 \ Combat factor:  "4"
 EQUS "4"               \
 EQUB 0                 \ Encoded as:     "4"

 EQUB 3                 \ Dimensions:     "100/40/50FT"
 EQUS "100/40/50"       \
 CTOK 42                \ Encoded as:     "100/40/50[42]"
 EQUB 0

 EQUB 4                 \ Speed:          "0.16LM"
 EQUS "0.16"            \
 CTOK 64                \ Encoded as:     "0.16[64]"
 EQUB 0

 EQUB 5                 \ Crew:           "7-19"
 EQUS "7-19"            \
 EQUB 0                 \ Encoded as:     "7-19"

 EQUB 6                 \ Range:          "11LY"
 EQUS "11"              \
 CTOK 63                \ Encoded as:     "11[63]"
 EQUB 0

 EQUB 7                 \ Cargo space:    "75TC"
 EQUS "75"             \
 CTOK 62                \ Encoded as:     "75[62]"
 EQUB 0

 EQUB 8                 \ Armaments:      ""
 CTOK 58                \
 EQUB &01               \ Encoded as:     ""
 EQUS "HMB"
 EQUB &02
 CTOK 49
 EQUB 12
 CTOK 48
 CTOK 46
 EQUB 0

 EQUB 9                 \ Hull:           "J6-28{all caps}/4L{sentence case}"
 EQUS "J6-28"           \
 CTOK 84                \ Encoded as:     "J6-28[84]"
 EQUB 0

 EQUB 10                \ Drive motors:   ""
 CTOK 73                \
 EQUS "29.01"           \ Encoded as:     ""
 EQUB 12
 CTOK 55
 EQUS " "
 CTOK 74
 ETWO 'E', 'R'
 EQUS "s"
 EQUB 0

 EQUB 0

