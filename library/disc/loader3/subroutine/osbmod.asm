\ ******************************************************************************
\
\       Name: OSBmod
\       Type: Subroutine
\   Category: Copy protection
\    Summary: Calculate a checksum on &0F00 to &0FFF (the test is disabled in
\             this version)
\
\ ******************************************************************************

.OSBmod

 SEC                    \ Set the C flag so the checksum we calculate in A
                        \ starts with an initial value of 16 (15 plus carry)

 LDY #&00               \ Set ZP(1 0) = &0F00
 STY ZP                 \
 LDA #&0F               \ and at the same time set a byte counter in Y and set
 STA ZP+1               \ the initial value of the checksum to 16 (15 plus
                        \ carry)

.osb1

 ADC (ZP),Y             \ Set A = A + the Y-th byte of ZP(1 0)

 INY                    \ Increment the byte pointer

 BNE osb1               \ Loop back to add the next byte until we have added the
                        \ whole page

IF _STH_DISC OR _IB_DISC

 CMP #&CF               \ The checksum test has been disabled
 NOP
 NOP

ELIF _SRAM_DISC

 CMP #&CF               \ The checksum test has been disabled

 BNE OSBmod             \ ???

ENDIF

 LDA #219               \ Store 219 in location &9F. This gets checked by the
 STA &9F                \ TITLE routine in the main docked code as part of the
                        \ copy protection (the game hangs if it doesn't match)

 RTS                    \ Return from the subroutine

