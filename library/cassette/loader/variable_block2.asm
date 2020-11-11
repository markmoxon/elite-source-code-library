\ ******************************************************************************
\
\       Name: block2
\       Type: Variable
\   Category: Screen mode
\    Summary: Palette data for the space part of the screen
\
\ ------------------------------------------------------------------------------
\
\ Palette bytes for use with the split-screen mode 4. See TVT1 in the main game
\ code for an explanation.
\
\ ******************************************************************************

.block2

 EQUB &D0, &C0
 EQUB &B0, &A0
 EQUB &F0, &E0
 EQUB &90, &80
 EQUB &77, &67
 EQUB &37, &27

