\ ******************************************************************************
\
\       Name: TT69
\       Type: Subroutine
\   Category: Text
\    Summary: Set Sentence Case and print a newline
\
\ ******************************************************************************

.TT69

IF NOT(_ELITE_A_FLIGHT)

 LDA #%10000000         \ Set bit 7 of QQ17 to switch to Sentence Case
 STA QQ17

ELIF _ELITE_A_FLIGHT

 JSR vdu_80             \ Call vdu_80 to switch to Sentence Case

ENDIF

                        \ Fall through into TT67 to print a newline

