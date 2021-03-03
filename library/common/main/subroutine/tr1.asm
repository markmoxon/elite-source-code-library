\ ******************************************************************************
\
\       Name: TR1
\       Type: Subroutine
\   Category: Save and load
\    Summary: Copy the last saved commander's name from NA% to INWK
\
\ ******************************************************************************

.TR1

 LDX #7                 \ The commander's name can contain a maximum of 7
                        \ characters, and is terminated by a carriage return,
                        \ so set up a counter in X to copy 8 characters

.GTL2

IF _CASSETTE_VERSION \ Platform

 LDA NA%,X              \ Copy the X-th byte of NA% to the X-th byte of INWK
 STA INWK,X

ELIF _6502SP_VERSION OR _DISC_VERSION

 LDA NA%,X              \ Copy the X-th byte of NA% to the X-th byte of INWK+5
 STA INWK+5,X

ENDIF

 DEX                    \ Decrement the loop counter

 BPL GTL2               \ Loop back until we have copied all 8 bytes

 RTS                    \ Return from the subroutine

