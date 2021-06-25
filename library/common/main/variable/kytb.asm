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
IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION \ Comment
\ Keyboard table for in-flight controls. This table contains the internal key
\ codes for the flight keys (see p.142 of the Advanced User Guide for a list of
\ internal key numbers).
ELIF _ELECTRON_VERSION
\ Keyboard table for in-flight controls. This table contains the internal key
\ codes for the flight keys (see p.40 of the Electron Advanced User Guide for a
\ list of internal key numbers).
ELIF _MASTER_VERSION
\ Keyboard table for in-flight controls. This table contains the internal key
\ codes for the flight keys, EOR'd with &FF to invert each bit.
ENDIF
\
\ The pitch, roll, speed and laser keys (i.e. the seven primary flight
\ control keys) have bit 7 set, so they have 128 added to their internal
\ values. This doesn't appear to be used anywhere.
\
IF _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT \ Comment
\ Note that KYTB actually points to the byte before the start of the table, so
\ the offset of the first key value is 1 (i.e. KYTB+1), not 0.
\
\ Other entry points:
\
\   KYTB                Contains an RTS
\
ENDIF
\ ******************************************************************************

IF _CASSETTE_VERSION \ Label

KYTB = P% - 1           \ Point KYTB to the byte before the start of the table

ELIF _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _MASTER_VERSION

.KYTB

ENDIF

IF _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT \ Label

 RTS                    \ Return from the subroutine (used as an entry point and
                        \ a fall-through from above)

ENDIF

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _6502SP_VERSION \ Master: The Master has a very different set of internal key numbers to the BBC Micro and Electron, so the keyboard lookup table for the Master is also very different; the Electron and BBC Micro are much more similar, but the Electron has no TAB key, so "-" launches an energy bomb instead

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

ELIF _ELECTRON_VERSION

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

 EQUB &17               \ -         KYTB+8      Energy bomb
 EQUB &70               \ ESCAPE    KYTB+9      Launch escape pod
 EQUB &23               \ T         KYTB+10     Arm missile
 EQUB &35               \ U         KYTB+11     Unarm missile
 EQUB &65               \ M         KYTB+12     Fire missile
 EQUB &22               \ E         KYTB+13     E.C.M.
 EQUB &45               \ J         KYTB+14     In-system jump
 EQUB &52               \ C         KYTB+15     Docking computer

ELIF _MASTER_VERSION

 EQUB &DD EOR &FF       \ E         KYTB+0    KY13     E.C.M.
 EQUB &DC EOR &FF       \ T         KYTB+1    KY10     Arm missile
 EQUB &CA EOR &FF       \ U         KYTB+2    KY11     Unarm missile
 EQUB &C8 EOR &FF       \ P         KYTB+3    KY16     Cancel docking computer
 EQUB &BE EOR &FF       \ A         KYTB+4    KY7      Fire lasers
 EQUB &BD EOR &FF       \ X         KYTB+5    KY5      Pitch up
 EQUB &BA EOR &FF       \ J         KYTB+6    KY14     In-system jump
 EQUB &AE EOR &FF       \ S         KYTB+7    KY6      Pitch down
 EQUB &AD EOR &FF       \ C         KYTB+8    KY15     Docking computer
 EQUB &9F EOR &FF       \ TAB       KYTB+9    KY8      Energy bomb
 EQUB &9D EOR &FF       \ Space     KYTB+10   KY2      Speed up
 EQUB &9A EOR &FF       \ M         KYTB+11   KY12     Fire missile
 EQUB &99 EOR &FF       \ <         KYTB+12   KY3      Roll left
 EQUB &98 EOR &FF       \ >         KYTB+13   KY4      Roll right
 EQUB &97 EOR &FF       \ ?         KYTB+14   KY1      Slow down
 EQUB &8F EOR &FF       \ ESCAPE    KYTB+15   KY9      Launch escape pod

 EQUB &F0               \ This value just has to be higher than &80 to act as a
                        \ terminator for the KYTB matching process in DKS1

ELIF _ELITE_A_VERSION

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

 EQUB &60               \ TAB       KYTB+8      Activate hyperspace unit
 EQUB &70               \ ESCAPE    KYTB+9      Launch escape pod
 EQUB &23               \ T         KYTB+10     Arm missile
 EQUB &35               \ U         KYTB+11     Unarm missile
 EQUB &65               \ M         KYTB+12     Fire missile
 EQUB &22               \ E         KYTB+13     E.C.M.
 EQUB &45               \ J         KYTB+14     In-system jump
 EQUB &63               \ AJD

ENDIF

IF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION \ Enhanced: The lookup table for in-flight keyboard controls contains an extra entry in the enhanced versions, for "P" (cancel docking computer)

 EQUB &37               \ P         KYTB+16     Cancel docking computer

ENDIF

