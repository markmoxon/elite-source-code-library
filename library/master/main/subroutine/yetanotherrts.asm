\ ******************************************************************************
\
\       Name: yetanotherrts
\       Type: Subroutine
\   Category: Tactics
\    Summary: Contains an RTS
\
\ ------------------------------------------------------------------------------
\
\ This routine contains an RTS so we can return from the SFRMIS subroutine with
\ a branch instruction.
\
\ It also contains the DEMON label, which implements the demo in the 6502
\ Second Processor version, so this presumably acted as a stub for the JSR DEMON
\ call during conversion of the 6502 Second Processor version into the later
\ BBC Master version.
\
\ Other entry points:
\
\   DEMON               Contains an RTS
\
\ ******************************************************************************

.yetanotherrts

.DEMON

 RTS                    \ Return from the subroutine

