\ ******************************************************************************
\
\       Name: tapeerror
\       Type: Subroutine
\   Category: Save and load
\    Summary: Print either "TAPE ERROR" or "DISK ERROR"
\
\ ******************************************************************************

.tapeerror

 LDA #255               \ Print extended token 255 ("{cr}{currently selected
 JSR DETOK              \ media} ERROR")

 JSR t                  \ Scan the keyboard until a key is pressed, returning
                        \ the ASCII code in A and X

 JMP SVE                \ Jump to SVE to display the disk access menu and return
                        \ from the subroutine using a tail call

