\ ******************************************************************************
\
\       Name: BR1 (Part 2 of 2)
\       Type: Subroutine
\   Category: Start and end
\    Summary: Show the "Load New Commander (Y/N)?" screen and start the game
\
\ ------------------------------------------------------------------------------
\
\ BRKV is set to point to BR1 by elite-loader.asm.
\
\ ******************************************************************************

 JSR msblob             \ Reset the dashboard's missile indicators so none of
                        \ them are targeted

IF _CASSETTE_VERSION \ Feature

 LDA #147               \ Call TITLE to show a rotating Mamba (#3) and token
 LDX #3                 \ 147 ("PRESS FIRE OR SPACE,COMMANDER.{crlf}{crlf}"),
 JSR TITLE              \ returning with the internal number of the key pressed
                        \ in A

ELIF _DISC_VERSION

 LDA #7                 \ Call TITLE to show a rotating Krait (#KRA) and token
 LDX #KRA               \ 7 ("LOAD NEW {single cap}COMMANDER {all caps}(Y/N)?
 JSR TITLE              \ {sentence case}{cr}{cr}""), returning with the
                        \ internal number of the key pressed in A

ENDIF

 JSR ping               \ Set the target system coordinates (QQ9, QQ10) to the
                        \ current system coordinates (QQ0, QQ1) we just loaded

 JSR hyp1               \ Arrive in the system closest to (QQ9, QQ10) and then
                        \ and then fall through into the docking bay routine
                        \ below

