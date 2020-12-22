\ ******************************************************************************
\
\       Name: DFAULT
\       Type: Subroutine
\   Category: Start and end
\    Summary: Reset the current commander data block to the last saved commander
\
\ ******************************************************************************

.DFAULT

 LDX #NT%+8             \ The size of the last saved commander data block is NT%
                        \ bytes, and it is preceded by the 8 bytes of the
                        \ commander name (seven characters plus a carriage
                        \ return). The commander data block at NAME is followed
                        \ by the commander data block, so we need to copy the
                        \ name and data from the "last saved" buffer at NA% to
                        \ the current commander workspace at NAME. So we set up
                        \ a counter in X for the NT% + 8 bytes that we want to
                        \ copy

.QUL1

 LDA NA%-1,X            \ Copy the X-th byte of NA%-1 to the X-th byte of
 STA NAME-1,X           \ NAME-1 (the -1 is because X is counting down from
                        \ NT% + 8 to 1)

 DEX                    \ Decrement the loop counter

 BNE QUL1               \ Loop back for the next byte of the commander data
                        \ block

 STX QQ11               \ X is 0 by the end of the above loop, so this sets QQ11
                        \ to 0, which means we will be showing a view without a
                        \ boxed title at the top (i.e. we're going to use the
                        \ screen layout of a space view in the following)

 JSR CHECK              \ Call the CHECK subroutine to calculate the checksum
                        \ for the current commander block at NA%+8 and put it
                        \ in A

 CMP CHK                \ Test the calculated checksum against CHK

IF _REMOVE_CHECKSUMS

 NOP                    \ If we have disabled checksums, then ignore the result
 NOP                    \ of the comparison and fall through into the next part

ELSE

 BNE P%-6               \ If commander check is enabled and the calculated
                        \ checksum does not match CHK, then loop back to repeat
                        \ the check - in other words, we enter an infinite loop
                        \ here, as the checksum routine will keep returning the
                        \ same incorrect value

ENDIF

\JSR BELL               \ This instruction is commented out in the original
                        \ source. It would make a standard system beep

 EOR #&A9               \ X = checksum EOR &A9
 TAX

 LDA COK                \ Set A to the competition flags in COK

 CPX CHK2               \ If X = CHK2, then skip the next instruction
 BEQ tZ

 ORA #%10000000         \ Set bit 7 of A to indicate this commander file has
                        \ been tampered with

.tZ

 ORA #4                 \ Set bit 2 of A to denote this is the 6502 second
                        \ processor version (which is the same bit as for the
                        \ disc version)

 STA COK                \ Store the updated competition flags in COK

 RTS                    \ Retirn from the subroutine

