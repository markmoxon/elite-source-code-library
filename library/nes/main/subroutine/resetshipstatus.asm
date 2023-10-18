\ ******************************************************************************
\
\       Name: ResetShipStatus
\       Type: Subroutine
\   Category: Flight
\    Summary: Reset the ship's speed, hyperspace counter, laser temperature,
\             shields and energy banks
\
\ ******************************************************************************

.ResetShipStatus

 LDA #0                 \ Reduce the speed to 0
 STA DELTA

 STA QQ22+1             \ Reset the on-screen hyperspace counter

 LDA #0                 \ Cool down the lasers completely
 STA GNTMP

 LDA #&FF               \ Recharge the forward and aft shields
 STA FSH
 STA ASH

 STA ENERGY             \ Recharge the energy banks

 RTS                    \ Return from the subroutine

