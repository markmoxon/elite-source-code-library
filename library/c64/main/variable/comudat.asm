\ ******************************************************************************
\
\       Name: COMUDAT
\       Type: Variable
\   Category: Sound
\    Summary: Music data from the C.COMUDAT file
\
\ ******************************************************************************

IF _GMA_RELEASE

 INCBIN "versions/c64/1-source-files/music/gma/C.COMUDAT.bin"

ELIF _SOURCE_DISK

 INCBIN "versions/c64/1-source-files/music/source-disk/C.COMUDAT.bin"

ENDIF

.THEME

IF _SOURCE_DISK

 EQUB &28               \ C.THEME is not included in the encrypted HICODE binary
                        \ in the source disk variant, unlike the GMA85 variant

ELIF _GMA_RELEASE

 INCBIN "versions/c64/1-source-files/music/gma/C.THEME.bin"

ENDIF

