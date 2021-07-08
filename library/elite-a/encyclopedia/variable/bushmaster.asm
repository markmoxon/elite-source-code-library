\ ******************************************************************************
\
\       Name: bushmaster
\       Type: Variable
\   Category: Encyclopedia
\    Summary: Card data for the encyclopedia entry for the Bushmaster
\
\ ******************************************************************************

.bushmaster

 EQUB 1                 \ Inservice date: "3001 ({single cap}ONRIRA ORBITAL)"
 EQUS "3001"            \
 CTOK 85                \ Encoded as:     "3001[85]<223>ri<248> <253>b<219>
 ETWO 'O', 'N'          \                  <228>)"
 EQUS "ri"
 ETWO 'R', 'A'
 EQUS " "
 ETWO 'O', 'R'
 EQUS "b"
 ETWO 'I', 'T'
 ETWO 'A', 'L'
 EQUS ")"
 EQUB 0

 EQUB 2                 \ Combat factor:  "8"
 EQUS "8"               \
 EQUB 0                 \ Encoded as:     "8"

 EQUB 3                 \ Dimensions:     "50/20/50FT"
 EQUS "50/20/50"        \
 CTOK 42                \ Encoded as:     "50/20/50[42]"
 EQUB 0

 EQUB 4                 \ Speed:          "0.35{all caps}LM{sentence case}"
 EQUS "0.35"            \
 CTOK 64                \ Encoded as:     "0.35[64]"
 EQUB 0

 EQUB 5                 \ Crew:           "1-2"
 EQUS "1-2"             \
 EQUB 0                 \ Encoded as:     "1-2"

 EQUB 8                 \ Armaments:      "DUAL 22-18 LASER{cr}
 EQUS "Du"              \                  GERET STARSEEKER MISSILES"
 ETWO 'A', 'L'          \
 EQUS " 22-18"          \ Encoded as:     "Du<228> 22-18[49]{12}[48][46]"
 CTOK 49
 EJMP 12
 CTOK 48
 CTOK 46
 EQUB 0

\EQUB 9                 \ This data is commented out in the original source
\EQUS "3"               \
\CTOK 82                \ It would show the hull as "3{all caps}/1L{sentence
\EQUB 0                 \ case}"

 EQUB 10                \ Drive motors:   "VOLTAIRE WhipLAsh{cr}
 CTOK 60                \                  {all caps}HT{sentence case}
 EQUS " Whip"           \                  PULSEDRIVE"
 ETWO 'L', 'A'          \
 EQUS "sh"              \ Encoded as:     "[60] Whip<249>sh{12}{all caps}HT
 EJMP 12                \                  {sentence case} [50][53]"
 EJMP 1
 EQUS "HT"
 EJMP 2
 EQUS " "
 CTOK 50
 CTOK 53
 EQUB 0

 EQUB 0

