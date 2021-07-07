\ ******************************************************************************
\
\       Name: sidewinder
\       Type: Variable
\   Category: Encyclopedia
\    Summary: Card data for the encyclopedia entry for the Sidewinder
\
\ ******************************************************************************

.sidewinder

 EQUB 1                 \ Inservice date: ""
 EQUS "2982"            \
 CTOK 85                \ Encoded as:     ""
 ETWO 'O', 'N'
 EQUS "ri"
 ETWO 'R', 'A'
 EQUS " "
 ETWO 'O', 'R'
 EQUS "b"
 ETWO 'I', 'T'
 ETWO 'A', 'L'
 EQUS ")"
 EQUB 0

 EQUB 2                 \ Combat factor:  "9"
 EQUS "9"               \
 EQUB 0                 \ Encoded as:     "9"

 EQUB 3                 \ Dimensions:     "35/15/65FT"
 EQUS "35/15/65"        \
 CTOK 42                \ Encoded as:     "35/15/65[42]"
 EQUB 0

 EQUB 4                 \ Speed:          "0.37LM"
 EQUS "0.37"            \
 CTOK 64                \ Encoded as:     "0.37[64]"
 EQUB 0

 EQUB 5                 \ Crew:           "1"
 EQUS "1"               \
 EQUB 0                 \ Encoded as:     "1"

 EQUB 8                 \ Armaments:      ""
 EQUS "Du"              \
 ETWO 'A', 'L'          \ Encoded as:     ""
 EQUS " 22-18"
 CTOK 49
 EQUB 0

\EQUB 0, 9              \ This data is commented out in the orginal source
\EQUA "3|!R"

 EQUB 10                \ Drive motors:   ""
 CTOK 71                \
 EQUS " Sp"             \ Encoded as:     ""
 ETWO 'I', 'N'
 CTOK 78
 EQUS " "
 EQUB &01
 EQUS "MV"
 EQUB &02
 EQUB 0

 EQUB 0

