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

 JMP CHPR               \ WRCHV is set to point here by elite-loader3.asm

 EQUW IRQ1              \ IRQ1V is set to point here by elite-loader3.asm

 JMP BRBR1              \ BRKV is set to point here by elite-loader3.asm

BRKV = P% - 2           \ The address of the destination address in the above
                        \ JMP BRBR1 instruction. This ensures that any code that
                        \ updates BRKV will update this instruction instead of
                        \ the actual vector

