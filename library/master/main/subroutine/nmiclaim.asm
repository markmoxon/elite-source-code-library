\ ******************************************************************************
\
\       Name: NMICLAIM
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Claim the NMI workspace (&00A0 to &00A7) back from the MOS so the
\             game can use it once again
\
\ ******************************************************************************

IF _COMPACT

.NMICLAIM

 LDA #143               \ Call OSBYTE 143 to issue a paged ROM service call of
 LDX #&C                \ type &C with argument &FF, which is the "NMI claim"
 LDY #&FF               \ service call that asks the current user of the NMI
 JSR OSBYTE             \ space to clear it out

 STY NMI                \ Save the returned value of Y in NMI, as it contains
                        \ the filing system ID of the previous claimant of the
                        \ NMI, which we need to restore once we have finished
                        \ using the NMI workspace

 RTS                    \ Return from the subroutine

ENDIF

