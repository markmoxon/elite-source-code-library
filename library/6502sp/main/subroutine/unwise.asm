\ ******************************************************************************
\
\       Name: UNWISE
\       Type: Subroutine
\   Category: Ship hanger
\    Summary: 
\
\ ------------------------------------------------------------------------------
\
\ This routine does nothing in the 6502 Second Processor version of Elite. It
\ does have a function in the disc version, so the authors presumably just
\ cleared out the UNWISE routine for the Second Processor version, rather than
\ unplumbing it from the code.
\
\ Other entry points:
\
\   HA1                 Contains an RTS
\
\ ******************************************************************************

.UNWISE

IF _DISC_VERSION

        LDA     &17EF   \ ????
        EOR     #$40
        STA     &17EF
        LDA     &181B
        EOR     #$40
        STA     &181B
        LDA     &189A
        EOR     #$40
        STA     &189A
        LDA     &18C6
        EOR     #$40
        STA     &18C6

ENDIF

.HA1

 RTS                    \ Return from the subroutine

