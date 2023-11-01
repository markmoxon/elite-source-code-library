\ ******************************************************************************
\
\       Name: SendBarPatts2ToPPU
\       Type: Subroutine
\   Category: PPU
\    Summary: Send pattern data for tiles 64-127 for the icon bar to the PPU,
\             split across multiple calls to the NMI handler if required
\  Deep dive: Drawing vector graphics using NES tiles
\
\ ------------------------------------------------------------------------------
\
\ Pattern data for icon bar patterns 64 to 127 is sent to PPU pattern table 0
\ only.
\
\ ******************************************************************************

.SendBarPatts2ToPPU

 SUBTRACT_CYCLES 666    \ Subtract 666 from the cycle count

 BMI patt1              \ If the result is negative, jump to patt1 to stop
                        \ sending patterns in this VBlank, as we have run out of
                        \ cycles (we will pick up where we left off in the next
                        \ VBlank)

 JMP patt2              \ The result is positive, so we have enough cycles to
                        \ keep sending PPU data in this VBlank, so jump to patt2
                        \ to send the patterns

.patt1

 ADD_CYCLES 623         \ Add 623 to the cycle count

 JMP RTS1               \ Return from the subroutine (as RTS1 contains an RTS)

.patt2

 LDA #0                 \ Set the low byte of dataForPPU(1 0) to 0
 STA dataForPPU

 LDA barPatternCounter  \ Set Y = (barPatternCounter mod 64) * 8
 ASL A                  \
 ASL A                  \ And set the C flag to the overflow bit
 ASL A                  \
 TAY                    \ The mod 64 part comes from the fact that we shift bits
                        \ 7 and 6 left out of A and discard them, so this is the
                        \ same as (barPatternCounter AND %00111111) * 8

 LDA #%00000001         \ Set addr = %0000001C
 ROL A                  \
 STA addr               \ And clear the C flag (as it gets set to bit 7 of A)
                        \
                        \ So we now have the following:
                        \
                        \   (addr Y) = (2 0) + (barPatternCounter mod 64) * 8
                        \            = &0200 + (barPatternCounter mod 64) * 8
                        \            = 64 * 8 + (barPatternCounter mod 64) * 8
                        \            = (64 + barPatternCounter mod 64) * 8
                        \
                        \ We only call this routine when this is true:
                        \
                        \   64 < barPatternCounter < 128
                        \
                        \ in which case we know that:
                        \
                        \   64 + barPatternCounter mod 64 = barPatternCounter
                        \
                        \ So we if we substitute this into the above, we get:
                        \
                        \   (addr Y) = (10 + 64 + barPatternCounter mod 64) * 8
                        \            = barPatternCounter * 8

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
 STA dataForPPU+1       \ We know from above that:
                        \
                        \   (addr Y) = &0200 + (barPatternCounter mod 64) * 8
                        \            = 64 * 8 + (barPatternCounter mod 64) * 8
                        \            = (64 + barPatternCounter mod 64) * 8
                        \            = barPatternCounter * 8
                        \
                        \ So this means that:
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

.patt3

 LDA (dataForPPU),Y     \ Send the Y-th byte from dataForPPU(1 0) to the PPU
 STA PPU_DATA

 INY                    \ Increment the index in Y to point to the next byte
                        \ from dataForPPU(1 0)

 DEX                    \ Decrement the loop counter

 BEQ patt4              \ If the loop counter is now zero, jump to patt4 to exit
                        \ the loop

 JMP patt3              \ Loop back to send the next byte

.patt4

 LDA barPatternCounter  \ Add 4 to barPatternCounter, as we just sent four tile
 CLC                    \ patterns
 ADC #4
 STA barPatternCounter

 BPL SendBarPatts2ToPPU \ If barPatternCounter < 128, loop back to the start of
                        \ the routine to send another four patterns

 JMP ConsiderSendTiles  \ Jump to ConsiderSendTiles to start sending tiles to
                        \ the PPU, but only if there are enough free cycles

