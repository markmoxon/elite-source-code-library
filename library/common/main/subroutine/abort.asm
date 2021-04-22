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

 LDX #&FF               \ Set X to &FF, which is the value of MSTG when we have
                        \ no target lock for our missile

                        \ Fall through into ABORT2 to set the missile lock to
                        \ the value in X, which effectively disarms the missile

