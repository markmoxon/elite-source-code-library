\ ******************************************************************************
\
\       Name: Checksum
\       Type: Subroutine
\   Category: Copy protection
\    Summary: Checksum the code from &1000 to &9FFF and check against S%-1
\
\ ------------------------------------------------------------------------------
\
\ In the original source, the checksum byte at S%-1 is set by the first call to
\ ZP in the Big Code File, though in the BeebAsm version this is populated by
\ elite-checksum.py.
\
\ The original 6502 assembly language version of the ZP routine can be found in
\ the elite-checksum.asm file.
\
\ ******************************************************************************

.Checksum

 SEC                    \ Set the C flag, so it gets included in the checksum

 LDY #0                 \ Set Y = 0, to act as a byte counter

 STY V                  \ Set V = 0

 LDX #&10               \ Set X = &10, so we start with (X Y) = &1000

 LDA (SC)               \ This has no effect, as A is overwritten by the next
                        \ instruction

 TXA                    \ Set A = &10

.CHKLoop

 STX V+1                \ Set V(1 0) = (X 0)

 STY T                  \ Set T = Y

 ADC (V),Y              \ Set A = A + C + contents of (V(1 0) + Y)
                        \       = A + C + contents of ((X 0) + Y)
                        \       = A + C + contents of (X Y)

 EOR T                  \ Set A = A EOR Y

 SBC V+1                \ Set A = A - (1 - C) - X

 DEY                    \ Decrement the loop counter to process the next byte

 BNE CHKLoop            \ Loop back until we have done the whole page

 INX                    \ Increment the page counter to point to the next page

 CPX #&A0               \ Loop back to do the next page until X = &A0, when
 BCC CHKLoop            \ (X Y) = &A000

 CMP S%-1               \ Compare the calculated checksum in A with the checksum
                        \ stored in S%-1

IF _REMOVE_CHECKSUMS

 NOP                    \ If we have disabled checksums, then ignore the result
 NOP                    \ of the comparison and return from the subroutine

ELSE

 BNE Checksum           \ If the checksum we just calculated does not match
                        \ the value in location S%-1, jump to Checksum to enter
                        \ an infinite loop, which crashes the game

ENDIF

 RTS                    \ Return from the subroutine

