\ ******************************************************************************
\
\       Name: TT41
\       Type: Subroutine
\   Category: Text
\    Summary: Print a letter according to Sentence Case
\
\ ------------------------------------------------------------------------------
\
\ The rules for printing in Sentence Case are as follows:
\
\   * If QQ17 bit 6 is set, print lower case (via TT45)
\
\   * If QQ17 bit 6 clear, then:
\
\       * If character is punctuation, just print it
\
\       * If character is a letter, set QQ17 bit 6 and print letter as a capital
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
\   QQ17                Bit 7 is set
\
\ ******************************************************************************

.TT41

                        \ If we get here, then QQ17 has bit 7 set, so we are in
                        \ Sentence Case

 BIT QQ17               \ If QQ17 also has bit 6 set, jump to TT45 to print
 BVS TT45               \ this character in lower case

                        \ If we get here, then QQ17 has bit 6 clear and bit 7
                        \ set, so we are in Sentence Case and we need to print
                        \ the next letter in upper case

 CMP #'A'               \ If A < ASCII "A", then this is punctuation, so jump
 BCC TT74               \ to TT26 (via TT44) to print the character as is, as
                        \ we don't care about the character's case

 PHA                    \ Otherwise this is a letter, so store the token number

 TXA                    \ Set bit 6 in QQ17 (X contains the current QQ17)
 ORA #%1000000          \ so the next letter after this one is printed in lower
 STA QQ17               \ case

 PLA                    \ Restore the token number into A

 BNE TT44               \ Jump to TT26 (via TT44) to print the character in A
                        \ (this BNE is effectively a JMP as A will never be
                        \ zero)

