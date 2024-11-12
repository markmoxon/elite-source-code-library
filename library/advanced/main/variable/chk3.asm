\ ******************************************************************************
\
\       Name: CHK3
\       Type: Variable
\   Category: Save and load
\    Summary: Third checksum byte for the saved commander data file
\  Deep dive: Commander save files
\             The competition code
\
\ ------------------------------------------------------------------------------
\
\ Commander checksum byte for the Apple II and Commodore 64 versions only. If
\ the default commander is changed, a new checksum will be calculated and
\ inserted by the elite-checksum.py script.
\
\ The offset of this byte within a saved commander file is also shown (it's at
\ byte #75).
\
\ ******************************************************************************

.CHK3

IF NOT(_APPLE_VERSION)

 EQUB 0                 \ Placeholder for the checksum in byte #75

ELIF _APPLE_VERSION

IF _IB_DISK

 EQUB &27               \ The third checksum value for the default commander,
                        \ #75

ELIF _SOURCE_DISK_BUILD OR _SOURCE_DISK_ELT_FILES OR _SOURCE_DISK_CODE_FILES

 EQUB 0                 \ Placeholder for the checksum in byte #75

ENDIF

ENDIF

