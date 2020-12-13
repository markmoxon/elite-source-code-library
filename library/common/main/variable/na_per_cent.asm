\ ******************************************************************************
\
\       Name: NA%
\       Type: Variable
\   Category: Save and load
\    Summary: The data block for the last saved commander
\
\ ------------------------------------------------------------------------------
\
\ Contains the last saved commander data, with the name at NA% and the data at
\ NA%+8 onwards. The size of the data block is given in NT% (which also includes
\ the two checksum bytes that follow this block. This block is initially set up
\ with the default commander, which can be maxed out for testing purposes by
\ setting Q% to TRUE.
\
\ The commander's name is stored at NA%, and can be up to 7 characters long
\ (the DFS filename limit). It is terminated with a carriage return character,
\ ASCII 13.
\
\ ******************************************************************************

.NA%

 EQUS "JAMESON"         \ The current commander name, which defaults to JAMESON
 EQUB 13                \
                        \ The commander name can be up to 7 characters (the DFS
                        \ limit for file names), and is terminated by a carriage
                        \ return

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

 EQUB 0                 \ TP = Mission status
                        \
                        \ Note that this byte must not have bit 7 set, or
IF _CASSETTE_VERSION
                        \ loading this commander will cause the game to restart
ELIF _6502SP_VERSION
                        \ loading this commander will give an error
ENDIF

 EQUB 20                \ QQ0 = current system X-coordinate (Lave)
 EQUB 173               \ QQ1 = current system Y-coordinate (Lave)

 EQUW &5A4A             \ QQ21 = Seed w0 for system 0 in galaxy 0 (Tibedied)
 EQUW &0248             \ QQ21 = Seed w1 for system 0 in galaxy 0 (Tibedied)
 EQUW &B753             \ QQ21 = Seed w2 for system 0 in galaxy 0 (Tibedied)

IF Q%
 EQUD &00CA9A3B         \ CASH = Amount of cash (100,000,000 Cr)
ELSE
 EQUD &E8030000         \ CASH = Amount of cash (100 Cr)
ENDIF

 EQUB 70                \ QQ14 = Fuel level

 EQUB 0                 \ COK = Competition flags

 EQUB 0                 \ GCNT = Galaxy number, 0-7

 EQUB POW+(128 AND Q%)  \ LASER = Front laser

 EQUB (POW+128) AND Q%  \ LASER+1 = Rear laser, as in ELITEB source

 EQUB 0                 \ LASER+2 = Left laser

 EQUB 0                 \ LASER+3 = Right laser

 EQUW 0                 \ These bytes are unused (they were originally used for
                        \ up/down lasers, but they were dropped)

 EQUB 22+(15 AND Q%)    \ CRGO = Cargo capacity

 EQUD 0                 \ QQ20 = Contents of cargo hold (17 bytes)
 EQUD 0
 EQUD 0
 EQUD 0
 EQUB 0

 EQUB Q%                \ ECM = E.C.M.

 EQUB Q%                \ BST = Fuel scoops ("barrel status")

 EQUB Q% AND 127        \ BOMB = Energy bomb

 EQUB Q% AND 1          \ ENGY = Energy/shield level

 EQUB Q%                \ DKCMP = Docking computer

 EQUB Q%                \ GHYP = Galactic hyperdrive

 EQUB Q%                \ ESCP = Escape pod

 EQUD FALSE             \ These four bytes are unused

 EQUB 3+(Q% AND 1)      \ NOMSL = Number of missiles

 EQUB FALSE             \ FIST = Legal status ("fugitive/innocent status")

 EQUB 16                \ AVL = Market availability (17 bytes)
 EQUB 15
 EQUB 17
 EQUB 0
 EQUB 3
 EQUB 28
 EQUB 14
 EQUB 0
 EQUB 0
 EQUB 10
 EQUB 0
 EQUB 17
 EQUB 58
 EQUB 7
 EQUB 9
 EQUB 8
 EQUB 0

 EQUB 0                 \ QQ26 = Random byte that changes for each visit to a
                        \ system, for randomising market prices

 EQUW 0                 \ TALLY = Number of kills

 EQUB 128               \ SVC = Save count

