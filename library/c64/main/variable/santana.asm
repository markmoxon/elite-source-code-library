\ ******************************************************************************
\
\       Name: santana
\       Type: Variable
\   Category: Drawing the screen
\    Summary: Controls whether sprite 1 (the explosion sprite) is drawn in
\             single colour or multicolour mode
\
\ ******************************************************************************

.santana

 EQUB %11111110         \ Multicolour mode for the upper part of the screen

 EQUB %11111100         \ Single colour mode for the lower part of the screen

