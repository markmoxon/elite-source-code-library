\ ******************************************************************************
\
\       Name: DOENTRY
\       Type: Subroutine
\   Category: Loader
\    Summary: Load and run the docked code
\
\ ******************************************************************************

.DOENTRY

 LDA #'R'               \ Modify the command in LTLI from "L.T.CODE" to
 STA LTLI               \ "R.T.CODE" so it *RUNs the code rather than loading it

                        \ Fall into DEATH2 to reset most variables and *RUN the
                        \ docked code

