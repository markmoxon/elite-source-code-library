\ ******************************************************************************
\
\       Name: INBAY
\       Type: Subroutine
\   Category: Loader
\    Summary: Load and run the main docked code in T.CODE
\
\ ******************************************************************************

.INBAY

 LDX #LO(LTLI)          \ Set (Y X) to point to LTLI ("L.T.CODE", which gets
 LDY #HI(LTLI)          \ modified to "R.T.CODE" in the DOENTRY routine)

 JSR OSCLI              \ Call OSCLI to run the OS command in LTLI, which *RUNs
                        \ the main docked code in T.CODE

