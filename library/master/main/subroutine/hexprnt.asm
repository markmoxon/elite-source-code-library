\ ******************************************************************************
\
\       Name: HEXPRNT
\       Type: Subroutine
\   Category: Text
\    Summary: Print a number in hexadecimal (unused)
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The number to print
\
\ ******************************************************************************

.HEXPRNT

 PHA                    \ Store A on the stack so we can grab the lower nibble
                        \ from it later

 LSR A                  \ Shift A right so that it contains the upper nibble
 LSR A                  \ of the original argument
 LSR A
 LSR A

 JSR HEXP               \ Call HEXP below to print 0-F for the upper nibble

 PLA                    \ Restore A from the stack

 AND #%00001111         \ Extract the lower nibble and fall through into HEXP
                        \ to print 0-F for the lower nibble

.HEXP

 CMP #10                \ If A >= 10, skip the next three instructions
 BCS P%+7

 ADC #'0'               \ A < 10, so print the number in A as a digit 0-9 and
 JMP CHPR               \ return from the subroutine using a tail call

 ADC #'6'               \ A >= 10, so print the number in A as a digit A-F and
 JMP CHPR               \ return from the subroutine using a tail call

