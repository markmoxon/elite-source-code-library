\ ******************************************************************************
\
\       Name: DEEOR
\       Type: Subroutine
\   Category: Copy protection
\    Summary: Decrypt bytes between &1300 and &9FFF by EOR'ing them with their
\             page offset
\
\ ------------------------------------------------------------------------------
\
\ In the original source, the bytes between &1300 and &9FFF are EOR'd by the
\ first call to SC in the Big Code File, though in the BeebAsm version they are
\ EOR'd by elite-checksum.py.
\
\ The original 6502 assembly language version of the SC routine can be found in
\ the elite-checksum.asm file.
\
\ ******************************************************************************

.DEEOR

 LDY #0                 \ Set (X Y) = SC(1 0) = &1300
 STY SC
 LDX #&13

.DEEL

 STX SC+1               \ Set SC+1 = X, so now SC(1 0) = (X 0)

 TYA                    \ Set A = contents of (SC(1 0) + Y) EOR Y EOR &75
 EOR (SC),Y             \       = contents of ((X 0) + Y) EOR Y EOR &75
 EOR #&75               \       = contents of (X Y) EOR Y EOR &75

IF _REMOVE_CHECKSUMS

 NOP                    \ If we have disabled checksums, then don't update (X Y)
 NOP                    \ with the result, and just move on to the next byte

ELSE

 STA (SC),Y             \ Store the EOR'd value in SC(1 0) + Y, i.e. (X Y)

ENDIF

 DEY                    \ Decrement the loop counter to process the next byte

 BNE DEEL               \ Loop back until we have done the whole page

 INX                    \ Increment the page counter to point to the next page

 CPX #&A0               \ Loop back to do the next page until X = &A0, when
 BNE DEEL               \ (X Y) = &A000

 JMP BRKBK              \ Jump to BRKBK to set the standard BRKV handler for the
                        \ game and return from the subroutine using a tail call

