\ ******************************************************************************
\
\       Name: DOENTRY
\       Type: Subroutine
\   Category: Loader
\    Summary: Load and run the docked code
\
\ ******************************************************************************

.DOENTRY

IF NOT(_ELITE_A_VERSION)

 LDA #'R'               \ Modify the command in LTLI from "L.T.CODE" to
 STA LTLI               \ "R.T.CODE" so it *RUNs the code rather than loading it

ELIF _ELITE_A_VERSION

 LDA #'R'               \ Modify the command in LTLI from "L.1.D" to "R.1.D" so
 STA LTLI               \ it *RUNs the code rather than loading it

ENDIF

                        \ Fall into DEATH2 to reset most variables and *RUN the
                        \ docked code

