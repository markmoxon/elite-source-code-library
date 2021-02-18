\ ******************************************************************************
\
\       Name: PUTBACK
\       Type: Subroutine
\   Category: Tube
\    Summary: Reset the OSWRCH vector in WRCHV to point to USOSWRCH
\  Deep dive: 6502 Second Processor Tube communication
\
\ ******************************************************************************

.PUTBACK

 LDA #128               \ Set A = 128 to denote the first entry in JMPTAB, i.e.
                        \ USOSWRCH

                        \ Fall through into USOSWRCH to set WRCHV to the first
                        \ entry in JMPTAB - in other words, put WRCHV back to
                        \ its original value of USOSWRCH

