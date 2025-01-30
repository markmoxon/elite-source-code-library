\ ******************************************************************************
\
\       Name: CHECK2
\       Type: Subroutine
\   Category: Save and load
\    Summary: Calculate the third checksum for the last saved commander data
\             block (Commodore 64 and Apple II versions only)
\
\ ******************************************************************************

.CHECK2

IF _MASTER_VERSION

\LDX #NT%-3             \ These instructions are commented out in the original
\                       \ source (they are from the Commodore 64 and Apple II
\CLC                    \ versions, and implement the third commander checksum
\                       \ which the Master version doesn't have)
\TXA
\
\.QU2L2
\
\STX T
\EOR T
\ROR A
\
\ADC NA%+7,X
\
\EOR NA%+8,X
\
\DEX
\
\BNE QU2L2
\
\RTS

ELIF _C64_VERSION OR _APPLE_VERSION

 LDX #NT%-3             \ Set X to the size of the commander data block, less
                        \ 3 (as there are two checksum bytes and the save count)

 CLC                    \ Clear the C flag so we can do addition without the
                        \ C flag affecting the result

 TXA                    \ Seed the checksum calculation by setting A to the
                        \ size of the commander data block, less 2

                        \ We now loop through the commander data block,
                        \ starting at the end and looping down to the start
                        \ (so at the start of this loop, the X-th byte is the
                        \ last byte of the commander data block, i.e. the save
                        \ count)

.QU2L2

 STX T                  \ Set A = A EOR X
 EOR T                  \
 ROR A                  \ This additional step is the only difference between
                        \ the original checksum from BBC Micro Elite (in CHECK),
                        \ and this additional checksum in the Commodore 64 and
                        \ Apple II versions

 ADC NA%+7,X            \ Add the X-1-th byte of the data block to A, plus the
                        \ C flag

 EOR NA%+8,X            \ EOR A with the X-th byte of the data block

 DEX                    \ Decrement the loop counter

 BNE QU2L2              \ Loop back for the next byte in the calculation, until
                        \ we have added byte #0 and EOR'd with byte #1 of the
                        \ data block

 RTS                    \ Return from the subroutine

ENDIF

