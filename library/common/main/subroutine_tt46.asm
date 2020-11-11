\ ******************************************************************************
\
\       Name: TT46
\       Type: Subroutine
\   Category: Text
\    Summary: Print a character and switch to capitals
\
\ ------------------------------------------------------------------------------
\
\ Print a character and clear bit 6 in QQ17, so that the next letter that gets
\ printed after this will start with a capital letter.
\
\ Arguments:
\
\   A                   The character to be printed. Can be one of the
\                       following:
\
\                         * 7 (beep)
\
\                         * 10-13 (line feeds and carriage returns)
\
\                         * 32-95 (ASCII capital letters, numbers and
\                           punctuation)
\
\   X                   Contains the current value of QQ17
\
\   QQ17                Bits 6 and 7 are set
\
\ ******************************************************************************

.TT46

 PHA                    \ Store the token number

 TXA                    \ Clear bit 6 in QQ17 (X contains the current QQ17) so
 AND #%10111111         \ the next letter after this one is printed in upper
 STA QQ17               \ case

 PLA                    \ Restore the token number into A

                        \ Now fall through into TT74 to print the character

