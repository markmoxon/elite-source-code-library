\ ******************************************************************************
\
\       Name: buy_invnt
\       Type: Subroutine
\   Category: Buying ships
\    Summary: Process key presses in the encyclopedia
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The ASCII value of the key pressed, minus ASCII "0"
\
\ ******************************************************************************

.buy_invnt

 SBC #(128 - '0')       \ We already subtracted ASCII "0" from the ASCII value
                        \ of the key pressed, so this subtracts 128 from the
                        \ original ASCII value of the key pressed. As red key f0
                        \ is given ASCII value 128, and f1 is 129 and so on,
                        \ this reduces a key press of f0 to A = 0, a key press
                        \ of f1 to A = 1, and so on

 BCC buy_top            \ If the subtraction just underflowed, then the key
                        \ pressed was not a red function key, so jump to buy_top
                        \ to "press" red key f1 (Encyclopedia screen)

 CMP #10                \ If A < 10, then the key pressed was a red function
 BCC buy_func           \ key, so jump to buy_func so we press the red key whose
                        \ number is in A (so A = 0 "presses" red key f0, A = 1
                        \ "presses" red key f1, and so on)

                        \ Otherwise A >= 10, so the key pressed is something
                        \ else, so fall through into buy_top to "press" red key
                        \ f1 (Encyclopedia screen)

.buy_top

 LDA #1                 \ Set A = 1 so we "press" red key f1 (Encyclopedia
                        \ screen) in the following

.buy_func

 TAX                    \ Jump into the main loop at FRCE, setting the key to
 LDA func_tab,X         \ the X-th red key (so X = 0 "presses" red key f0, X = 1
 JMP FRCE               \ "presses" red key f1, and so on)

