\ ******************************************************************************
\
\       Name: BRIS
\       Type: Subroutine
\   Category: Missions
\    Summary: Clear the screen, display "INCOMING MESSAGE" and wait for 2
\             seconds
\
\ ******************************************************************************

.BRIS

 LDA #216               \ Print extended token 216 ("{clear screen}{tab 6}{move
 JSR DETOK              \ to row 10, white, lower case}{white}{all caps}INCOMING
                        \ MESSAGE"

IF _NES_VERSION

 JSR UpdateViewWithFade \ Update the view, fading the screen to black first if
                        \ required

ENDIF

IF NOT(_C64_VERSION OR _APPLE_VERSION)

 LDY #100               \ Wait for 100/50 of a second (2 seconds) and return
 JMP DELAY              \ from the subroutine using a tail call

ELIF _C64_VERSION

 LDY #100               \ Wait for 100/50 of a second (2 seconds) on PAL
 JMP DELAY              \ systems, or 100/60 of a second (1.67 seconds) on NTSC,
                        \ and return from the subroutine using a tail call

ELIF _APPLE_VERSION

 LDY #100               \ Wait for 100 delay loops and return from the
 JMP DELAY              \ subroutine using a tail call

ENDIF

