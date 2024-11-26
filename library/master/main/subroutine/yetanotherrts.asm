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
\ It also contains the DEMON label, which is left over from the 6502 Second
\ Processor version, where it implements the demo (there is no demo in this
\ version of Elite).
\
\ ******************************************************************************

.yetanotherrts

.DEMON

 RTS                    \ Return from the subroutine

