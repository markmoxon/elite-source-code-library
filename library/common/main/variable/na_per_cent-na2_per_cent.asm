\ ******************************************************************************
\
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Comment
\       Name: NA%
ELIF _MASTER_VERSION
\       Name: NA2%
ENDIF
\       Type: Variable
\   Category: Save and load
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Comment
\    Summary: The data block for the last saved commander
ELIF _MASTER_VERSION
\    Summary: The data block for the default commander
ENDIF
\  Deep dive: Commander save files
\             The competition code
\
\ ------------------------------------------------------------------------------
\
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Comment
\ Contains the last saved commander data, with the name at NA% and the data at
ELIF _MASTER_VERSION
\ Contains the default commander data, with the name at NA% and the data at
ENDIF
\ NA%+8 onwards. The size of the data block is given in NT% (which also includes
\ the two checksum bytes that follow this block). This block is initially set up
\ with the default commander, which can be maxed out for testing purposes by
\ setting Q% to TRUE.
\
\ The commander's name is stored at NA%, and can be up to 7 characters long
\ (the DFS filename limit). It is terminated with a carriage return character,
\ ASCII 13.
\
\ The offset of each byte within a saved commander file is also shown as #0, #1
\ and so on, so the kill tally, for example, is in bytes #71 and #72 of the
\ saved file. The related variable name from the current commander block is
\ also shown.
\
\ ******************************************************************************

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Master: Group A: The Master version contains an embedded copy of the default JAMESON commander file that can be restored over the current commander via the disc access menu

.NA%

ELIF _MASTER_VERSION

 EQUS ":0.E."

.NA2%

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _MASTER_VERSION \ 6502SP: The Executive version contains a maxed-out default commander, with a different name: Firebud instead of Jameson (the name is presumably a seven-character riff on "Firebird", the publishers of the non-Acorn versions of Elite)

 EQUS "JAMESON"         \ The current commander name, which defaults to JAMESON
 EQUB 13                \
                        \ The commander name can be up to 7 characters (the DFS
                        \ limit for filenames), and is terminated by a carriage
                        \ return

ELIF _6502SP_VERSION

IF _SNG45 OR _SOURCE_DISC

 EQUS "JAMESON"         \ The current commander name, which defaults to JAMESON
 EQUB 13                \
                        \ The commander name can be up to seven characters (the
                        \ DFS limit for filenames), and is terminated by a
                        \ carriage return

ELIF _EXECUTIVE

 EQUS "FIREBUD"         \ The current commander name, which defaults to FIREBUD
 EQUB 13                \ in the Executive version (this version comes with a
                        \ maxed-out commander by default, so it gets a different
                        \ name, which is presumably a seven-character riff on
                        \ "Firebird", the publishers of the non-Acorn versions
                        \ of Elite)
                        \
                        \ The commander name can be up to seven characters (the
                        \ DFS limit for filenames), and is terminated by a
                        \ carriage return

ENDIF

ELIF _ELITE_A_VERSION

 EQUS "NEWCOME"         \ The current commander name, which defaults to NEWCOME
 EQUB 13                \
                        \ The commander name can be up to 7 characters (the DFS
                        \ limit for filenames), and is terminated by a carriage
                        \ return

ENDIF

                        \ NA%+8 is the start of the commander data block
                        \
                        \ This block contains the last saved commander data
                        \ block. As the game is played it uses an identical
                        \ block at location TP to store the current commander
                        \ state, and that block is copied here when the game is
                        \ saved. Conversely, when the game starts up, the block
                        \ here is copied to TP, which restores the last saved
                        \ commander when we die
                        \
                        \ The initial state of this block defines the default
                        \ commander. Q% can be set to TRUE to give the default
                        \ commander lots of credits and equipment

 EQUB 0                 \ TP = Mission status, #0

 EQUB 20                \ QQ0 = Current system X-coordinate (Lave), #1
 EQUB 173               \ QQ1 = Current system Y-coordinate (Lave), #2

 EQUW &5A4A             \ QQ21 = Seed s0 for system 0, galaxy 0 (Tibedied), #3-4
 EQUW &0248             \ QQ21 = Seed s1 for system 0, galaxy 0 (Tibedied), #5-6
 EQUW &B753             \ QQ21 = Seed s2 for system 0, galaxy 0 (Tibedied), #7-8

IF NOT(_ELITE_A_VERSION)

IF Q%
 EQUD &00CA9A3B         \ CASH = Amount of cash (100,000,000 Cr), #9-12
ELSE
 EQUD &E8030000         \ CASH = Amount of cash (100 Cr), #9-12
ENDIF

 EQUB 70                \ QQ14 = Fuel level, #13

ELIF _ELITE_A_VERSION

IF Q%
 EQUD &00CA9A3B         \ CASH = Amount of cash (100,000,000 Cr), #9-12
ELSE
 EQUD &88130000         \ CASH = Amount of cash (500 Cr), #9-12
ENDIF

 EQUB 60 + (15 AND Q%)  \ QQ14 = Fuel level, #13

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION \ 6502SP: The Executive version has bit 7 of the COK competition flags set, to indicate that this commander file has been tampered with (which it has, of course)

 EQUB 0                 \ COK = Competition flags, #14

ELIF _MASTER_VERSION

 EQUB %10000000 AND Q%  \ COK = Competition flags, #14

ELIF _6502SP_VERSION

IF _SNG45 OR _SOURCE_DISC

 EQUB 0                 \ COK = Competition flags, #14

ELIF _EXECUTIVE

 EQUB %10000000         \ COK = Competition flags, #14

ENDIF

ENDIF

 EQUB 0                 \ GCNT = Galaxy number, 0-7, #15

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _6502SP_VERSION \ Master: See group A

 EQUB POW+(128 AND Q%)  \ LASER = Front laser, #16

 EQUB (POW+128) AND Q%  \ LASER+1 = Rear laser, #17

 EQUB 0                 \ LASER+2 = Left laser, #18

 EQUB 0                 \ LASER+3 = Right laser, #19

ELIF _MASTER_VERSION

IF Q%
 EQUB Armlas            \ LASER = Front laser, #16
ELSE
 EQUB POW               \ LASER = Front laser, #16
ENDIF

 EQUB POW AND Q%        \ LASER = Rear laser, #16

 EQUB (POW+128) AND Q%  \ LASER+2 = Left laser, #18

 EQUB Mlas AND Q%       \ LASER+3 = Right laser, #19

ELIF _ELITE_A_VERSION

 EQUB &9C AND Q%        \ LASER = Front laser, #16

 EQUB &9C AND Q%        \ LASER+1 = Rear laser, #17

 EQUB 0                 \ LASER+2 = Left laser, #18

 EQUB 0                 \ LASER+3 = Right laser, #19

ENDIF

IF NOT(_ELITE_A_VERSION)

 EQUW 0                 \ These bytes appear to be unused (they were originally
                        \ used for up/down lasers, but they were dropped),
                        \ #20-21

 EQUB 22 + (15 AND Q%)  \ CRGO = Cargo capacity, #22

ELIF _ELITE_A_VERSION

 EQUB 0                 \ This byte appears to be unused, #20

 EQUB 8 AND Q%          \ cmdr_type = Type of our current ship, #21

 EQUB Q%                \ CRGO = I.F.F. system, #22

ENDIF

 EQUB 0                 \ QQ20+0  = Amount of food in cargo hold, #23
 EQUB 0                 \ QQ20+1  = Amount of textiles in cargo hold, #24
 EQUB 0                 \ QQ20+2  = Amount of radioactives in cargo hold, #25
 EQUB 0                 \ QQ20+3  = Amount of slaves in cargo hold, #26
 EQUB 0                 \ QQ20+4  = Amount of liquor/Wines in cargo hold, #27
 EQUB 0                 \ QQ20+5  = Amount of luxuries in cargo hold, #28
 EQUB 0                 \ QQ20+6  = Amount of narcotics in cargo hold, #29
 EQUB 0                 \ QQ20+7  = Amount of computers in cargo hold, #30
 EQUB 0                 \ QQ20+8  = Amount of machinery in cargo hold, #31
 EQUB 0                 \ QQ20+9  = Amount of alloys in cargo hold, #32
 EQUB 0                 \ QQ20+10 = Amount of firearms in cargo hold, #33
 EQUB 0                 \ QQ20+11 = Amount of furs in cargo hold, #34
 EQUB 0                 \ QQ20+12 = Amount of minerals in cargo hold, #35
 EQUB 0                 \ QQ20+13 = Amount of gold in cargo hold, #36
 EQUB 0                 \ QQ20+14 = Amount of platinum in cargo hold, #37
 EQUB 0                 \ QQ20+15 = Amount of gem-stones in cargo hold, #38
 EQUB 0                 \ QQ20+16 = Amount of alien items in cargo hold, #39

 EQUB Q%                \ ECM = E.C.M. system, #40

 EQUB Q%                \ BST = Fuel scoops ("barrel status"), #41

IF NOT(_ELITE_A_VERSION)

 EQUB Q% AND 127        \ BOMB = Energy bomb, #42

ELIF _ELITE_A_VERSION

 EQUB Q%                \ BOMB = Hyperspace unit, #42

ENDIF

 EQUB Q% AND 1          \ ENGY = Energy/shield level, #43

 EQUB Q%                \ DKCMP = Docking computer, #44

 EQUB Q%                \ GHYP = Galactic hyperdrive, #45

 EQUB Q%                \ ESCP = Escape pod, #46

IF NOT(_ELITE_A_VERSION)

 EQUD 0                 \ These four bytes appear to be unused, #47-50

ELIF _ELITE_A_VERSION

 EQUW 0                 \ cmdr_cour = Special cargo mission timer, #47

 EQUB 0                 \ cmdr_courx = Special cargo destination x-coord, #49

 EQUB 0                 \ cmdr_coury = Special cargo destination y-coord, #50

ENDIF

IF NOT(_ELITE_A_VERSION)

 EQUB 3 + (Q% AND 1)    \ NOMSL = Number of missiles, #51

ELIF _ELITE_A_VERSION

 EQUB 0                 \ NOMSL = Number of missiles, #51

ENDIF

 EQUB 0                 \ FIST = Legal status ("fugitive/innocent status"), #52

IF NOT(_ELITE_A_VERSION)

 EQUB 16                \ AVL+0  = Market availability of food, #53
ELIF _ELITE_A_VERSION

 EQUB 0                 \ AVL+0  = Market availability of food, #53
ENDIF
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

 EQUB 0                 \ QQ26 = Random byte that changes for each visit to a
                        \ system, for randomising market prices, #70

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Master: See group A

 EQUW 0                 \ TALLY = Number of kills, #71-72


ELIF _MASTER_VERSION

 EQUW 20000 AND Q%      \ TALLY = Number of kills, #71-72

ENDIF

IF NOT(_ELITE_A_VERSION)

 EQUB 128               \ SVC = Save count, #73

ELIF _ELITE_A_VERSION

 EQUB 32                \ SVC = Save count, #73

ENDIF

IF _MASTER_VERSION \ Master: See group A

\.CHK2                  \ This label is commented out in the original source

 EQUB &AA               \ The CHK2 checksum value for the default commander

\.CHK                   \ This label is commented out in the original source

 EQUB &03               \ The CHK checksum value for the default commander

\.CHK3                  \ These instructions are commented out in the original
\EQUB CH3X%             \ source

 SKIP 12                \ These bytes appear to be unused, though the first byte
                        \ in this block is included in the commander file (it
                        \ has no effect, as it's the third checksum byte from
                        \ the Commodore 64 version, which isn't used in the
                        \ Master version)

.NAEND%

 SKIP 4                 \ These bytes appear to be unused

ENDIF

