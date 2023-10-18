\ ******************************************************************************
\
\       Name: PrintLegalStatus
\       Type: Subroutine
\   Category: Status
\    Summary: Print the current legal status (clean, offender or fugitive)
\
\ ******************************************************************************

.PrintLegalStatus

 LDA #125               \ Print recursive token 125 ("LEGAL STATUS:) followed
 JSR spc                \ by a space

 LDA #19                \ Set A to token 133 ("CLEAN")

 LDY FIST               \ Fetch our legal status, and if it is 0, we are clean,
 BEQ st5                \ so jump to st5 to print "Clean"

 CPY #40                \ Set the C flag if Y >= 40, so C is set if we have
                        \ a legal status of 40+ (i.e. we are a fugitive)

 ADC #1                 \ Add 1 + C to A, so if C is not set (i.e. we have a
                        \ legal status between 1 and 49) then A is set to token
                        \ 134 ("OFFENDER"), and if C is set (i.e. we have a
                        \ legal status of 50+) then A is set to token 135
                        \ ("FUGITIVE")

.st5

 JMP plf                \ Print the text token in A (which contains our legal
                        \ status) followed by a newline, returning from the
                        \ subroutine using a tail call

