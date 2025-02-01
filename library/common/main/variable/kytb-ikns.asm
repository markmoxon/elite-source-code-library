\ ******************************************************************************
\
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _APPLE_VERSION \ Comment
\       Name: KYTB
ELIF _MASTER_VERSION
\       Name: IKNS
ENDIF
\       Type: Variable
\   Category: Keyboard
\    Summary: Lookup table for in-flight keyboard controls
\  Deep dive: The key logger
\
\ ------------------------------------------------------------------------------
\
IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _6502SP_VERSION \ Comment
\ Keyboard table for in-flight controls. This table contains the internal key
\ codes for the flight keys (see page 142 of the "Advanced User Guide for the
\ BBC Micro" by Bray, Dickens and Holmes for a list of internal key numbers).
\
ELIF _ELECTRON_VERSION
\ Keyboard table for in-flight controls. This table contains the internal key
\ codes for the flight keys (see page 40 of the "Acorn Electron Advanced User
\ Guide" by Holmes and Dickens for a list of internal key numbers).
\
ELIF _MASTER_VERSION
\ Keyboard table for in-flight controls. This table contains the internal key
\ codes for the flight keys, EOR'd with &FF to invert each bit.
\
ELIF _C64_VERSION
\ This table is not used by the Commodore 64 version of Elite, and is left over
\ from the BBC Micro version.
\
ELIF _APPLE_VERSION
\ Keyboard table for in-flight controls. This table contains the ASCII values
\ for the flight keys.
\
ENDIF
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _ELITE_A_6502SP_IO \ Comment
\ The pitch, roll, speed and laser keys (i.e. the seven primary flight
\ control keys) have bit 7 set, so they have 128 added to their internal
\ values. This doesn't appear to be used anywhere.
\
ENDIF
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT \ Comment
\ Note that KYTB actually points to the byte before the start of the table, so
\ the offset of the first key value is 1 (i.e. KYTB+1), not 0.
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   KYTB                Contains an RTS
\
ENDIF
\ ******************************************************************************

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _C64_VERSION OR _APPLE_VERSION \ Label

.KYTB

ELIF _MASTER_VERSION

.IKNS

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_FLIGHT OR _C64_VERSION OR _APPLE_VERSION \ Label

 RTS                    \ Return from the subroutine (used as an entry point and
                        \ a fall-through from above)

ENDIF

IF _CASSETTE_VERSION OR _DISC_FLIGHT OR _6502SP_VERSION OR _C64_VERSION \ Master: The Master has a very different set of internal key numbers to the BBC Micro and Electron, so the keyboard lookup table for the Master is also very different; the Electron and BBC Micro are much more similar, but the Electron has no TAB key, so "-" launches an energy bomb instead

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

ELIF _ELECTRON_VERSION

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

 EQUB &17               \ -         KYTB+8      Energy bomb
 EQUB &70               \ ESCAPE    KYTB+9      Launch escape pod
 EQUB &23               \ T         KYTB+10     Arm missile
 EQUB &35               \ U         KYTB+11     Unarm missile
 EQUB &65               \ M         KYTB+12     Fire missile
 EQUB &22               \ E         KYTB+13     E.C.M.
 EQUB &45               \ J         KYTB+14     In-system jump
 EQUB &52               \ C         KYTB+15     Docking computer

ELIF _MASTER_VERSION

 EQUB &DD EOR &FF       \ E         IKNS+0    KY13     E.C.M.
 EQUB &DC EOR &FF       \ T         IKNS+1    KY10     Arm missile
 EQUB &CA EOR &FF       \ U         IKNS+2    KY11     Unarm missile
 EQUB &C8 EOR &FF       \ P         IKNS+3    KY16     Cancel docking computer
 EQUB &BE EOR &FF       \ A         IKNS+4    KY7      Fire lasers
 EQUB &BD EOR &FF       \ X         IKNS+5    KY5      Pull up
 EQUB &BA EOR &FF       \ J         IKNS+6    KY14     In-system jump
 EQUB &AE EOR &FF       \ S         IKNS+7    KY6      Pitch down
 EQUB &AD EOR &FF       \ C         IKNS+8    KY15     Docking computer
 EQUB &9F EOR &FF       \ TAB       IKNS+9    KY8      Energy bomb
 EQUB &9D EOR &FF       \ Space     IKNS+10   KY2      Speed up
 EQUB &9A EOR &FF       \ M         IKNS+11   KY12     Fire missile
 EQUB &99 EOR &FF       \ <         IKNS+12   KY3      Roll left
 EQUB &98 EOR &FF       \ >         IKNS+13   KY4      Roll right
 EQUB &97 EOR &FF       \ ?         IKNS+14   KY1      Slow down
 EQUB &8F EOR &FF       \ ESCAPE    IKNS+15   KY9      Launch escape pod

 EQUB &F0               \ This value just has to be higher than &80 to act as a
                        \ terminator for the IKNS matching process in FILLKL

ELIF _APPLE_VERSION

                        \ These are the primary flight controls (pitch, roll,
                        \ speed and lasers):

 EQUS "/"               \ ?         KYTB+1      Slow down
 EQUS " "               \ Space     KYTB+2      Speed up
 EQUS ","               \ <         KYTB+3      Roll left
 EQUS "."               \ >         KYTB+4      Roll right
 EQUS "X"               \ X         KYTB+5      Pull up
 EQUS "S"               \ S         KYTB+6      Pitch down
 EQUS "A"               \ A         KYTB+7      Fire lasers

                        \ These are the secondary flight controls:

 EQUS "B"               \ B         KYTB+8      Energy bomb
 EQUB 27                \ ESCAPE    KYTB+9      Launch escape pod
 EQUS "T"               \ T         KYTB+10     Arm missile
 EQUS "U"               \ U         KYTB+11     Unarm missile
 EQUS "M"               \ M         KYTB+12     Fire missile
 EQUS "E"               \ E         KYTB+13     E.C.M.
 EQUS "J"               \ J         KYTB+14     In-system jump
 EQUS "C"               \ C         KYTB+15     Docking computer
 EQUS "P"               \ P         KYTB+16     Cancel docking computer

ELIF _ELITE_A_VERSION

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

 EQUB &60               \ TAB       KYTB+8      Activate hyperspace unit
 EQUB &70               \ ESCAPE    KYTB+9      Launch escape pod
 EQUB &23               \ T         KYTB+10     Arm missile
 EQUB &35               \ U         KYTB+11     Unarm missile
 EQUB &65               \ M         KYTB+12     Fire missile
 EQUB &22               \ E         KYTB+13     E.C.M.
 EQUB &45               \ J         KYTB+14     In-system jump
 EQUB &63               \ V         KYTB+15     Docking computer

ENDIF

IF _6502SP_VERSION OR _DISC_FLIGHT OR _ELITE_A_VERSION OR _C64_VERSION \ Enhanced: The lookup table for in-flight keyboard controls contains an extra entry in the enhanced versions, for "P" (cancel docking computer)

 EQUB &37               \ P         KYTB+16     Cancel docking computer

ENDIF

