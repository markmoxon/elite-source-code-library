\ ******************************************************************************
\
\       Name: ABORT
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Disarm missiles and update the dashboard indicators
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   Y                   The new status of the leftmost missile indicator
\
IF _ELECTRON_VERSION \ Comment
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   ABORT-2             Set the indicator to disarmed (white square)
\
ENDIF
\ ******************************************************************************

IF _ELECTRON_VERSION \ Platform

 LDY #&09               \ Set Y = &09 so we set the missile to a white square
                        \ (disarmed)

ENDIF

.ABORT

IF NOT(_NES_VERSION)

 LDX #&FF               \ Set X to &FF, which is the value of MSTG when we have
                        \ no target lock for our missile

ELIF _NES_VERSION

 LDX #0                 \ Set MSAR = 0 to indicate that the leftmost missile
 STX MSAR               \ is no longer seeking a target lock

 DEX                    \ Set X to &FF, which is the value of MSTG when we have
                        \ no target lock for our missile

ENDIF

                        \ Fall through into ABORT2 to set the missile lock to
                        \ the value in X, which effectively disarms the missile

