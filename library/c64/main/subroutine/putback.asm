\ ******************************************************************************
\
\       Name: PUTBACK
\       Type: Subroutine
\   Category: Tube
\    Summary: Reset the OSWRCH vector in WRCHV to point to USOSWRCH
\
\ ------------------------------------------------------------------------------
\
\ This routine is unused in this version of Elite (it is left over from the
\ 6502 Second Processor version).
\
\ ******************************************************************************

.PUTBACK

\LDA #128               \ This instruction is commented out in the original
                        \ source

 RTS                    \ Return from the subroutine

