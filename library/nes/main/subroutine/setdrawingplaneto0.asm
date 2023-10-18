\ ******************************************************************************
\
\       Name: SetDrawingPlaneTo0
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Set the drawing bitplane to 0
\
\ ******************************************************************************

.SetDrawingPlaneTo0

 LDX #0                 \ Set the drawing bitplane to 0
 JSR SetDrawingBitplane

 RTS                    \ Return from the subroutine

