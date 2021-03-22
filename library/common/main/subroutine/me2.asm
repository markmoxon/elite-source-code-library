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

 LDA QQ11               \ ???
 BNE L63D9

ENDIF

 LDA MCH                \ Fetch the token number of the current message into A

 JSR MESS               \ Call MESS to print the token, which will remove it
                        \ from the screen as printing uses EOR logic

 LDA #0                 \ Set the delay in DLY to 0, so any new in-flight
 STA DLY                \ messages will be shown instantly

 JMP me3                \ Jump back into the main spawning loop at TT100

IF _MASTER_VERSION

.L63D9

 JSR CLYNS              \ ???

 JMP me3                \ Jump back into the main spawning loop at TT100

ENDIF