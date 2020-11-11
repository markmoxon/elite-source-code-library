\ ******************************************************************************
\
\       Name: ABORT
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Disarm missiles and update the dashboard indicators
\
\ ******************************************************************************

.ABORT

 LDX #&FF               \ Set X to &FF, which is the value in MSTG when we have
                        \ no target lock for our missile

                        \ Fall through into ABORT2 to set the missile lock to
                        \ the value in X, which effectively disarms the missile

