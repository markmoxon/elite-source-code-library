\ ******************************************************************************
\
\       Name: SendBarPattsToPPU
\       Type: Subroutine
\   Category: PPU
\    Summary: Send pattern data for tiles 0-127 for the icon bar to the PPU,
\             split across multiple calls to the NMI handler if required
\
\ ------------------------------------------------------------------------------
\
\ Pattern data for icon bar patterns 0 to 63 is sent to both pattern table 0 and
\ 1 in the PPU, while pattern data for icon bar patterns 64 to 127 is sent to
\ pattern table 0 only (the latter is done via the SendBarPatts2ToPPU routine).
\
\ Arguments:
\
\   A                   A counter for the icon bar patterns to send to the PPU,
\                       which works its way from 0 to 128 as pattern data is
\                       sent to the PPU over successive calls to the NMI handler
\
\ ******************************************************************************

.SendBarPattsToPPU

 ASL A                  \ If bit 6 of A is set, then 64 < A < 128, so jump to
 BMI SendBarPatts2ToPPU \ SendBarPatts2ToPPU to send patterns 64 to 127 to
                        \ pattern table 0 in the PPU

                        \ If we get here then both bit 6 and bit 7 of A are
                        \ clear, so 0 < A < 64, so we now send patterns 0 to 63
                        \ to pattern table 0 and 1 in the PPU

 SUBTRACT_CYCLES 1297   \ Subtract 1297 from the cycle count

 BMI patn1              \ If the result is negative, jump to patn1 to stop
                        \ sending patterns in this VBlank, as we have run out of
                        \ cycles (we will pick up where we left off in the next
                        \ VBlank)

 JMP patn2              \ The result is positive, so we have enough cycles to
                        \ keep sending PPU data in this VBlank, so jump to patn2
                        \ to send the patterns

.patn1

 ADD_CYCLES 1251        \ Add 1251 to the cycle count

 JMP RTS1               \ Return from the subroutine (as RTS1 contains an RTS)

.patn2

 LDA #0                 \ Set the low byte of dataForPPU(1 0) to 0
 STA dataForPPU

 LDA barPatternCounter  \ Set Y = barPatternCounter * 8
 ASL A                  \
 ASL A                  \ And set the C flag to the overflow bit
 ASL A                  \
 TAY                    \ Note that in the above we shift bits 7 and 6 left out
                        \ out of A and discard them, but because we know that
                        \ 0 < barPatternCounter < 64, this has no effect

 LDA #%00000000         \ Set addr = %0000000C
 ROL A                  \
 STA addr               \ And clear the C flag (as it gets set to bit 7 of A)
                        \
                        \ So we now have the following:
                        \
                        \   (addr Y) = barPatternCounter * 8

 TYA                    \ Set (A X) = (addr Y) + PPU_PATT_0 + &50
 ADC #&50               \           = PPU_PATT_0 + &50 + barPatternCounter * 8
 TAX                    \
                        \ Starting with the low bytes

 LDA addr               \ And then the high bytes (this works because we know
 ADC #HI(PPU_PATT_0)    \ the low byte of PPU_PATT_0 is 0)

 STA PPU_ADDR           \ Set PPU_ADDR = (A X)
 STX PPU_ADDR           \           = PPU_PATT_0 + &50 + barPatternCounter * 8
                        \           = PPU_PATT_0 + (10 + barPatternCounter) * 8
                        \
                        \ So PPU_ADDR points to a pattern in PPU pattern table
                        \ 0, which is at address PPU_PATT_0 in the PPU
                        \
                        \ So it points to pattern 10 when barPatternCounter is
                        \ zero, and points to patterns 10 to 137 as
                        \ barPatternCounter increments from 0 to 127

 LDA iconBarImageHi     \ Set dataForPPU(1 0) = (iconBarImageHi 0) + (addr 0)
 ADC addr               \
 STA dataForPPU+1       \ This means that:
                        \
                        \   dataForPPU(1 0) + Y
                        \           = (iconBarImageHi 0) + (addr 0) + Y
                        \           = (iconBarImageHi 0) + (addr Y)
                        \           = (iconBarImageHi 0) + barPatternCounter * 8
                        \
                        \ We know that (iconBarImageHi 0) points to the current
                        \ icon bar's image data  aticonBarImage0, iconBarImage1,
                        \ iconBarImage2, iconBarImage3 or iconBarImage4
                        \
                        \ So dataForPPU(1 0) + Y points to the pattern within
                        \ the icon bar's image data that corresponds to pattern
                        \ number barPatternCounter, so this is the data that we
                        \ want to send to the PPU

 LDX #32                \ We now send 32 bytes to the PPU, which equates to four
                        \ patterns (as each pattern contains eight bytes)
                        \
                        \ We send 32 pattern bytes, starting from the Y-th byte
                        \ of dataForPPU(1 0), which corresponds to pattern
                        \ number barPatternCounter in dataForPPU(1 0)

.patn3

 LDA (dataForPPU),Y     \ Send the Y-th byte from dataForPPU(1 0) to the PPU
 STA PPU_DATA

 INY                    \ Increment the index in Y to point to the next byte
                        \ from dataForPPU(1 0)

 DEX                    \ Decrement the loop counter

 BEQ patn4              \ If the loop counter is now zero, jump to patn4 to exit
                        \ the loop

 JMP patn3              \ Loop back to send the next byte

.patn4

 LDA #0                 \ Set the low byte of dataForPPU(1 0) to 0
 STA dataForPPU

 LDA barPatternCounter  \ Set Y = barPatternCounter * 8
 ASL A                  \
 ASL A                  \ And set the C flag to the overflow bit
 ASL A                  \
 TAY                    \ Note that in the above we shift bits 7 and 6 left out
                        \ out of A and discard them, but because we know that
                        \ 0 < barPatternCounter < 64, this has no effect

 LDA #%00000000         \ Set addr = %0000000C
 ROL A                  \
 STA addr               \ And clear the C flag (as it gets set to bit 7 of A)
                        \
                        \ So we now have the following:
                        \
                        \   (addr Y) = barPatternCounter * 8

 TYA                    \ Set (A X) = (addr Y) + PPU_PATT_1 + &50
 ADC #&50               \           = PPU_PATT_1 + &50 + barPatternCounter * 8
 TAX                    \
                        \ Starting with the low bytes

 LDA addr               \ And then the high bytes (this works because we know
 ADC #HI(PPU_PATT_1)    \ the low byte of PPU_PATT_1 is 0)

 STA PPU_ADDR           \ Set PPU_ADDR = (A X)
 STX PPU_ADDR           \           = PPU_PATT_1 + &50 + barPatternCounter * 8
                        \           = PPU_PATT_1 + (10 + barPatternCounter) * 8
                        \
                        \ So PPU_ADDR points to a pattern in PPU pattern table
                        \ 1, which is at address PPU_PATT_1 in the PPU
                        \
                        \ So it points to pattern 10 when barPatternCounter is
                        \ zero, and points to patterns 10 to 137 as
                        \ barPatternCounter increments from 0 to 127

 LDA iconBarImageHi     \ Set dataForPPU(1 0) = (iconBarImageHi 0) + (addr 0)
 ADC addr               \
 STA dataForPPU+1       \ This means that:
                        \
                        \   dataForPPU(1 0) + Y
                        \           = (iconBarImageHi 0) + (addr 0) + Y
                        \           = (iconBarImageHi 0) + (addr Y)
                        \           = (iconBarImageHi 0) + barPatternCounter * 8
                        \
                        \ We know that (iconBarImageHi 0) points to the current
                        \ icon bar's image data  aticonBarImage0, iconBarImage1,
                        \ iconBarImage2, iconBarImage3 or iconBarImage4
                        \
                        \ So dataForPPU(1 0) + Y points to the pattern within
                        \ the icon bar's image data that corresponds to pattern
                        \ number barPatternCounter, so this is the data that we
                        \ want to send to the PPU

 LDX #32                \ We now send 32 bytes to the PPU, which equates to four
                        \ patterns (as each pattern contains eight bytes)
                        \
                        \ We send 32 pattern bytes, starting from the Y-th byte
                        \ of dataForPPU(1 0), which corresponds to pattern
                        \ number barPatternCounter in dataForPPU(1 0)

.patn5

 LDA (dataForPPU),Y     \ Send the Y-th byte from dataForPPU(1 0) to the PPU
 STA PPU_DATA

 INY                    \ Increment the index in Y to point to the next byte
                        \ from dataForPPU(1 0)

 DEX                    \ Decrement the loop counter

 BEQ patn6              \ If the loop counter is now zero, jump to patn6 to exit
                        \ the loop

 JMP patn5              \ Loop back to send the next byte

.patn6

 LDA barPatternCounter  \ Add 4 to barPatternCounter, as we just sent four tile
 CLC                    \ patterns
 ADC #4
 STA barPatternCounter

 JMP SendBarPattsToPPU  \ Loop back to the start of the routine to send another
                        \ four patterns to both PPU pattern tables

