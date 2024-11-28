\ ******************************************************************************
\
\       Name: DOSVN
\       Type: Subroutine
\   Category: Save and load
\    Summary: Implement the #DOSVN <flag> command (update the "save in progress"
\             flag)
\
\ ------------------------------------------------------------------------------
\
\ This routine is unused in this version of Elite (it is left over from the
\ 6502 Second Processor version).
\
\ ******************************************************************************

.DOSVN

\STA svn                \ These instructions are commented out in the original
\JMP PUTBACK            \ source

