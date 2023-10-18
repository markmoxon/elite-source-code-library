\ ******************************************************************************
\
\       Name: HighlightEquipment
\       Type: Subroutine
\   Category: Equipment
\    Summary: Highlight an item of equipment on the Equip Ship screen
\
\ ******************************************************************************

.HighlightEquipment

 LDX #2                 \ Set the font style to print in the highlight font
 STX fontStyle

 LDX XX13               \ Set X to the item number to print

 JSR PrintEquipment+2   \ Print the name and price for the equipment item in X

 LDX #1                 \ Set the font style to print in the normal font
 STX fontStyle

 RTS                    \ Return from the subroutine

