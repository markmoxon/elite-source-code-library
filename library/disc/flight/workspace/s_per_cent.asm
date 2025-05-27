\ ******************************************************************************
\
\       Name: S%
\       Type: Workspace
\    Address: &11E3 to &11F0
\   Category: Workspaces
\    Summary: Entry points and vector addresses in the main flight code
\  Deep dive: Swapping between the docked and flight code
\
\ ******************************************************************************

.S%

IF NOT(_ELITE_A_FLIGHT)

 JMP DEEOR              \ Decrypt the main flight code and join the main loop

 JMP DEEOR              \ Decrypt the main flight code and start a new game

 JMP TT26               \ WRCHV is set to point here by elite-loader.asm, so
                        \ TT26 is set as the character write routine

 EQUW IRQ1              \ IRQ1V is set to the address in these two bytes by
                        \ elite-loader3.asm, so IRQ1V points to IRQ1

 JMP BRBR1              \ BRKV is set to point here by elite-loader3.asm, so
                        \ BRBR1 is set as the break handler

ELIF _ELITE_A_FLIGHT

 JMP RSHIPS             \ Load a new set of ship blueprints, set the space view
                        \ and jump into the main game loop

 JMP RSHIPS             \ Load a new set of ship blueprints, set the space view
                        \ and jump into the main game loop

 JMP TT26               \ WRCHV is set to point here by elite-loader.asm, so
                        \ TT26 is set as the character write routine

 EQUW IRQ1              \ IRQ1V is set to the address in these two bytes by
                        \ elite-loader.asm, so IRQ1V points to IRQ1

 JMP BRBR1              \ BRKV is set to point here by elite-loader.asm, so
                        \ BRBR1 is set as the break handler

ENDIF

 PRINT "S% workspace (flight) from ", ~S%, "to ", ~P%-1, "inclusive"

