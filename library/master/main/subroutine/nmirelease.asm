\ ******************************************************************************
\
\       Name: NMIRELEASE
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Release the NMI workspace (&00A0 to &00A7) so the MOS can use it
\             and store the top part of zero page in the buffer at &3000
\
\ ******************************************************************************

IF _COMPACT

.NMIRELEASE

 JSR getzp+3            \ Call getzp+3 to restore the top part of zero page
                        \ from the buffer at &3000, but without first claiming
                        \ the NMI workspace (as it's already been claimed by
                        \ this point)

 LDA #143               \ Call OSBYTE 143 to issue a paged ROM service call of
 LDX #&B                \ type &B with Y set to the previous NMI owner's ID.
 LDY NMI                \ This releases the NMI workspace back to the original
 JMP OSBYTE             \ owner, from whom we claimed the workspace in the
                        \ NMICLAIM routine, and returns from the subroutine
                        \ using a tail call

ENDIF

