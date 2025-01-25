\ ******************************************************************************
\
\       Name: rttrk3
\       Type: Subroutine
\   Category: Save and load
\    Summary: Successfully return from the RWTS code with no error reported
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   A                   The error number for no error (0)
\
\   C flag              The C flag is clear
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   rttrk4              Turn off the disk motor and return from the RWTS code
\                       with the error number in A and the error status in the
\                       C flag
\
\ ******************************************************************************

.rttrk3

 LDA #0                 \ Set A = 0 to indicate there is no error

 CLC                    \ Clear the C flag to indicate there is no disk error

.rttrk4

 LDX slot16             \ Set X to the disk controller card slot number * 16

 LDY mtroff,X           \ Read the disk controller I/O soft switch at MOTOROFF
                        \ for slot X to turn the disk motor off

 RTS                    \ Return from the subroutine

