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

 JMP scramble           \ Decrypt the main flight code and join the main game
                        \ loop

 JMP scramble           \ Decrypt the main flight code and start a new game

 JMP TT26               \ WRCHV handler

 EQUW &114B             \ IRQ1 handler

 JMP &11D5              \ BRBR handler

