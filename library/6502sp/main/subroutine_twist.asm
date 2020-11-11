\ ******************************************************************************
\       Name: TWIST
\ ******************************************************************************

.TWIST2

 EQUB &2C

.TWIST

 LDA #0
 STA RAT2

 LDX #15                \ Rotate (roofv_x, nosev_x) by a small angle (pitch)
 LDY #9
 JSR MVS5

 LDX #17                \ Rotate (roofv_y, nosev_y) by a small angle (pitch)
 LDY #11
 JSR MVS5

 LDX #19                \ Rotate (roofv_z, nosev_z) by a small angle (pitch)
 LDY #13
 JMP MVS5

