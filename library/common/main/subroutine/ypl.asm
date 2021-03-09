\ ******************************************************************************
\
\       Name: ypl
\       Type: Subroutine
\   Category: Text
\    Summary: Print the current system name
\
\ ------------------------------------------------------------------------------
\
\ Print control code 2 (the current system name).
\
\ ******************************************************************************

.ypl

IF _CASSETTE_VERSION \ Enhanced: If we jump into witchspace, the disc version still displays the original system name as the "Present system" in the Status Mode screen, while the cassette and 6502SP versions just show a blank name

 LDA MJ                 \ Check the mis-jump flag at MJ, and if it is non-zero
 BNE cmn-1              \ then we are in witchspace, and witchspace doesn't have
                        \ a system name, so return from the subroutine (cmn-1
                        \ contains an RTS)

ELIF _6502SP_VERSION

 BIT MJ                 \ Check the mis-jump flag at MJ, and if bit 7 is set
 BMI ypl16              \ then we are in witchspace, and witchspace doesn't have
                        \ a system name, so jump to ypl16 to return from the
                        \ subroutine

ENDIF

 JSR TT62               \ Call TT62 below to swap the three 16-bit seeds in
                        \ QQ2 and QQ15 (before the swap, QQ2 contains the seeds
                        \ for the current system, while QQ15 contains the seeds
                        \ for the selected system)

 JSR cpl                \ Call cpl to print out the system name for the seeds
                        \ in QQ15 (which now contains the seeds for the current
                        \ system)

                        \ Now we fall through into the TT62 subroutine, which
                        \ will swap QQ2 and QQ15 once again, so everything goes
                        \ back into the right place, and the RTS at the end of
                        \ TT62 will return from the subroutine

.TT62

 LDX #5                 \ Set up a counter in X for the three 16-bit seeds we
                        \ want to swap (i.e. 6 bytes)

.TT78

 LDA QQ15,X             \ Swap byte X between QQ2 and QQ15
 LDY QQ2,X
 STA QQ2,X
 STY QQ15,X

 DEX                    \ Decrement the loop counter

 BPL TT78               \ Loop back for the next byte to swap

IF _6502SP_VERSION \ Label

.ypl16

ENDIF

 RTS                    \ Once all bytes are swapped, return from the
                        \ subroutine

