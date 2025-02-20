\ ******************************************************************************
\
\       Name: drverr
\       Type: Subroutine
\   Category: Save and load
\    Summary: Return from the RWTS code with a "Disk I/O error"
\  Deep dive: File operations with embedded Apple DOS
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   A                   The error number for the Disk I/O error (4)
\
\   C flag              The C flag is set
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   drver2              Restore the stack pointer and return from the RWTS code
\                       with the error number in A and the C flag set to
\                       indicate an error
\
\ ******************************************************************************

.drverr

 LDA #4                 \ Set A = 4 to return as the error number for the "Disk
                        \ I/O error"

.drver2

 LDX stkptr             \ Restore the value of the stack pointer from when we
 TXS                    \ first ran the RWTS code, to remove any return
                        \ addresses or values from the disk access routines
                        \ and make sure the RTS below returns from the RWTS
                        \ code

 SEC                    \ Set the C flag to denote that an error has occurred

 BCS rttrk4             \ Jump to rttrk4 to return from the RWTS code with the
                        \ error number in A and the error status in the C flag

