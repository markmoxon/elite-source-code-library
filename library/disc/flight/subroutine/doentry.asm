\ ******************************************************************************
\
\       Name: DOENTRY
\       Type: Subroutine
\   Category: Loader
\    Summary: Load and run the docked code
\  Deep dive: Swapping between the docked and flight code
\
\ ******************************************************************************

.DOENTRY

IF NOT(_ELITE_A_VERSION)

 LDA #'R'               \ Modify the command in LTLI from "L.T.CODE" to
 STA LTLI               \ "R.T.CODE" so it *RUNs the code rather than loading it
                        \
                        \ This ensures that when we load the docked code, then
                        \ instead of continuing execution following a *LOAD,
                        \ which would restart the game by falling through into
                        \ the DOBEGIN routine in the docked code, we instead
                        \ jump to the start of the docked code at S%, which
                        \ jumps to the docked DOENTRY routine to dock with the
                        \ space station

ELIF _ELITE_A_VERSION

 LDA #'R'               \ Modify the command in LTLI from "L.1.D" to "R.1.D" so
 STA LTLI               \ it *RUNs the code rather than loading it
                        \
                        \ This ensures that when we load the docked code, then
                        \ instead of continuing execution following a *LOAD,
                        \ which would restart the game by falling through into
                        \ the DOBEGIN routine in the docked code, we instead
                        \ jump to the start of the docked code at S%, which
                        \ jumps to the docked DOENTRY routine to dock with the
                        \ space station

ENDIF

                        \ Fall into DEATH2 to reset most variables and *RUN the
                        \ docked code

