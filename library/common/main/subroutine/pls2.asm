\ ******************************************************************************
\
\       Name: PLS2
\       Type: Subroutine
\   Category: Drawing planets
\    Summary: Draw a half-circle
\
\ ------------------------------------------------------------------------------
\
\ Draw a half-circle, used for the planet's equator and meridian.
\
\ ******************************************************************************

.PLS2

 LDA #31                \ Set TGT = 31, so we only draw half a circle
 STA TGT

                        \ Fall through into PLS22 to draw the half circle

