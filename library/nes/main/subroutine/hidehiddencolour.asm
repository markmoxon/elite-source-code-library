\ ******************************************************************************
\
\       Name: HideHiddenColour
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Set the hidden colour to black, so that pixels in this colour in
\             palette 0 are invisible
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   A                   A is set to 15
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   oh                  Contains an RTS
\
\ ******************************************************************************

.HideHiddenColour

 LDA #&0F               \ Set hiddenColour to &0F, which is black, so this hides
 STA hiddenColour       \ any pixels that use the hidden colour in palette 0

.oh

 RTS                    \ Return from the subroutine

