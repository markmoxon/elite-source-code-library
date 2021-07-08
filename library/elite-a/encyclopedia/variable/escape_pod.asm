\ ******************************************************************************
\
\       Name: escape_pod
\       Type: Variable
\   Category: Encyclopedia
\    Summary: Card data for the encyclopedia entry for the escape pod
\
\ ******************************************************************************

.escape_pod

 EQUB 1                 \ Inservice date: "PRE-2500"
 EQUS "p"               \
 ETWO 'R', 'E'          \ Encoded as:     "p<242>-2500"
 EQUS "-2500"
 EQUB 0

 EQUB 3                 \ Dimensions:     "10/5/5FT"
 EQUS "10/5/5"          \
 CTOK 42                \ Encoded as:     "10/5/5[42]"
 EQUB 0

 EQUB 4                 \ Speed:          "0.08{all caps}LM{sentence case}"
 EQUS "0.08"            \
 CTOK 64                \ Encoded as:     "0.08[64]"
 EQUB 0

 EQUB 5                 \ Crew:           "1-2"
 EQUS "1-2"             \
 EQUB 0                 \ Encoded as:     "1-2"

 EQUB 0

