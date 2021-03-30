\ ******************************************************************************
\
\       Name: DECRYPT
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Decrypt a multi-page block of memory
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   FRIN(1 0)           The start address of the block to decrypt
\
\   (A Y)               The end address of the block to decrypt
\
\   X                   The decryption seed
\
\ ******************************************************************************

.DECRYPT

 STX T                  \ Store the decryption seed in T as our starting point

 STA SC+1               \ Set SC(1 0) = (A 0) to point to the start of page A,
 LDA #0                 \ so we can use SC(1 0) + Y as our pointer to the next
 STA SC                 \ byte to decrypt

.DEL

 LDA (SC),Y             \ Set A to the Y-th byte of SC(1 0)

 SEC                    \ Set A = A - T
 SBC T

 STA (SC),Y             \ Update the Y-th byte of SC to the new value in A

 STA T                  \ Update T with the new value in A

 TYA                    \ Set A to the current byte index in Y

 BNE P%+4               \ If A <> 0 then decrement the high byte of SC(1 0) to
 DEC SC+1               \ point to the previous page

 DEY                    \ Decrement the byte pointer

 CPY FRIN               \ Loop back to decrypt the next byte, until Y = the low
 BNE DEL                \ byte of FRIN(1 0), at which point we have decrypted a
                        \ whole page

 LDA SC+1               \ Check whether SC(1 0) matches FRIN(1 0) and loop back
 CMP FRIN+1             \ to decrypt the next byte until it does, at which point
 BNE DEL                \ we have decrypted the whole block

 RTS                    \ Return from the subroutine

