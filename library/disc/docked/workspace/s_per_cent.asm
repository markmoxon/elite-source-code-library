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

 JMP DOENTRY            \ Decrypt the main docked code and dock at the station

IF NOT(_ELITE_A_ENCYCLOPEDIA)

 JMP DOBEGIN            \ Decrypt the main docked code and start a new game

ELIF _ELITE_A_ENCYCLOPEDIA

 JMP DOENTRY            \ Decrypt the main docked code and dock at the station

ENDIF

 JMP CHPR               \ WRCHV is set to point here by elite-loader3.asm

 EQUW IRQ1              \ IRQ1V is set to point here by elite-loader3.asm

IF NOT(_ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA)

 JMP BRBR1              \ BRKV is set to point here by elite-loader3.asm

ELIF _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA

 JMP BRBR               \ AJD

ENDIF

BRKV = P% - 2           \ The address of the destination address in the above
                        \ JMP BRBR1 instruction. This ensures that any code that
                        \ updates BRKV will update this instruction instead of
                        \ the actual vector

