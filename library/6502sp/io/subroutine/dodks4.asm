\ ******************************************************************************
\
\       Name: DODKS4
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Implement the #DODKS4 command (scan the keyboard to see if a
\             specific key is being pressed)
\
\ ------------------------------------------------------------------------------
\
\ This routine is run when the parasite sends a #DODKS4 command with parameters
\ in the block at OSSC(1 0). It scans the keyboard to see if the specified key
\ is being pressed.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   OSSC(1 0)           A parameter block as follows:
\
\                         * Byte #2 = The internal number of the key to check
\
\                       See p.142 of the Advanced User Guide for a list of
\                       internal key numbers
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   OSSC(1 0)           A parameter block as follows:
\
\                         * Byte #2 = If the key is being pressed, it contains
\                           the original key number from byte #2, but with bit 7
\                           set (i.e. key number + 128). If the key is not being
\                           pressed, it contains the unchanged key number
\
\ ******************************************************************************

.DODKS4

 LDY #2                 \ Fetch byte #2 from the block pointed to by OSSC, which
 LDA (OSSC),Y           \ contains the key to check, and store it in A

 DKS4                   \ Include macro DKS4 to check whether the key in A is
                        \ being pressed, and if it is, set bit 7 of A

 STA (OSSC),Y           \ Store the updated A in byte #2 of the block pointed to
                        \ by OSSC

 RTS                    \ Return from the subroutine

