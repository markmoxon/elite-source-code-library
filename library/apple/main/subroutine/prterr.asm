\ ******************************************************************************
\
\       Name: prterr
\       Type: Subroutine
\   Category: Save and load
\    Summary: Return from the RWTS code with a "Disk write protected" error
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   A                   The error number for the Disk write protected error (1)
\
\   C flag              The C flag is set
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   drver2p             Restore the stack pointer and return from the RWTS code
\                       with the error number in A and the C flag set to
\                       indicate an error
\
\ ******************************************************************************

.prterr

 LDA #1                 \ Set A = 1 to return as the error number for the "Disk
                        \ write protected" error

 BPL drver2             \ Jump to drver2 to restore the stack pointer and
                        \ return from the RWTS code with an error number of 1
                        \ and the C flag set to indicate an error (this BPL is
                        \ effectively a JMP as A is always positive)

{
.drverr

 LDA #4                 \ This code is never called and is a copy of the drverr
                        \ label and instruction from the drverr routine, so we
                        \ need to put this in braces as BeebAsm doesn't allow
                        \ us to redefine labels, unlike BBC BASIC

}

.drver2p                \ This label is called drver2 in the original source,
                        \ which is already being used in the drverr routine, so
                        \ I have renamed it to drver2p

 LDX stkptr             \ Restore the value of the stack pointer from when we
 TXS                    \ first ran the RWTS code, to remove any return
                        \ addresses or values from the disk access routines
                        \ and make sure the RTS below returns from the RWTS
                        \ code

 LDX slot16             \ Set X to the disk controller card slot number * 16

 LDY mtroff,X           \ Read the disk controller I/O soft switch at MOTOROFF
                        \ for slot X to turn the disk motor off

 SEC                    \ Set the C flag to denote that an error has occurred

 RTS                    \ Return from the subroutine

