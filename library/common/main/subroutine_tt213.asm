\ ******************************************************************************
\
\       Name: TT213
\       Type: Subroutine
\   Category: Inventory
\    Summary: Show the Inventory screen (red key f9)
\
\ ******************************************************************************

.TT213

IF _CASSETTE_VERSION

 LDA #8                 \ Clear the top part of the screen, draw a white border,
 JSR TT66               \ and set the current view type in QQ11 to 8 (Inventory
                        \ screen)

 LDA #11                \ Move the text cursor to column 11 to print the screen
 STA XC                 \ title

ELIF _6502SP_VERSION

 LDA #8
 JSR TRADEMODE

 LDA #11
 JSR DOXC

ENDIF

 LDA #164               \ Print recursive token 4 ("INVENTORY{crlf}") followed
 JSR TT60               \ by a paragraph break and Sentence Case

 JSR NLIN4              \ Draw a horizontal line at pixel row 19 to box in the
                        \ title. The authors could have used a call to NLIN3
                        \ instead and saved the above call to TT60, but you
                        \ just can't optimise everything

 JSR fwl                \ Call fwl to print the fuel and cash levels on two
                        \ separate lines

 LDA CRGO               \ If our ship's cargo capacity is < 26 (i.e. we do not
 CMP #26                \ have a cargo bay extension), skip the following two
 BCC P%+7               \ instructions

 LDA #107               \ We do have a cargo bay extension, so print recursive
 JSR TT27               \ token 107 ("LARGE CARGO{switch to sentence case}
                        \ BAY")

 JMP TT210              \ Jump to TT210 to print the contents of our cargo bay
                        \ and return from the subroutine using a tail call

