\ ******************************************************************************
\
\       Name: CHK
\       Type: Variable
\   Category: Save and load
\    Summary: First checksum byte for the saved commander data file
\  Deep dive: Commander save files
\             The competition code
\
\ ------------------------------------------------------------------------------
\
\ Commander checksum byte. If the default commander is changed, a new checksum
\ will be calculated and inserted by the elite-checksum.py script.
\
IF NOT(_C64_VERSION OR _APPLE_VERSION)
\ The offset of this byte within a saved commander file is also shown (it's at
\ byte #75).
ELIF _C64_VERSION OR _APPLE_VERSION
\ The offset of this byte within a saved commander file is also shown (it's at
\ byte #76).
ENDIF
\
\ ******************************************************************************

.CHK

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION \ 6502SP: The Executive version contains a maxed-out default commander, which has a different checksum

 EQUB &03               \ The checksum value for the default commander, #75

ELIF _6502SP_VERSION

IF _SNG45 OR _SOURCE_DISC

 EQUB &03               \ The checksum value for the default commander, #75

ELIF _EXECUTIVE

 EQUB &3F               \ The checksum value for the maxed-out default
                        \ commander, #75

ENDIF

ELIF _MASTER_VERSION

 EQUB 0                 \ Placeholder for the checksum in byte #75

\.CHK3                  \ These instructions are commented out in the original
\EQUB 0                 \ source

 SKIP 12                \ These bytes appear to be unused, though the first byte
                        \ in this block is included in the commander file (it
                        \ has no effect, as it's the third checksum byte from
                        \ the Commodore 64 version, which isn't used in the
                        \ Master version)

ELIF _C64_VERSION

 EQUB 0                 \ Placeholder for the checksum in byte #76

 SKIP 20                \ These bytes appear to be unused

ELIF _APPLE_VERSION

IF _IB_DISK

 EQUB &03               \ The checksum value for the default commander, #76

ELIF _SOURCE_DISK_BUILD OR _SOURCE_DISK_ELT_FILES OR _SOURCE_DISK_CODE_FILES

 EQUB 0                 \ Placeholder for the checksum in byte #76

ENDIF

 SKIP 20                \ These bytes appear to be unused

ELIF _ELITE_A_VERSION

 EQUB &58               \ The checksum value for the default commander, #75

ENDIF

