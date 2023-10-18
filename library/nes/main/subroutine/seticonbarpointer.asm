\ ******************************************************************************
\
\       Name: SetIconBarPointer
\       Type: Subroutine
\   Category: Icon bar
\    Summary: Set the icon bar pointer to a specific position
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The button number on which to position the pointer
\
\ ******************************************************************************

.SetIconBarPointer

 ASL A                  \ Set xIconBarPointer =  A * 4
 ASL A                  \
 STA xIconBarPointer    \ As xIconBarPointer contains the x-coordinate of the
                        \ icon bar pointer, incrementing by 4 for each button

 LDX #0                 \ Zero all the pointer timer and movement variables so
 STX pointerMoveCounter \ the pointer is not moving and the MoveIconBarPointer
 STX xPointerDelta      \ routine does not start looking for double-taps of
 STX pointerPressedB    \ the B button
 STX pointerTimer

IF _PAL

 STX pointerTimerB      \ Reset the PAL-specific timer that controls whether a
                        \ tap on the B button is the second tap of a double-tap

ENDIF

 RTS                    \ Return from the subroutine

