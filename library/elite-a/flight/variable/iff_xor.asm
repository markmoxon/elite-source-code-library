\ ******************************************************************************
\
\       Name: iff_xor
\       Type: Variable
\   Category: Dashboard
\    Summary: The EOR value for different types of ship in the the I.F.F. system
\             for creating striped sticks in the scanner
\
\ ------------------------------------------------------------------------------
\
\ These are the EOR values for the I.F.F. system, which shows ships on the
\ scanner in the following colours, depending on the type index for this ship
\ (as returned by the iff_index routine). The EOR values determine whether the
\ stick is striped.
\
\ The colours for the normal dashboard palette are:
\
\   Index     Dot colour  Stick colour(s)     Ship types
\   -----     ----------  ---------------     ----------
\   0         Green       Green               Clean
\   1         Yellow      Yellow              Station tracked
\   2         Green       Green and yellow    Debris
\   3         Yellow      Yellow and red      Missile
\   4         Green       Green and red       Offender/fugitive
\
\ The colours for the escape pod dashboard palette are:
\
\   Index     Dot colour  Stick colour(s)     Ship types
\   -----     ----------  ---------------     ----------
\   0         Cyan        Cyan                Clean
\   1         White       White               Station tracked
\   2         Cyan        Cyan and white      Debris
\   3         White       White and red       Missile
\   4         Cyan        Cyan and red        Offender/fugitive
\
\ The EOR values have the following effect on the colour of the stick:
\
\   %00000000       Stick is a solid colour, in the base colour
\   %00001111       Stick is striped, in the base colour and base colour EOR %01
\   %11110000       Stick is striped, in the base colour and base colour EOR %10
\   %11111111       Stick is striped, in the base colour and base colour EOR %11
\
\ Taking the example of debris, the base colour from iff_base+2 is &FF, which is
\ %11111111, or a four-pixel byte of colour %11, or colour 3 in mode 5, or
\ green/cyan (green for the normal palette, cyan in the escape pod palette).
\
\ The EOR value from iff_xor+2 is &0F, which is %00001111, or a four-pixel byte
\ of %01 values. Applying this EOR to the base colour (%11) gives:
\
\   %11 EOR %01 = %10 = 2
\
\ and colour 2 in mode 5 is yellow/white (yellow for the normal palette, white
\ in the escape pod palette). So the stick colour for debris when we have an
\ I.F.F. system fitted is:
\
\   Green/cyan (the base colour) striped with yellow/white (the colour after
\   applying the EOR value)
\
\ If there is no I.F.F. system fitted, the index is 0 and the EOR value is 0,
\ which doesn't affect the default colour.
\
\ The last two entries are the same as the first two entries in iff_base, which
\ is the next variable, so they are commented out here to save two bytes.
\
\ ******************************************************************************

.iff_xor

 EQUB &00               \ Index 0: Clean = %00000000

 EQUB &00               \ Index 1: Station tracked = %00000000

 EQUB &0F               \ Index 2: Debris = %00001111

\EQUB &FF               \ Index 3: Missile = %11111111

\EQUB &F0               \ Index 4: Offender/fugitive = %11110000

