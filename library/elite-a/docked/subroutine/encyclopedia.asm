\ ******************************************************************************
\
\       Name: encyclopedia
\       Type: Subroutine
\   Category: Loader
\    Summary: Load and run the encyclopedia code in 1.E
\
\ ******************************************************************************

.encyclopedia

 LDA #'E'               \ Set the fifth byte of RDLI in EDLI+4 to "E", so it
 STA RDLI+4             \ changes the command to "R.1.E", and fall through into
                        \ TT110 to execute the command, which will load and run
                        \ the encyclopedia code in 1.E

