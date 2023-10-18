\ ******************************************************************************
\
\       Name: SendPalettesToPPU
\       Type: Subroutine
\   Category: PPU
\    Summary: Send the palette data from XX3 to the PPU
\
\ ******************************************************************************

.SendPalettesToPPU

 LDA #&3F               \ Set PPU_ADDR = &3F01, so it points to background
 STA PPU_ADDR           \ palette 0 in the PPU
 LDA #&01
 STA PPU_ADDR

 LDX #1                 \ We are about to send the palette data from XX3 to
                        \ the PPU, so set an index counter in X so we send the
                        \ following:
                        \
                        \   XX3+1 goes to &3F01
                        \   XX3+2 goes to &3F02
                        \   ...
                        \   XX3+&30 goes to &3F30
                        \   XX3+&31 goes to &3F31
                        \
                        \ So the following loop sends data for the four
                        \ background palettes and the four sprite palettes

.sepa1

 LDA XX3,X              \ Set A to the X-th entry in XX3

 AND #%00111111         \ Clear bits 6 and 7

 STA PPU_DATA           \ Send the palette entry to the PPU

 INX                    \ Increment the loop counter

 CPX #&20               \ Loop back until we have sent XX3+1 through XX3+&1F
 BNE sepa1

 SUBTRACT_CYCLES 559    \ Subtract 559 from the cycle count

 JMP SendScreenToPPU+4  \ Return to SendScreenToPPU to continue with the next
                        \ instruction following the call to this routine

