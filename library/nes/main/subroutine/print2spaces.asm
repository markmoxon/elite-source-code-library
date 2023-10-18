\ ******************************************************************************
\
\       Name: Print2Spaces
\       Type: Subroutine
\   Category: Text
\    Summary: Print two spaces
\
\ ******************************************************************************

.Print2Spaces

 JSR TT162              \ Print two spaces, returning from the subroutine using
 JMP TT162              \ a tail call

