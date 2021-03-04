\ ******************************************************************************
\
\       Name: ZES1
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Zero-fill the page whose number is in X
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The page we want to zero-fill
\
\ ******************************************************************************

.ZES1

IF _CASSETTE_VERSION OR _6502SP_VERSION OR _DISC_DOCKED \ Platform: Changes required because the flight version of ZES2 is different, but the function of this routine doesn't change

 LDY #0                 \ If we set Y = SC = 0 and fall through into ZES2
 STY SC                 \ below, then we will zero-fill 255 bytes starting from
                        \ SC - in other words, we will zero-fill the whole of
                        \ page X

ELIF _DISC_FLIGHT

 STX SC+1               \ We want to zero-fill page X, so store this in the
                        \ high byte of SC, so SC(1 0) is now pointing to page X

 LDA #0                 \ If we set Y = SC = 0 and fall through into ZES2
 STA SC                 \ below, then we will zero-fill 255 bytes starting from
 TAY                    \ SC, then SC + 255, and then the rest of the page - in
                        \ other words, we will zero-fill the whole of page X

ENDIF

