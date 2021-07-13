\ ******************************************************************************
\
\       Name: sell_yn
\       Type: Subroutine
\   Category: Text
\    Summary: Print a "Sell(Y/N)?" prompt and get a number from the keyboard
\
\ ------------------------------------------------------------------------------
\
\ The arguments and results for this routine are the same as for gnum.
\
\ Arguments:
\
\   QQ25                The maximum number allowed
\
\ Returns:
\
\   A                   The number entered
\
\   R                   Also contains the number entered
\
\   C flag              Set if the number is too large (> QQ25), clear otherwise
\
\ ******************************************************************************

.sell_yn

 LDA #205               \ Print recursive token 45 ("SELL")
 JSR TT27

 LDA #206               \ Print extended token 206 ("{all caps}(Y/N)?")
 JSR DETOK

                        \ Fall through into gnum to get a number from the
                        \ keyboard

