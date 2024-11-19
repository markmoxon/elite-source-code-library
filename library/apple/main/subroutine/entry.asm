\ ******************************************************************************
\
\       Name: ENTRY
\       Type: Subroutine
\   Category: Loader
\    Summary: An entry point at the start of the game binary
\
\ ******************************************************************************

 JMP S%                 \ Jump to S% to decrypt and run the game
                        \
                        \ This instruction would be used to start the game if
                        \ the game binary was loaded with a BRUN command with no
                        \ execution address, which is not the case here, so
                        \ perhaps it is left over from development

