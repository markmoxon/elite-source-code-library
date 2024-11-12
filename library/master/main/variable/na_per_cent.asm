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

IF NOT(_APPLE_VERSION)

 EQUS "jameson"         \ The current commander name
 EQUB 13

ELIF _APPLE_VERSION

IF _IB_DISK

 EQUS "JAMESON"         \ The current commander name
 EQUB 13

ELIF _SOURCE_DISK_BUILD OR _SOURCE_DISK_ELT_FILES OR _SOURCE_DISK_CODE_FILES

 EQUS "jameson"         \ The current commander name
 EQUB 13

ENDIF

ENDIF

IF NOT(_APPLE_VERSION)

 SKIP 53                \ Placeholders for bytes #0 to #52

ELIF _APPLE_VERSION

IF _IB_DISK

                        \ The following is workspace noise ???

 EQUB 0                 \ TP = Mission status, #0

 EQUB 20                \ QQ0 = Current system X-coordinate (Lave), #1
 EQUB 173               \ QQ1 = Current system Y-coordinate (Lave), #2

 EQUW &5A4A             \ ??? Workspace noise
 EQUD &B7530248

 EQUD &E8030000         \ CASH = Amount of cash (100 Cr), #3-6

 EQUB 70                \ QQ14 = Fuel level, #7

 EQUB 0                 \ COK = Competition flags, #8

 EQUB 0                 \ GCNT = Galaxy number, 0-7, #9

 EQUB POW               \ LASER = Front laser, #10

 EQUB 0                 \ LASER+1 = Rear laser, #11

 EQUB 0                 \ LASER+2 = Left laser, #12

 EQUB 0                 \ LASER+3 = Right laser, #13

 EQUW 0                 \ ??? Workspace noise

 EQUB 22                \ CRGO = Cargo capacity, #14

 SKIP 28                \ Placeholders for bytes #15 to #41

 EQUB 3                 \ NOMSL = Number of missiles, #42

 EQUB 0                 \ FIST = Legal status ("fugitive/innocent status"), #43

ELIF _SOURCE_DISK_BUILD OR _SOURCE_DISK_ELT_FILES OR _SOURCE_DISK_CODE_FILES

 SKIP 53                \ Placeholders for bytes #0 to #52

ENDIF

ENDIF

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

