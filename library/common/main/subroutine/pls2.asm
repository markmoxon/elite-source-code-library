\ ******************************************************************************
\
\       Name: PLS2
\       Type: Subroutine
\   Category: Drawing planets
\    Summary: Draw a half-ellipse
\  Deep dive: Drawing ellipses
\             Drawing meridians and equators
\
\ ------------------------------------------------------------------------------
\
\ Draw a half-ellipse, used for the planet's equator and meridian.
\
\ ******************************************************************************

.PLS2

 LDA #31                \ Set TGT = 31, so we only draw half an ellipse
 STA TGT

                        \ Fall through into PLS22 to draw the half-ellipse

