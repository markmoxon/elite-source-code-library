\ ******************************************************************************
\
\       Name: RR5
\       Type: Subroutine
\   Category: Text
\    Summary: Print a character in the text screen mode
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The character to print
\
\   X                   The text column to print at (the x-coordinate)
\
\   Y                   The line number to print on (the y-coordinate)
\
\ ******************************************************************************

.RR5

IF _IB_DISK OR _4AM_CRACK

 BIT UPTOG              \ If bit 7 of UPTOG is set, jump to RR7 to skip the
 BMI RR7                \ following, so we print both upper and lower case
                        \ letters

ELIF _SOURCE_DISK

 BIT UPTOG              \ If bit 7 of UPTOG is clear, jump to RR7 to skip the
 BPL RR7                \ following, so we print both upper and lower case
                        \ letters (so in the source disk variants, the default
                        \ setting is to display upper case letters only)

ENDIF

 CMP #'['               \ If the character in A is less than ASCII '[' then it
 BCC RR7                \ is already an upper case letter, so jump to RR7 to
                        \ skip the following

 SBC #&20               \ This is a lower case letter, so subtract &20 to
                        \ convert it to the upper case letter equivalent

.RR7

 ORA #128               \ Set bit 7 of the character number so that we print it
                        \ in normal video (i.e. white characters on a black
                        \ background)

 PHA                    \ Store the character to print on the stack so we can
                        \ retrieve it below

 LDA cellocl,Y          \ Use the cellocl lookup table to fetch the low byte of
 STA SC                 \ the address of text row Y in text screen memory and
                        \ store it in the low byte of SC(1 0)

 TYA                    \ Set A = 4 + (Y mod 8) / 2
 AND #7                 \
 LSR A                  \ This calculation converts the text row number into the
 CLC                    \ high byte of the address of character row Y in text
 ADC #4                 \ screen memory, so it's a way of calculating the HI()
 STA SC+1               \ equivalent of the cellocl table

 TXA                    \ Copy X into Y, so Y contains the text column where we
 TAY                    \ want to print the character

 PLA                    \ Set A to the character to print on the stack, which we
                        \ put on the stack above

 STA (SC),Y             \ Print the character in A into column X on the text row
                        \ at SC(1 0)

 JMP RR6                \ Jump back into the CHPR routine to move the text
                        \ cursor along and return from the subroutine

