\ ******************************************************************************
\
\       Name: S%
\       Type: Workspace
\    Address: &11E3 to &11F0
\   Category: Workspaces
\    Summary: Entry points and vector addresses in the main docked code
\  Deep dive: Swapping between the docked and flight code
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

 JMP CHPR               \ WRCHV is set to point here by elite-loader3.asm, so
                        \ CHPR is set as the character write routine

 EQUW IRQ1              \ IRQ1V is set to the address in these two bytes by
                        \ elite-loader3.asm, so IRQ1V points to IRQ1

 JMP BRBR1              \ BRKV is set to point here by elite-loader3.asm, so
                        \ BRBR1 is set as the break handler

 BRKV = P% - 2          \ The address of the destination address in the above
                        \ JMP BRBR1 instruction. This ensures that any code that
                        \ updates BRKV will update this instruction instead of
                        \ the actual vector

ELIF _ELITE_A_DOCKED OR _ELITE_A_ENCYCLOPEDIA

 JMP CHPR               \ WRCHV is set to point here by elite-loader3.asm, so
                        \ CHPR is set as the character write routine

 EQUW IRQ1              \ IRQ1V is set to the address in these two bytes by
                        \ elite-loader.asm, so IRQ1V points to IRQ1

 JMP BRBR               \ BRKV is set to point here by elite-loader.asm, so
                        \ BRBR is set as the break handler

 BRKV = P% - 2          \ The address of the destination address in the above
                        \ JMP BRBR instruction. This ensures that any code that
                        \ updates BRKV will update this instruction instead of
                        \ the actual vector

ENDIF

 PRINT "S% workspace (docked) from ", ~S%, "to ", ~P%-1, "inclusive"

