\ ******************************************************************************
\
\       Name: b_table
\       Type: Variable
\   Category: Keyboard
\    Summary: Lookup table for Delta 14B joystick buttons
\  Deep dive: Delta 14B joystick support
\
\ ------------------------------------------------------------------------------
\
\ In the following table, which maps buttons on the Delta 14B to the flight
\ controls, the high nibble of the value gives the column:
\
\   &6 = %110 = left column
\   &5 = %101 = middle column
\   &3 = %011 = right column
\
\ while the low nibble gives the row:
\
\   &1 = %0001 = top row
\   &2 = %0010 = second row
\   &4 = %0100 = third row
\   &8 = %1000 = bottom row
\
\ This results in the following mapping (as the top two fire buttons are treated
\ the same as the top button in the middle row):
\
\   Fire laser                                    Fire laser
\
\   Slow down              Fire laser             Speed up
\   Unarm Missile          Fire Missile           Target missile
\   Hyperspace Unit        E.C.M.                 Escape pod
\   Docking computer off   In-system jump         Docking computer on
\
\ Note that this is different to the layout in Angus Duggan's documentation, as
\ he has the docking computer buttons the wrong way around in his instructions.
\
\ ******************************************************************************

.b_table

 EQUB &61               \ Left column    Top row      KYTB+1    Slow down
 EQUB &31               \ Right column   Top row      KYTB+2    Speed up
 EQUB &80               \ -                           KYTB+3    Roll left
 EQUB &80               \ -                           KYTB+4    Roll right
 EQUB &80               \ -                           KYTB+5    Pitch up
 EQUB &80               \ -                           KYTB+6    Pitch down
 EQUB &51               \ Middle column  Top row      KYTB+7    Fire lasers
 EQUB &64               \ Left column    Third row    KYTB+8    Hyperspace unit
 EQUB &34               \ Right column   Third row    KYTB+9    Escape pod
 EQUB &32               \ Right column   Second row   KYTB+10   Arm missile
 EQUB &62               \ Left column    Second row   KYTB+11   Unarm missile
 EQUB &52               \ Middle column  Second row   KYTB+12   Fire missile
 EQUB &54               \ Middle column  Third row    KYTB+13   E.C.M.
 EQUB &58               \ Middle column  Bottom row   KYTB+14   In-system jump
 EQUB &38               \ Right column   Bottom row   KYTB+15   Docking computer
 EQUB &68               \ Left column    Bottom row   KYTB+16   Cancel docking

