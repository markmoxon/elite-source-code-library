\ ******************************************************************************
\
\       Name: OTHERFILEPR
\       Type: Subroutine
\   Category: Save and load
\    Summary: Display the non-selected media (disk or tape)
\  Deep dive: Extended text tokens
\
\ ******************************************************************************

.OTHERFILEPR

IF NOT(_NES_VERSION OR _C64_VERSION OR _APPLE_VERSION)

 LDA #2                 \ Print extended token 2 - DISK, i.e. token 2 or 3 (as
 SEC                    \ DISK can be 0 or &FF). In other versions of the game,
 SBC DISK               \ such as the Commodore 64 version, token 2 is "disk"
 JMP DETOK              \ and token 3 is "tape", so this displays the other,
                        \ non-selected media, but this system is unused in the
                        \ Master version and tokens 2 and 3 contain different
                        \ text

ELIF _C64_VERSION OR _APPLE_VERSION

 LDA #2                 \ Print extended token 2 - DISK, i.e. token 2 or 3 (as
 SEC                    \ DISK can be 0 or &FF). Token 2 is "disk" and token 3
 SBC DISK               \ is "tape", so this displays the other, non-selected
 JMP DETOK              \ media

ELIF _NES_VERSION

 RTS                    \ Return from the subroutine, as OTHERFILEPR does
                        \ nothing in the NES version

ENDIF

