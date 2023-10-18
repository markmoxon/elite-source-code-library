\ ******************************************************************************
\
\       Name: PrintSpaceViewName
\       Type: Subroutine
\   Category: Text
\    Summary: Print the name of the current space view
\
\ ******************************************************************************

.PrintSpaceViewName

 LDA VIEW               \ Load the current view into A:
                        \
                        \   0 = front
                        \   1 = rear
                        \   2 = left
                        \   3 = right

 ORA #&60               \ OR with &60 so we get a value of &60 to &63 (96 to 99)

 JMP TT27_b2            \ Print recursive token 96 to 99, which will be in the
                        \ range "FRONT" to "RIGHT", returning from the
                        \ subroutine using a tail call

