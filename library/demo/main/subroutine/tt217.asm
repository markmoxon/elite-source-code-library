\ ******************************************************************************
\
\       Name: TT217
\       Type: Subroutine
\   Category: Keyboard
\    Summary: A cut-down and broken version of the TT217 routine
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   out                 Contains an RTS
\
\ ******************************************************************************

.TT217

 STY YSAV               \ Store Y in temporary storage, so we can restore it
                        \ later

 LDA #0                 \ ???

 TXA

.out

 RTS                    \ Return from the subroutine

