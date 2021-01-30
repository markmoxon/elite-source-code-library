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

 JMP DOENTRY            \ Decrypt the main flight code and dock at the station

 JMP DOBEGIN            \ Decrypt the main flight code and start a new game

 JMP CHPR               \ WRCHV handler

 EQUW &114B             \ IRQ1V handler (points to IRQ1)

 EQUB &4C               \ A JMP instruction

.BRKV

 EQUW &11D5             \ BRKV handler (points to BRBR)

