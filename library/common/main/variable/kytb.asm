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
\ codes for the flight keys (see p.142 of the Advanced User Guide for a list of
\ internal key numbers).
\
\ The pitch, roll, speed and laser keys (i.e. the seven primary flight
\ control keys) have bit 7 set, so they have 128 added to their internal
\ values. This doesn't appear to be used anywhere.
\
\ Note that KYTB actually points to the byte before the start of the table, so
\ the offset of the first key value is 1 (i.e. KYTB+1), not 0.
\
IF _6502SP_VERSION \ Comment
\ Other entry points:
\
\   KYTB                Contains an RTS
\
ENDIF
\ ******************************************************************************

IF _CASSETTE_VERSION \ Label

KYTB = P% - 1           \ Point KYTB to the byte before the start of the table

ELIF _6502SP_VERSION OR _DISC_FLIGHT OR _MASTER_VERSION

.KYTB

ENDIF

IF _6502SP_VERSION OR _DISC_FLIGHT \ Label

 RTS                    \ Return from the subroutine (used as an entry point and
                        \ a fall-through from above)

ENDIF

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _6502SP_VERSION

                        \ These are the primary flight controls (pitch, roll,
                        \ speed and lasers):

 EQUB &68 + 128         \ ?         KYTB+1      Slow down
 EQUB &62 + 128         \ Space     KYTB+2      Speed up
 EQUB &66 + 128         \ <         KYTB+3      Roll left
 EQUB &67 + 128         \ >         KYTB+4      Roll right
 EQUB &42 + 128         \ X         KYTB+5      Pitch up
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

ELIF _MASTER_VERSION

 EQUB &DD EOR 255       \ E         KYTB+0    KY13     E.C.M.
 EQUB &DC EOR 255       \ T         KYTB+1    KY10     Arm missile
 EQUB &CA EOR 255       \ U         KYTB+2    KY11     Unarm missile
 EQUB &C8 EOR 255       \ P         KYTB+3    KY16     Cancel docking computer
 EQUB &BE EOR 255       \ A         KYTB+4    KY7      Fire lasers
 EQUB &BD EOR 255       \ X         KYTB+5    KY5      Pitch up
 EQUB &BA EOR 255       \ J         KYTB+6    KY14     In-system jump
 EQUB &AE EOR 255       \ S         KYTB+7    KY6      Pitch down
 EQUB &AD EOR 255       \ C         KYTB+8    KY15     Docking computer
 EQUB &9F EOR 255       \ TAB       KYTB+9    KY8      Energy bomb
 EQUB &9D EOR 255       \ Space     KYTB+10   KY2      Speed up
 EQUB &9A EOR 255       \ M         KYTB+11   KY12     Fire missile
 EQUB &99 EOR 255       \ <         KYTB+12   KY3      Roll left
 EQUB &98 EOR 255       \ >         KYTB+13   KY4      Roll right
 EQUB &97 EOR 255       \ ?         KYTB+14   KY1      Slow down
 EQUB &8F EOR 255       \ ESCAPE    KYTB+15   KY9      Launch escape pod

 EQUB &F0               \ This value just has to be higher than &80 to act as a
                        \ terminator for the KYTB matching process in DKS1

ENDIF

IF _6502SP_VERSION OR _DISC_FLIGHT \ Enhanced: The lookup table for in-flight keyboard controls contains an extra entry in the enhanced versions, for "P" (cancel docking computer)

 EQUB &37               \ P         KYTB+16     Cancel docking computer

ENDIF

