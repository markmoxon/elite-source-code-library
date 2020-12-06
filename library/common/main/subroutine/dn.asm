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

 JSR TT162              \ Print a space

 LDA #119               \ Print recursive token 119 ("CASH:{cash} CR{crlf}")
 JSR spc                \ followed by a space

                        \ Fall through into dn2 to make a beep and delay for
                        \ 1 second before returning from the subroutine

