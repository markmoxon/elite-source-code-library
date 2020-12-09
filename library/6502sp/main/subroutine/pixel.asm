\ ******************************************************************************
\       Name: PIXEL
\ ******************************************************************************

.PIXEL

 STY T1
 LDY PBUP
 STA PBUF+2,Y
 TXA
 STA PBUF+1,Y
 LDA ZZ
 AND #&F8
 STA PBUF,Y
 TYA
 CLC
 ADC #3
 STA PBUP
 BMI PBFL
 LDY T1

.PX4

 RTS

.PBFL

 LDA PBUP               \ Set the first byte in pixbl (the number of bytes to
 STA pixbl              \ transmit with the OSWORD 241 command) to PBUP

 CMP #2                 \ If PBUP = 2 then jump to PBZE2 as there is no pixel
 BEQ PBZE2              \ data to transmit to the I/O processor

 LDA #2                 \ Set PBUP = 2 to reset the pixel buffer
 STA PBUP

 LDA #DUST              \ Send a #SETCOL DUST command to the I/O processor to
 JSR DOCOL              \ switch to stripe 3-2-3-2, which is cyan/red in the
                        \ space view

 LDA #241               \ Send an OSWORD 241 command to the I/O processor to
 LDX #LO(pixbl)         \ draw the pixel described in the pixbl block
 LDY #HI(pixbl)
 JSR OSWORD

.PBZE2

 LDY T1
 RTS

.PBZE

 LDA #2
 STA PBUP
 RTS

