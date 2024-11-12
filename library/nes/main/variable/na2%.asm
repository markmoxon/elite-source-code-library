\ ******************************************************************************
\
\       Name: NA2%
\       Type: Variable
\   Category: Save and load
\    Summary: The data block for the default commander
\
\ ******************************************************************************

.NA2%

 EQUS "JAMESON"         \ The current commander name, which defaults to JAMESON

 EQUB 1                 \ SVC = Save count, which is stored in the terminator
                        \ byte for the commander name

 EQUB 0                 \ TP = Mission status, #0

 EQUB 20                \ QQ0 = Current system X-coordinate (Lave), #1
 EQUB 173               \ QQ1 = Current system Y-coordinate (Lave), #2

IF Q%
 EQUD &00CA9A3B         \ CASH = Amount of cash (100,000,000 Cr), #3-6
ELSE
 EQUD &E8030000         \ CASH = Amount of cash (100 Cr), #3-6
ENDIF

 EQUB 70                \ QQ14 = Fuel level, #7

 EQUB 0                 \ COK = Competition flags, #8

 EQUB 0                 \ GCNT = Galaxy number, 0-7, #9

IF Q%
 EQUB Armlas            \ LASER = Front laser, #10
ELSE
 EQUB POW+9             \ LASER = Front laser, #10
ENDIF

 EQUB (POW+9 AND Q%)    \ LASER+1 = Rear laser, #11

 EQUB (POW+128) AND Q%  \ LASER+2 = Left laser, #12

 EQUB Mlas AND Q%       \ LASER+3 = Right laser, #13

 EQUB 22 + (15 AND Q%)  \ CRGO = Cargo capacity, #14

 EQUB 0                 \ QQ20+0  = Amount of food in cargo hold, #15
 EQUB 0                 \ QQ20+1  = Amount of textiles in cargo hold, #16
 EQUB 0                 \ QQ20+2  = Amount of radioactives in cargo hold, #17
 EQUB 0                 \ QQ20+3  = Amount of slaves in cargo hold, #18
 EQUB 0                 \ QQ20+4  = Amount of liquor/Wines in cargo hold, #19
 EQUB 0                 \ QQ20+5  = Amount of luxuries in cargo hold, #20
 EQUB 0                 \ QQ20+6  = Amount of narcotics in cargo hold, #21
 EQUB 0                 \ QQ20+7  = Amount of computers in cargo hold, #22
 EQUB 0                 \ QQ20+8  = Amount of machinery in cargo hold, #23
 EQUB 0                 \ QQ20+9  = Amount of alloys in cargo hold, #24
 EQUB 0                 \ QQ20+10 = Amount of firearms in cargo hold, #25
 EQUB 0                 \ QQ20+11 = Amount of furs in cargo hold, #26
 EQUB 0                 \ QQ20+12 = Amount of minerals in cargo hold, #27
 EQUB 0                 \ QQ20+13 = Amount of gold in cargo hold, #28
 EQUB 0                 \ QQ20+14 = Amount of platinum in cargo hold, #29
 EQUB 0                 \ QQ20+15 = Amount of gem-stones in cargo hold, #30
 EQUB 0                 \ QQ20+16 = Amount of alien items in cargo hold, #31

 EQUB Q%                \ ECM = E.C.M. system, #32

 EQUB Q%                \ BST = Fuel scoops ("barrel status"), #33

 EQUB Q% AND 127        \ BOMB = Energy bomb, #34

 EQUB Q% AND 1          \ ENGY = Energy/shield level, #35

 EQUB Q%                \ DKCMP = Docking computer, #36

 EQUB Q%                \ GHYP = Galactic hyperdrive, #37

 EQUB Q%                \ ESCP = Escape pod, #38

 EQUW 0                 \ TRIBBLE = Number of Trumbles in the cargo hold, #39-40

 EQUB 0                 \ TALLYL = Combat rank fraction, #41

 EQUB 3 + (Q% AND 1)    \ NOMSL = Number of missiles, #42

 EQUB 0                 \ FIST = Legal status ("fugitive/innocent status"), #43

 EQUB 16                \ AVL+0  = Market availability of food, #44
 EQUB 15                \ AVL+1  = Market availability of textiles, #45
 EQUB 17                \ AVL+2  = Market availability of radioactives, #46
 EQUB 0                 \ AVL+3  = Market availability of slaves, #47
 EQUB 3                 \ AVL+4  = Market availability of liquor/Wines, #48
 EQUB 28                \ AVL+5  = Market availability of luxuries, #49
 EQUB 14                \ AVL+6  = Market availability of narcotics, #50
 EQUB 0                 \ AVL+7  = Market availability of computers, #51
 EQUB 0                 \ AVL+8  = Market availability of machinery, #52
 EQUB 10                \ AVL+9  = Market availability of alloys, #53
 EQUB 0                 \ AVL+10 = Market availability of firearms, #54
 EQUB 17                \ AVL+11 = Market availability of furs, #55
 EQUB 58                \ AVL+12 = Market availability of minerals, #56
 EQUB 7                 \ AVL+13 = Market availability of gold, #57
 EQUB 9                 \ AVL+14 = Market availability of platinum, #58
 EQUB 8                 \ AVL+15 = Market availability of gem-stones, #59
 EQUB 0                 \ AVL+16 = Market availability of alien items, #60

 EQUB 0                 \ QQ26 = Random byte that changes for each visit to a
                        \ system, for randomising market prices, #61

 EQUW 20000 AND Q%      \ TALLY = Number of kills, #62-63

 EQUB 128               \ This byte appears to be unused, #64

 EQUW &5A4A             \ QQ21 = Seed s0 for system 0, galaxy 0 (Tibedied), #65
 EQUW &0248             \ QQ21 = Seed s1 for system 0, galaxy 0 (Tibedied), #67
 EQUW &B753             \ QQ21 = Seed s2 for system 0, galaxy 0 (Tibedied), #69

 EQUB &AA               \ This byte appears to be unused, #71

 EQUB &27               \ This byte appears to be unused, #72

 EQUB &03               \ This byte appears to be unused, #73

 EQUD 0                 \ These bytes appear to be unused, #74-#85
 EQUD 0
 EQUD 0
 EQUD 0

