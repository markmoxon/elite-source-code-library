\ ******************************************************************************
\
\       Name: SETL1
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Set the 6510 input/output port register to control the memory map
\
\ ------------------------------------------------------------------------------
\
\ See page 260 of the Programmer's Reference Guide for details on how the 6510
\ input/output port register works.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The new value of the input/output port register:
\
\                         * Bit 0 controls LORAM
\
\                         * Bit 1 controls HIRAM
\
\                         * Bit 2 controls CHAREN
\
\ ******************************************************************************

.SETL1

 SEI                    \ Disable interrupts while we set the 6510 input/output
                        \ port register

 STA L1M                \ Store the new value of the port register in L1M

 LDA l1                 \ Set bits 0 to 2 of the port register at location l1
 AND #%11111000         \ (&0001) to bits 0 to 2 of L1M, leaving bits 3 to 7
 ORA L1M                \ unchanged
 STA l1                 \
                        \ This sets LORAM, HIRAM and CHAREN to the new values

 CLI                    \ Re-enable interrupts

 RTS                    \ Return from the subroutine

