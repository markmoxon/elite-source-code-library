\ ******************************************************************************
\
\       Name: DOT
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Draw a dot on the compass
\
\ ------------------------------------------------------------------------------
\
\ Draw a dot on the compass.
\
\ Arguments:
\
\   COMX                The screen pixel x-coordinate of the dot
\
\   COMY                The screen pixel y-coordinate of the dot
\
\   COMC                The colour and thickness of the dot:
\
\                         * &F0 = a double-height dot in yellow/white, for when
\                           the object in the compass is in front of us
\
\                         * &FF = a single-height dot in green/cyan, for when
\                           the object in the compass is behind us
\
\ ******************************************************************************

.DOT

 LDA COMY               \ Set Y1 = COMY, the y-coordinate of the dot
 STA Y1

 LDA COMX               \ Set X1 = COMX, the x-coordinate of the dot
 STA X1

 LDA COMC               \ Set COL = COMC, the mode 5 colour byte for the dot
 STA COL

 CMP #&F0               \ If COL is &F0 then the dot is in front of us and we
 BNE CPIX2              \ want to draw a double-height dot, so if it isn't &F0
                        \ jump to CPIX2 to draw a single-height dot

                        \ Otherwise fall through into CPIX4 to draw a double-
                        \ height dot

