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

 LDA #0                 \ In theory, this should return a value of zero from the
                        \ routine

 TXA                    \ However, it actually returns the value of X in A,
                        \ which makes no sense as X could be anything by this
                        \ point (perhaps this instruction should have been
                        \ changed to TAX instead?)
                        \
                        \ That said, this broken version TT217 is never reached
                        \ in the demo, as it is only called by TT214 and qv, and
                        \ neither of these are called because the demo never
                        \ sells cargo (TT214) or equips any lasers (qv)

.out

 RTS                    \ Return from the subroutine

