\ ******************************************************************************
\
\       Name: crunchit
\       Type: Subroutine
\   Category: Copy protection
\    Summary: Multi-byte decryption and copying routine
\
\ ------------------------------------------------------------------------------
\
\ In the unprotected version of the loader on this site, this routine just moves
\ data frommone location to another. In the protected version, it also decrypts
\ the data as it is moved, but that part is disabled in the following.
\
\ Arguments:
\
\   (X Y)               The number of bytes to copy
\
\   ZP(1 0)             The source address
\
\   P(1 0)              The destination address
\
\ ******************************************************************************

.crunchit

 LDA (ZP),Y             \ Copy the Y-th byte of ZP(1 0) to the Y-th byte of
 NOP                    \ P(1 0), without any decryption (hence the NOPs)
 NOP
 NOP
 STA (P),Y

 DEY                    \ Decrement the byte counter

 BNE crunchit           \ Loop back to crunchit to copy the next byte until we
                        \ have done a whole page

 INC P+1                \ Increment the high bytes of the source and destination
 INC ZP+1               \ addresses so we can copy the next page

 DEX                    \ Decrement the page counter

 BNE crunchit           \ Loop back to crunchit to copy the next page until we
                        \ have done X pages

 RTS                    \ Return from the subroutine

