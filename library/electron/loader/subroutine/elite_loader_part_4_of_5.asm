\ ******************************************************************************
\
\       Name: Elite loader (Part 4 of 5)
\       Type: Subroutine
\   Category: Loader
\    Summary: Call part 5 of the loader now that is has been relocated
\
\ ------------------------------------------------------------------------------
\
\ In the protected version of the loader, this part copies more code onto the
\ stack and decrypts a chunk of loader code before calling part 5, but in the
\ unprotected version it's mostly NOPs.
\
\ ******************************************************************************

 JMP &0B11              \ Call relocated UU% routine to load the main game code
                        \ at &2000, move it down to &0D00 and run it

 NOP                    \ This part of the loader has been disabled by the
 NOP                    \ crackers, as this is an unprotected version
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP

.RAND

 EQUD &6C785349         \ The random number seed used for drawing Saturn

 NOP                    \ This part of the loader has been disabled by the
 NOP                    \ crackers, as this is an unprotected version
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP
 NOP

