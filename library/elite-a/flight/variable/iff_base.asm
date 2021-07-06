\ ******************************************************************************
\
\       Name: iff_base
\       Type: Variable
\   Category: Dashboard
\    Summary: Base colours for different types of ship in the the I.F.F. system
\
\ ------------------------------------------------------------------------------
\
\ These are the base colours for the I.F.F. system, which shows ships on the
\ scanner in the following colours, depending on the type index for this ship
\ (as returned by the iff_index routine). The base colours determine the colour
\ of the dot, as well as the underlying colour of the stick (which can be
\ striped, depending on the corresponding EOR colour from iff_xor).
\
\ The colours for the normal dashboard palette are:
\
\   Index     Dot colour  Stick colour(s)     Ship types
\   0         Green       Green               Clean
\   1         Yellow      Yellow              Station tracked
\   2         Green       Green and yellow    Debris
\   3         Yellow      Yellow and red      Missile
\   4         Green       Green and red       Offender/fugitive
\
\ The colours for the escape pod dashboard palette are:
\
\   Index     Dot colour  Stick colour(s)     Ship types
\   0         Cyan        Cyan                Clean
\   1         White       White               Station tracked
\   2         Cyan        Cyan and white      Debris
\   3         White       White and red       Missile
\   4         Cyan        Cyan and red        Offender/fugitive
\
\ ******************************************************************************

.iff_base

 EQUB &FF               \ Index 0: Clean = green/cyan

 EQUB &F0               \ Index 1: Station tracked = yellow/white

 EQUB &FF               \ Index 2: Debris = green/cyan

 EQUB &F0               \ Index 3: Missile = yellow/white

 EQUB &FF               \ Index 4: Offender/fugitive = green/cyan

