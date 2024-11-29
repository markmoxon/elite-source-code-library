\ ******************************************************************************
\
\       Name: cls
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Clear the top part of the screen and draw a border box
\
\ ******************************************************************************

.cls

 JSR TTX66              \ Call TTX66 to clear the top part of the screen and
                        \ draw a border box

 JMP RR4                \ Jump to RR4 to restore X and Y from the stack and A
                        \ from K3, and return from the subroutine using a tail
                        \ call

