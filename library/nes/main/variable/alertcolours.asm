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

 EQUB &1C               \ Colour for condition Docked (blue-green)

 EQUB &1A               \ Colour for condition Green (green)

 EQUB &28               \ Colour for condition Yellow (orange)

 EQUB &16               \ Colour for condition Red (light red)

 EQUB &06               \ Flash with this colour (dark red) for condition Red

