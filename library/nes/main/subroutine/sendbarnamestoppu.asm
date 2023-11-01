\ ******************************************************************************
\
\       Name: SendBarNamesToPPU
\       Type: Subroutine
\   Category: PPU
\    Summary: Send the nametable entries for the icon bar to the PPU
\  Deep dive: Drawing vector graphics using NES tiles
\
\ ------------------------------------------------------------------------------
\
\ Nametable data for the icon bar is sent to PPU nametables 0 and 1.
\
\ ******************************************************************************

.SendBarNamesToPPU

 SUBTRACT_CYCLES 2131   \ Subtract 2131 from the cycle count

 LDX iconBarRow         \ Set X to the low byte of iconBarRow(1 0), to use in
                        \ the following calculations

 STX dataForPPU         \ Set dataForPPU(1 0) = nameBuffer0 + iconBarRow(1 0)
 LDA iconBarRow+1       \
 CLC                    \ So dataForPPU(1 0) points to the entry in nametable
 ADC #HI(nameBuffer0)   \ buffer 0 for the start of the icon bar (the addition
 STA dataForPPU+1       \ works because the low byte of nameBuffer0 is 0)

 LDA iconBarRow+1       \ Set (A X) = PPU_NAME_0 + iconBarRow(1 0)
 ADC #HI(PPU_NAME_0)    \
                        \ The addition works because the low byte of PPU_NAME_0
                        \ is 0

 STA PPU_ADDR           \ Set PPU_ADDR = (A X)
 STX PPU_ADDR           \              = PPU_NAME_0 + iconBarRow(1 0)
                        \
                        \ So PPU_ADDR points to the tile entry in the PPU's
                        \ nametable 0 for the start of the icon bar

 LDY #0                 \ We now send the nametable entries for the icon bar to
                        \ the PPU's nametable 0, so set a counter in Y

.ibar1

 LDA (dataForPPU),Y     \ Send the Y-th nametable entry from dataForPPU(1 0) to
 STA PPU_DATA           \ the PPU

 INY                    \ Increment the loop counter

 CPY #2*32              \ Loop back until we have sent 2 rows of 32 tiles
 BNE ibar1

 LDA iconBarRow+1       \ Set (A X) = PPU_NAME_1 + iconBarRow(1 0)
 ADC #HI(PPU_NAME_1-1)  \
                        \ The addition works because the low byte of PPU_NAME_1
                        \ is 0 and because the C flag is set (as we just passed
                        \ through the BNE above)

 STA PPU_ADDR           \ Set PPU_ADDR = (A X)
 STX PPU_ADDR           \              = PPU_NAME_1 + iconBarRow(1 0)
                        \
                        \ So PPU_ADDR points to the tile entry in the PPU's
                        \ nametable 1 for the start of the icon bar

 LDY #0                 \ We now send the nametable entries for the icon bar to
                        \ the PPU's nametable 1, so set a counter in Y

.ibar2

 LDA (dataForPPU),Y     \ Send the Y-th nametable entry from dataForPPU(1 0) to
 STA PPU_DATA           \ the PPU

 INY                    \ Increment the loop counter

 CPY #2*32              \ Loop back until we have sent 2 rows of 32 tiles
 BNE ibar2

 LDA skipBarPatternsPPU \ If bit 7 of skipBarPatternsPPU is set, we do not send
 BMI ibar3              \ the pattern data to the PPU, so jump to ibar3 to skip
                        \ the following

 JMP SendBarPattsToPPU  \ Bit 7 of skipBarPatternsPPU is clear, we do want to
                        \ send the icon bar's pattern data to the PPU, so jump
                        \ to SendBarPattsToPPU to do just that, returning from
                        \ the subroutine using a tail call

.ibar3

 STA barPatternCounter  \ Set barPatternCounter = 128 so the NMI handler does
                        \ not send any more icon bar data to the PPU

 JMP ConsiderSendTiles  \ Jump to ConsiderSendTiles to start sending tiles to
                        \ the PPU, but only if there are enough free cycles

