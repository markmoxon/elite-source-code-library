\ ******************************************************************************
\
\       Name: SetDrawPlaneFlags
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Set the drawing bitplane flags to the specified value, draw the
\             box edges and set the next free tile number
\
\ ******************************************************************************

.SetDrawPlaneFlags

 PHA                    \ Store A on the stack, so we can retrieve them below
                        \ when setting the new drawing bitplane flags

 JSR DrawBoxEdges       \ Draw the left and right edges of the box along the
                        \ sides of the screen, drawing into the nametable buffer
                        \ for the drawing bitplane

 LDX drawingBitplane    \ Set X to the drawing bitplane

 LDA firstFreePattern   \ Tell the NMI handler to send pattern entries up to the
 STA lastPatternTile,X  \ first free pattern, for the drawing bitplane in X

 PLA                    \ Retrieve A from the stack and set it as the value of
 STA bitplaneFlags,X    \ the drawing bitplane flags

 RTS                    \ Return from the subroutine

