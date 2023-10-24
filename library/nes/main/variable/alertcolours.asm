\ ******************************************************************************
\
\       Name: alertColours
\       Type: Variable
\   Category: Status
\    Summary: Colours for the background of the commander image to show the
\             status condition when we are not looking at the space view
\
\ ******************************************************************************

.alertColours

 EQUB &1C               \ Colour for condition Docked (medium cyan)

 EQUB &1A               \ Colour for condition Green (medium green)

 EQUB &28               \ Colour for condition Yellow (light yellow)

 EQUB &16               \ Colour for condition Red (medium red)

 EQUB &06               \ Flash colour for condition Red (dark red)

