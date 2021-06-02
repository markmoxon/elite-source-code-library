\ ******************************************************************************
\
\       Name: S%
\       Type: Workspace
\    Address: &11E3 to &11F0
\   Category: Workspaces
\    Summary: Entry points and vector addresses in the main encyclopedia code
\
\ ******************************************************************************

.S%

 JMP DOENTRY            \ AJD

 JMP DOENTRY

 JMP CHPR

 EQUW IRQ1

 JMP BRBR

BRKV = P% - 2

