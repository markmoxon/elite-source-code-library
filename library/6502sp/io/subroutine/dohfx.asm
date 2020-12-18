\ ******************************************************************************
\
\       Name: DOHFX
\       Type: Subroutine
\   Category: Drawing circles
\    Summary: Implement the #DOHFX <flag> command (update the hyperspace effect
\             flag)
\
\ ------------------------------------------------------------------------------
\
\ This routine is run when the parasite sends a #DOHFX <flag> command. It
\ updates the hyperspace effect flag in HFX.
\
\ Arguments:
\
\   A                   The new value of the hyperspace effect flag:
\
\                         * 0 = no colour effect
\
\                         * Non-zero = enable hyperspace colour effect
\
\ ******************************************************************************

.DOHFX

 STA HFX                \ Store the new hyperspace effect flag in HFX

 JMP PUTBACK            \ Jump to PUTBACK to restore the USOSWRCH handler and
                        \ return from the subroutine using a tail call

