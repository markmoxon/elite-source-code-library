\ ******************************************************************************
\
\       Name: me2
\       Type: Subroutine
\   Category: Text
\    Summary: Remove an in-flight message from the space view
\
\ ******************************************************************************

.me2

IF _MASTER_VERSION

 LDA QQ11               \ If this is not the space view, jump down to nomess to
 BNE nomess             \ skip displaying the in-flight message

ENDIF

 LDA MCH                \ Fetch the token number of the current message into A

 JSR MESS               \ Call MESS to print the token, which will remove it
                        \ from the screen as printing uses EOR logic

 LDA #0                 \ Set the delay in DLY to 0, so any new in-flight
 STA DLY                \ messages will be shown instantly

 JMP me3                \ Jump back into the main spawning loop at TT100

IF _MASTER_VERSION

.nomess

 JSR CLYNS              \ Clear the bottom three text rows of the upper screen,
                        \ and move the text cursor to column 1 on row 21, i.e.
                        \ the start of the top row of the three bottom rows

 JMP me3                \ Jump back into the main spawning loop at TT100

ENDIF