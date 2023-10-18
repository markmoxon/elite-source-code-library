\ ******************************************************************************
\
\       Name: UpdateNMITimer
\       Type: Subroutine
\   Category: Utility routines
\    Summary: Update the NMI timer, which we can use in place of hardware
\             timers (which the NES does not support)
\
\ ******************************************************************************

.UpdateNMITimer

 DEC nmiTimer           \ Decrement the NMI timer counter, so that it counts
                        \ each NMI interrupt

 BNE nmit1              \ If it hasn't reached zero yet, jump to nmit1 to return
                        \ from the subroutine

 LDA #50                \ Wrap the NMI timer round to start counting down from
 STA nmiTimer           \ 50 once again, as it just reached zero

 LDA nmiTimerLo         \ Increment (nmiTimerHi nmiTimerLo)
 CLC
 ADC #1
 STA nmiTimerLo
 LDA nmiTimerHi
 ADC #0
 STA nmiTimerHi

.nmit1

 RTS                    \ Return from the subroutine

