\ ******************************************************************************
\
\       Name: DEEORS
\       Type: Subroutine
\   Category: Loader
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

.DEEORS

 STX ZP2                \ Store the decryption seed in ZP2 as our starting point

 STA ZP+1               \ Set ZP(1 0) = (A 0) to point to the start of page A,
 LDA #0                 \ so we can use ZP(1 0) + Y as our pointer to the next
 STA ZP                 \ byte to decrypt

.DEEORL

 LDA (ZP),Y             \ Set A to the Y-th byte of ZP(1 0)

 SEC                    \ Set A = A - ZP2
 SBC ZP2

 STA (ZP),Y             \ Update the Y-th byte of ZP to the new value in A

 STA ZP2                \ Update ZP2 with the new value in A

 TYA                    \ Set A to the current byte index in Y

 BNE P%+4               \ If A <> 0 then decrement the high byte of ZP(1 0) to
 DEC ZP+1               \ point to the previous page

 DEY                    \ Decrement the byte pointer

 CPY FRIN               \ Loop back to decrypt the next byte, until Y = the low
 BNE DEEORL             \ byte of FRIN(1 0), at which point we have decrypted a
                        \ whole page

 LDA ZP+1               \ Check whether ZP(1 0) matches FRIN(1 0) and loop back
 CMP FRIN+1             \ to decrypt the next byte until it does, at which point
 BNE DEEORL             \ we have decrypted the whole block

 RTS                    \ Return from the subroutine

