\ ******************************************************************************
\
\       Name: SOMEPROT
\       Type: Subroutine
\   Category: Copy protection
\    Summary: Implement the OSWORD 249 command (some copy protection)
\
\ ------------------------------------------------------------------------------
\
\ This routine is run when the parasite sends an OSWORD 249 command with a
\ parameter block at OSSC(1 0). The parameter block is empty when the command is
\ sent, and this routine copies the code between do65202 and end65C02 to the
\ parameter block, just after the two size bytes.
\
\ ******************************************************************************

.SOMEPROT

 LDY #2                 \ Set a counter in Y to go from 2 to 2 + protlen, so
                        \ we copy bytes from do65202 to end65C02 into byte #2
                        \ onwards in the parameter block pointed to by OSSC

.SMEPRTL

 LDA do65C02-2,Y        \ Copy the Y-th byte of do65202 to the Y+2-th byte of
 STA (OSSC),Y           \ the OSWORD parameter block

 INY                    \ Increment the loop counter

 CPY #protlen+2         \ Loop back to copy the next byte until we have copied
 BCC SMEPRTL            \ the whole of do65202 to end65C02 to the OSWORD block,
                        \ so it can be run by the parasite

 RTS                    \ Return from the subroutine

