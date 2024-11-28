\ ******************************************************************************
\
\       Name: DOCOL
\       Type: Subroutine
\   Category: Text
\    Summary: Implement the #SETCOL <colour> command (set the current colour)
\
\ ------------------------------------------------------------------------------
\
\ This routine is unused in this version of Elite (it is left over from the
\ 6502 Second Processor version).
\
\ ******************************************************************************

.DOCOL

 STA COL                \ Store the new colour in COL

 RTS                    \ Return from the subroutine

