\ ******************************************************************************
\
\       Name: TT69
\       Type: Subroutine
\   Category: Text
\    Summary: Set Sentence Case and print a newline
\
\ ******************************************************************************

.TT69

IF _ELITE_A_FLIGHT

 JSR vdu_80             \ AJD

ELIF NOT(_ELITE_A_FLIGHT)

 LDA #%10000000         \ Set bit 7 of QQ17 to switch to Sentence Case
 STA QQ17

ENDIF

                        \ Fall through into TT67 to print a newline

