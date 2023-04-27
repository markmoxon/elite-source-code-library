\ ******************************************************************************
\
\       Name: FILEPR
\       Type: Subroutine
\   Category: Text
\    Summary: Display the currently selected media (disc or tape)
\  Deep dive: Extended text tokens
\
\ ******************************************************************************

.FILEPR

IF NOT(_NES_VERSION)

 LDA #3                 \ Print extended token 3 + DISK, i.e. token 3 or 2 (as
 CLC                    \ DISK can be 0 or &FF). In other versions of the game,
 ADC DISK               \ such as the Commodore 64 version, token 2 is "disk"
 JMP DETOK              \ and token 3 is "tape", so this displays the currently
                        \ selected media, but this system is unused in the
                        \ Master version and tokens 2 and 3 contain different
                        \ text

ELIF _NES_VERSION
                        \ Fall through into OTHERFILEPR to return from the
                        \ subroutine, as FILEPR does nothing in the NES version

ENDIF

