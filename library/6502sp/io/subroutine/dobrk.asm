\ ******************************************************************************
\
\       Name: DOBRK
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Implement the OSWRCH 145 command (execute a BRK instruction)
\
\ ------------------------------------------------------------------------------
\
\ This command doesn't appear to be used, but it would execute a BRK on the I/O
\ processor, causing a call to BRKV. This typically  points to BRBR or MEBRK,
\ both of which print out the current system error, if there is one.
\
\ ******************************************************************************

.DOBRK

 BRK                    \ Execute a BRK instruction

 EQUS "TTEST"           \ A carriage-return-terminated test string, which
 EQUB 13                \ doesn't appear to be used anywhere

 BRK                    \ End of the test string

