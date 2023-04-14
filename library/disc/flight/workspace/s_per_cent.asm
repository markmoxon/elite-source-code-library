\ ******************************************************************************
\
\       Name: S%
\       Type: Workspace
\    Address: &11E3 to &11F0
\   Category: Workspaces
\    Summary: Entry points and vector addresses in the main flight code
\
\ ******************************************************************************

.S%

IF NOT(_ELITE_A_FLIGHT)

 JMP DEEOR              \ Decrypt the main flight code and join the main loop

 JMP DEEOR              \ Decrypt the main flight code and start a new game

 JMP TT26               \ WRCHV is set to point here by elite-loader3.asm

 EQUW IRQ1              \ IRQ1V is set to point here by elite-loader3.asm

 JMP BRBR1              \ BRKV is set to point here by elite-loader3.asm

ELIF _ELITE_A_FLIGHT

 JMP RSHIPS             \ Load a new set of ship blueprints, set the space view
                        \ and jump into the main game loop

 JMP RSHIPS             \ Load a new set of ship blueprints, set the space view
                        \ and jump into the main game loop

 JMP TT26               \ WRCHV is set to point here by elite-loader.asm

 EQUW IRQ1              \ IRQ1V is set to point here by elite-loader.asm

 JMP BRBR1              \ BRKV is set to point here by elite-loader.asm

ENDIF

