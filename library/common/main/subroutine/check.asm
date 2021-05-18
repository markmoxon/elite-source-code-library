\ ******************************************************************************
\
\       Name: CHECK
\       Type: Subroutine
\   Category: Save and load
\    Summary: Calculate the checksum for the last saved commander data block
\  Deep dive: Commander save files
\
\ ------------------------------------------------------------------------------
\
\ The checksum for the last saved commander data block is saved as part of the
\ commander file, in two places (CHK AND CHK2), to protect against file
\ tampering. This routine calculates the checksum and returns it in A.
\
\ This algorithm is also implemented in elite-checksum.py.
\
\ Returns:
\
\   A                   The checksum for the last saved commander data block
\
\ ******************************************************************************

.CHECK

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_DOCKED OR _ELITE_A_DOCKED OR _6502SP_VERSION \ Platform

 LDX #NT%-2             \ Set X to the size of the commander data block, less
                        \ 2 (to omit the checksum bytes and the save count)

ELIF _MASTER_VERSION

 LDX #NT%-3             \ Set X to the size of the commander data block, less
                        \ 3 (as there are two checksum bytes and the save count)

ENDIF

 CLC                    \ Clear the C flag so we can do addition without the
                        \ C flag affecting the result

 TXA                    \ Seed the checksum calculation by setting A to the
                        \ size of the commander data block, less 2

                        \ We now loop through the commander data block,
                        \ starting at the end and looping down to the start
                        \ (so at the start of this loop, the X-th byte is the
                        \ last byte of the commander data block, i.e. the save
                        \ count)

.QUL2

 ADC NA%+7,X            \ Add the X-1-th byte of the data block to A, plus the
                        \ C flag

 EOR NA%+8,X            \ EOR A with the X-th byte of the data block

 DEX                    \ Decrement the loop counter

 BNE QUL2               \ Loop back for the next byte in the calculation, until
                        \ we have added byte #0 and EOR'd with byte #1 of the
                        \ data block

 RTS                    \ Return from the subroutine

