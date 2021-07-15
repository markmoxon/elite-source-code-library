\ ******************************************************************************
\
\       Name: stay_here
\       Type: Subroutine
\   Category: Market
\    Summary: Pay a docking fee and refresh the system's market prices
\
\ ******************************************************************************

.stay_here

 LDX #&F4               \ It costs 50.0 Cr to refresh the station's market
 LDY #&01               \ prices, which is represented as a value of 500, so
                        \ this sets (Y X) = &1F4 = 500

 JSR LCASH              \ Subtract (Y X) cash from the cash pot, but only if
                        \ we have enough cash

 BCC stay_quit          \ If the C flag is clear then we did not have enough
                        \ cash for the transaction, so jump to stay_quit to
                        \ return from the subroutine without refreshing the
                        \ market prices

 JSR cour_dock          \ Update the current special cargo delivery mission

IF _ELITE_A_6502SP_PARA

 JSR DORND              \ Set A and X to random numbers

 STA QQ26               \ Set QQ26 to the random byte that's used in the market
                        \ calculations

 JSR GVL                \ AJD

.stay_quit

 JMP BAY                \ Go to the docking bay (i.e. show the Status Mode
                        \ screen)

ENDIF

