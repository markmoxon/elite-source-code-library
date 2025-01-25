\ ******************************************************************************
\
\       Name: MSBARS
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Draw two horizontal lines as part of an indicator bar, from
\             (X1, Y1+1) to (X2, Y1+1) and (X1, Y1+2) to (X2, Y1+2)
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   Y1                  Y1 is incremented by 2
\
\ ******************************************************************************

.MSBARS

 JSR P%+3               \ Call the following instruction as a subroutine, to
                        \ draw a line from (X1, Y1+1) to (X2, Y1+1), and then
                        \ fall through to draw another line from (X1, Y1+2) to
                        \ (X2, Y1+2), as Y1 is incremented each time

 INC Y1                 \ Increment Y1 and fall through into HLOIN to draw a
                        \ horizontal line from (X1, Y1) to (X2, Y1)

