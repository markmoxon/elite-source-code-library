\ ******************************************************************************
\
\       Name: dn
\       Type: Subroutine
\   Category: Text
\    Summary: Print the amount of cash and beep
\
\ ------------------------------------------------------------------------------
\
\ Print the amount of money in the cash pot, then make a short, high beep and
\ delay for 1 second.
\
\ ******************************************************************************

.dn

IF NOT(_NES_VERSION)

 JSR TT162              \ Print a space

 LDA #119               \ Print recursive token 119 ("CASH:{cash} CR{crlf}")
 JSR spc                \ followed by a space

                        \ Fall through into dn2 to make a beep and delay for
                        \ 1 second before returning from the subroutine

ELIF _NES_VERSION

 LDA #17                \ Move the text cursor to column 2 on row 17
 STA YC
 LDA #2
 STA XC

 JMP PCASH              \ Jump to PCASH to print recursive token 119
                        \ ("CASH:{cash} CR{crlf}"), followed by a space, and
                        \ return from the subroutine using a tail call

ENDIF

