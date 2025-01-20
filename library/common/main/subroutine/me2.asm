\ ******************************************************************************
\
\       Name: me2
\       Type: Subroutine
\   Category: Flight
\    Summary: Remove an in-flight message from the space view
\
\ ******************************************************************************

.me2

IF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION \ Master: Group A: The Master version clears the bottom part of the screen when displaying in-flight messages in screens other than the space view, whereas the other versions messily superimpose the message over the current screen

 LDA QQ11               \ If this is not the space view, jump down to clynsneed
 BNE clynsneed          \ to skip displaying the in-flight message

ENDIF

 LDA MCH                \ Fetch the token number of the current message into A

 JSR MESS               \ Call MESS to print the token, which will remove it
                        \ from the screen as printing uses EOR logic

 LDA #0                 \ Set the delay in DLY to 0, so any new in-flight
 STA DLY                \ messages will be shown instantly

 JMP me3                \ Jump back into the main spawning loop at me3

IF _MASTER_VERSION OR _C64_VERSION \ Master: See group A

.clynsneed

 JSR CLYNS              \ Clear the bottom three text rows of the upper screen,
                        \ and move the text cursor to the first cleared row

 JMP me3                \ Jump back into the main spawning loop at me3

ELIF _APPLE_VERSION

.clynsneed

 JSR CLYNS              \ Clear two text rows at the bottom of the screen, and
                        \ move the text cursor to the first cleared row

 JMP me3                \ Jump back into the main spawning loop at me3

ENDIF