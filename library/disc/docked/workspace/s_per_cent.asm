\ ******************************************************************************
\
\       Name: S%
\       Type: Workspace
\    Address: &11E3 to &11F0
\   Category: Workspaces
\    Summary: Entry points and vector addresses in the main docked code
\
\ ******************************************************************************

.S%

IF NOT(_ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA)

 JMP DOENTRY            \ Decrypt the main docked code and dock at the station

 JMP DOBEGIN            \ Decrypt the main docked code and start a new game

ELIF _ELITE_A_DOCKED

 JMP DOENTRY            \ Dock at the station

 JMP DOBEGIN            \ Start a new game

ELIF _ELITE_A_ENCYCLOPEDIA

 JMP DOENTRY            \ Initialise the encyclopedia and show the menu screen

 JMP DOENTRY            \ Initialise the encyclopedia and show the menu screen

ENDIF

IF NOT(_ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA)

 JMP CHPR               \ WRCHV is set to point here by elite-loader3.asm

 EQUW IRQ1              \ IRQ1V is set to point here by elite-loader3.asm

 JMP BRBR1              \ BRKV is set to point here by elite-loader3.asm

 BRKV = P% - 2          \ The address of the destination address in the above
                        \ JMP BRBR1 instruction. This ensures that any code that
                        \ updates BRKV will update this instruction instead of
                        \ the actual vector

ELIF _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA

 JMP CHPR               \ WRCHV is set to point here by elite-loader.asm

 EQUW IRQ1              \ IRQ1V is set to point here by elite-loader.asm

 JMP BRBR               \ BRKV is set to point here by elite-loader.asm

 BRKV = P% - 2          \ The address of the destination address in the above
                        \ JMP BRBR instruction. This ensures that any code that
                        \ updates BRKV will update this instruction instead of
                        \ the actual vector

ENDIF

 PRINT "S% workspace (docked) from ", ~S%, "to ", ~P%-1, "inclusive"

