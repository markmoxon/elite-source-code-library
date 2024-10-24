\ ******************************************************************************
\
\       Name: OTHERFILEPR
\       Type: Subroutine
\   Category: Save and load
\    Summary: Display the non-selected media (disc or tape)
\  Deep dive: Extended text tokens
\
\ ******************************************************************************

.OTHERFILEPR

IF NOT(_NES_VERSION)

 LDA #2                 \ Print extended token 2 - DISK, i.e. token 2 or 3 (as
 SEC                    \ DISK can be 0 or &FF). In other versions of the game,
 SBC DISK               \ such as the Commodore 64 version, token 2 is "disk"
 JMP DETOK              \ and token 3 is "tape", so this displays the other,
                        \ non-selected media, but this system is unused in the
                        \ Master version and tokens 2 and 3 contain different
                        \ text

ELIF _NES_VERSION

 RTS                    \ Return from the subroutine, as OTHERFILEPR does
                        \ nothing in the NES version

ENDIF

