\ ******************************************************************************
\
\       Name: RedrawCurrentView
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Update the current view when we arrive in a new system
\
\ ******************************************************************************

.RedrawCurrentView

 LDA QQ11               \ If this is the space view (i.e. QQ11 is zero), jump to
 BEQ witc5              \ witc5 to set the current space view type to 4 and show
                        \ the front space view

 LDA QQ11               \ If the view in QQ11 is not %0000110x (i.e. 12 or 13,
 AND #%00001110         \ which are the Short-range Chart and Long-range Chart),
 CMP #%00001100         \ jump to witc2 to keep checking for other view types
 BNE witc2

 LDA QQ11               \ If the view type in QQ11 is not &9C (Short-range
 CMP #&9C               \ Chart), then this must be the Long-range Chart, so
 BNE witc1              \ jump to TT22 via witc1 to show the Long-range Chart

 JMP TT23               \ Otherwise this is the Short-range Chart, so jump to
                        \ TT23 to show the Short-range Chart, returning from the
                        \ subroutine using a tail call

.witc1

 JMP TT22               \ This is the Long-range Chart, so jump to TT22 to show
                        \ it, returning from the subroutine using a tail call

.witc2

 LDA QQ11               \ If the view type in QQ11 is not &97 (Inventory), then
 CMP #&97               \ jump to witc3 to keep checking for other view types
 BNE witc3

 JMP TT213              \ This is the Inventory screen, so jump to TT213 to show
                        \ it, returning from the subroutine using a tail call

.witc3

 CMP #&BA               \ If the view type in QQ11 is not &BA (Market Price),
 BNE witc4              \ then jump to witc4 to display the Status Mode screen

 LDA #&97               \ Set the view type in QQ11 to &97 (Inventory), so the
 STA QQ11               \ call to TT167 toggles this to the Market Price screen

 JMP TT167              \ Jump to TT167 to show the Market Price screen,
                        \ returning from the subroutine using a tail call

.witc4

 JMP STATUS             \ Jump to STATUS to display the Status Mode screen,
                        \ returning from the subroutine using a tail call

.witc5

 LDX #4                 \ If we get here then this is the space view, so set the
 STX VIEW               \ current space view to 4 to denote that we are
                        \ generating a new space view and fall through into
                        \ TT110 to show the front space view (at which point
                        \ VIEW will change to 0)

