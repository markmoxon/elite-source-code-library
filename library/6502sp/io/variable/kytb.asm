\ ******************************************************************************
\
\       Name: KYTB
\       Type: Variable
\   Category: Keyboard
\    Summary: Lookup table for in-flight keyboard controls
\  Deep dive: The key logger
\
\ ------------------------------------------------------------------------------
\
\ Keyboard table for in-flight controls. This table contains the internal key
\ codes for the flight keys (see p.142 of the "Advanced User Guide for the BBC
\ Micro" by Bray, Dickens and Holmes for a list of internal key numbers).
\
\ The pitch, roll, speed and laser keys (i.e. the seven primary flight
\ control keys) have bit 7 set, so they have 128 added to their internal
\ values. This doesn't appear to be used anywhere.
\
\ Note that KYTB actually points to the byte before the start of the table, so
\ the offset of the first key value is 1 (i.e. KYTB+1), not 0.
\
\ ******************************************************************************

.KYTB

 EQUB 0                 \ Pad the table out so that the first key is at KYTB+1

                        \ These are the primary flight controls (pitch, roll,
                        \ speed and lasers):

 EQUB &68 + 128         \ ?         KYTB+1      Slow down
 EQUB &62 + 128         \ Space     KYTB+2      Speed up
 EQUB &66 + 128         \ <         KYTB+3      Roll left
 EQUB &67 + 128         \ >         KYTB+4      Roll right
 EQUB &42 + 128         \ X         KYTB+5      Pull up
 EQUB &51 + 128         \ S         KYTB+6      Pitch down
 EQUB &41 + 128         \ A         KYTB+7      Fire lasers

                        \ These are the secondary flight controls:

 EQUB &60               \ TAB       KYTB+8      Energy bomb
 EQUB &70               \ ESCAPE    KYTB+9      Launch escape pod
 EQUB &23               \ T         KYTB+10     Arm missile
 EQUB &35               \ U         KYTB+11     Unarm missile
 EQUB &65               \ M         KYTB+12     Fire missile
 EQUB &22               \ E         KYTB+13     E.C.M.
 EQUB &45               \ J         KYTB+14     In-system jump
 EQUB &52               \ C         KYTB+15     Docking computer

 NOP                    \ In the parasite's version of this table, this byte
                        \ maps to "P", the key to cancel the docking computer,
                        \ but because the I/O processor only uses this table for
                        \ the primary flight keys, this byte isn't used

