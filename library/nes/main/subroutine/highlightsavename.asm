\ ******************************************************************************
\
\       Name: HighlightSaveName
\       Type: Subroutine
\   Category: Save and load
\    Summary: Highlight the name of a specific save slot
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The save slot number to highlight
\
\ ******************************************************************************

.HighlightSaveName

 LDX #2                 \ Set the font style to print in the highlight font
 STX fontStyle

 JSR PrintSaveName      \ Print the name of the commander file saved in slot A

 LDX #1                 \ Set the font style to print in the normal font
 STX fontStyle

 RTS                    \ Return from the subroutine

