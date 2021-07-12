\ ******************************************************************************
\
\       Name: INBAY
\       Type: Subroutine
\   Category: Loader
IF NOT(_ELITE_A_VERSION)
\    Summary: Load and run the main docked code in T.CODE
ELIF _ELITE_A_VERSION
\    Summary: Load and run the main docked code in 1.D
ENDIF
\
\ ******************************************************************************

.INBAY

IF NOT(_ELITE_A_VERSION)

 LDX #LO(LTLI)          \ Set (Y X) to point to LTLI ("L.T.CODE", which gets
 LDY #HI(LTLI)          \ modified to "R.T.CODE" in the DOENTRY routine)

 JSR OSCLI              \ Call OSCLI to run the OS command in LTLI, which *RUNs
                        \ the main docked code in T.CODE

ELIF _ELITE_A_FLIGHT

 LDX #LO(LTLI)          \ Set (Y X) to point to LTLI ("L.1.D", which gets
 LDY #HI(LTLI)          \ modified to "R.1.D" in the DOENTRY routine)

 JSR OSCLI              \ Call OSCLI to run the OS command in LTLI, which *RUNs
                        \ the main docked code in 1.D

ELIF _ELITE_A_ENCYCLOPEDIA

 LDX #LO(LTLI)          \ Set (Y X) to point to LTLI ("L.1.D", which gets
 LDY #HI(LTLI)          \ modified to "R.1.D" in the launch routine)

 JSR OSCLI              \ Call OSCLI to run the OS command in LTLI, which *RUNs
                        \ the main docked code in 1.D

ENDIF