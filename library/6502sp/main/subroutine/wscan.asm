\ ******************************************************************************
\
\       Name: WSCAN
\       Type: Subroutine
\   Category: Screen mode
\    Summary: Ask the I/O processor to wait for the vertical sync by sending a
\             #wscn command to the I/O processor
\
\ ------------------------------------------------------------------------------
\
\ This routine sends a #wscn command to the I/O processor to ask it to wait for
\ the vertical sync.
\
\ ******************************************************************************

.WSCpars

 EQUB 2                 \ Transmit 2 bytes as part of this command

 EQUB 2                 \ Receive 2 bytes as part of this command

 EQUW 0                 \ This is unused as no parameters are transmitted along
                        \ with this command

.WSCAN

 PHX                    \ Store X and Y on the stack so we can restore them
 PHY                    \ later

 LDA #wscn              \ Set A in preparation for sending a #wscn command

 LDX #LO(WSCpars)       \ Set (Y X) to point to the parameter block above
 LDY #HI(WSCpars)

 JSR OSWORD             \ Send a #wscn command to the I/O processor to wait for
                        \ the vertical sync

 PLY                    \ Restore X and Y from the stack
 PLX

 RTS                    \ Return from the subroutine

