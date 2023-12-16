\ ******************************************************************************
\
\       Name: NA%
\       Type: Variable
\   Category: Save and load
\    Summary: The data block for the last saved commander
\
\ ******************************************************************************

 EQUS ":0.E."           \ The drive part of this string (the "0") is updated
                        \ with the chosen drive in the GTNMEW routine, but the
                        \ directory part (the "E") is fixed. The variable is
                        \ followed directly by the commander file at NA%, which
                        \ starts with the commander name, so the full string at
                        \ NA%-5 is in the format ":0.E.jameson", which gives the
                        \ full filename of the commander file

.NA%

 EQUS "jameson"         \ The current commander name
 EQUB 13

 SKIP 53                \ Placeholders for bytes #0 to #52

 EQUB 16                \ AVL+0  = Market availability of food, #53
 EQUB 15                \ AVL+1  = Market availability of textiles, #54
 EQUB 17                \ AVL+2  = Market availability of radioactives, #55
 EQUB 0                 \ AVL+3  = Market availability of slaves, #56
 EQUB 3                 \ AVL+4  = Market availability of liquor/Wines, #57
 EQUB 28                \ AVL+5  = Market availability of luxuries, #58
 EQUB 14                \ AVL+6  = Market availability of narcotics, #59
 EQUB 0                 \ AVL+7  = Market availability of computers, #60
 EQUB 0                 \ AVL+8  = Market availability of machinery, #61
 EQUB 10                \ AVL+9  = Market availability of alloys, #62
 EQUB 0                 \ AVL+10 = Market availability of firearms, #63
 EQUB 17                \ AVL+11 = Market availability of furs, #64
 EQUB 58                \ AVL+12 = Market availability of minerals, #65
 EQUB 7                 \ AVL+13 = Market availability of gold, #66
 EQUB 9                 \ AVL+14 = Market availability of platinum, #67
 EQUB 8                 \ AVL+15 = Market availability of gem-stones, #68
 EQUB 0                 \ AVL+16 = Market availability of alien items, #69

 SKIP 3                 \ Placeholders for bytes #70 to #72

 EQUB 128               \ SVC = Save count, #73

