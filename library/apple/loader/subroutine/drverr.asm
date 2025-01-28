\ ******************************************************************************
\
\       Name: drverr
\       Type: Subroutine
\   Category: Save and load
\    Summary: Return from the RWTS code with a "Disk I/O error"
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   A                   The error number for the Disk I/O error (4)
\
\   C flag              The C flag is set
\
\ ******************************************************************************

.drverr

 PLP                    \ Pull the read/write status off the stack as we don't
                        \ need it there any more

 LDY mtroff,X           \ Read the disk controller I/O soft switch at MOTOROFF
                        \ for slot X to turn the disk motor off

 SEC                    \ Set the C flag to denote that an error has occurred

 LDA #4                 \ Set A = 4 to return as the error number for the "Disk
                        \ I/O error"

 RTS                    \ Return from the subroutine

