\ ******************************************************************************
\
\       Name: DKS4
\       Type: Subroutine
\   Category: Keyboard
\    Summary: Scan for a particular key press by sending a #DODKS4 command to
\             the I/O processor
\
\ ------------------------------------------------------------------------------
\
\ This routine sends a #DODKS4 command to the I/O processor to ask it to scan
\ the keyboard, to see if the key specified in X is currently being pressed.
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The internal number of the key to check
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   A                   If the key is being pressed, A contains the original
\                       key number in X but with bit 7 set (i.e. key number +
\                       128). If the key is not being pressed, A contains the
\                       unchanged key number
\
\ ******************************************************************************

.DKS4

 STX DKS4pars+2         \ Store the key number in byte #2 of the parameter block
                        \ below

 LDX #LO(DKS4pars)      \ Set (Y X) to point to the parameter block below
 LDY #HI(DKS4pars)

 LDA #DODKS4            \ Send a #DODKS4 command to the I/O processor to check
 JSR OSWORD             \ whether the key in byte #2 of the parameter block is
                        \ being pressed

 LDA DKS4pars+2         \ Fetch the result from byte#2 of the parameter block,
                        \ which will have bit 7 set if the key is being pressed

 RTS                    \ Return from the subroutine

.DKS4pars

 EQUB 3                 \ The number of bytes to transmit with this command

 EQUB 3                 \ The number of bytes to receive with this command

 EQUB 0                 \ The key number to check

 RTS                    \ End of the parameter block

