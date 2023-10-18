\ ******************************************************************************
\
\       Name: PrintCash
\       Type: Subroutine
\   Category: Market
\    Summary: Print our cash levels in the correct place for the chosen language
\
\ ******************************************************************************

.PrintCash

 LDA #%10000000         \ Set bit 7 of QQ17 to switch standard tokens to
 STA QQ17               \ Sentence Case

 LDX languageIndex      \ Move the text cursor to the correct row for the chosen
 LDA yCash,X            \ language, as given in the yCash table
 STA YC

 LDA xCash,X            \ Move the text cursor to the correct column for the
 STA XC                 \ chosen, as given in the xCash table

 JMP PCASH              \ Jump to PCASH to print recursive token 119
                        \ ("CASH:{cash} CR{crlf}"), followed by a space, and
                        \ return from the subroutine using a tail call

