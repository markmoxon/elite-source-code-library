\ ******************************************************************************
\
\       Name: TRNME
\       Type: Subroutine
\   Category: Save and load
\    Summary: Copy the last saved commander's name from INWK to NA%
\
\ ******************************************************************************

.TRNME

 LDX #7                 \ The commander's name can contain a maximum of 7
                        \ characters, and is terminated by a carriage return,
                        \ so set up a counter in X to copy 8 characters

IF _MASTER_VERSION

 LDA NAMELEN1           \ ???
 STA NAMELEN2

ENDIF

.GTL1

IF _CASSETTE_VERSION \ Platform

 LDA INWK,X             \ Copy the X-th byte of INWK to the X-th byte of NA%
 STA NA%,X

ELIF _6502SP_VERSION OR _DISC_VERSION OR _MASTER_VERSION

 LDA INWK+5,X           \ Copy the X-th byte of INWK+5 to the X-th byte of NA%
 STA NA%,X

ENDIF

 DEX                    \ Decrement the loop counter

 BPL GTL1               \ Loop back until we have copied all 8 bytes

                        \ Fall through into TR1 to copy the name back from NA%
                        \ to INWK. This isn't necessary as the name is already
                        \ there, but it does save one byte, as we don't need an
                        \ RTS here

