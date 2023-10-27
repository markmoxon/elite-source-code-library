\ ******************************************************************************
\
\       Name: SendFontImageToPPU
\       Type: Subroutine
\   Category: PPU
\    Summary: Send a font to the PPU as a colour 1 font on a colour 0 background
\             (i.e. colour 1 on black)
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The number of patterns to send to the PPU
\
\   SC(1 0)             The address of the data in the pattern buffer to send to
\                       the PPU
\
\ ******************************************************************************

.SendFontImageToPPU

 LDY #0                 \ We are about to send a batch of bytes to the PPU, so
                        \ set an index counter in Y

.sppu1

                        \ We repeat the following code eight times, so it sends
                        \ all eight bytes of the pattern into bitplane 0 to the
                        \ PPU
                        \
                        \ Bitplane 0 is used for bit 0 of the colour number, and
                        \ we send zeroes to bitplane 1 below, which is used for
                        \ bit 1 of the colour number, so the result is a pattern
                        \ with the font in colour 1 on background colour 0

 LDA (SC),Y             \ Send the Y-th byte of SC(1 0) to the PPU and increment
 STA PPU_DATA           \ the index in Y
 INY

 LDA (SC),Y             \ Send the Y-th byte of SC(1 0) to the PPU and increment
 STA PPU_DATA           \ the index in Y
 INY

 LDA (SC),Y             \ Send the Y-th byte of SC(1 0) to the PPU and increment
 STA PPU_DATA           \ the index in Y
 INY

 LDA (SC),Y             \ Send the Y-th byte of SC(1 0) to the PPU and increment
 STA PPU_DATA           \ the index in Y
 INY

 LDA (SC),Y             \ Send the Y-th byte of SC(1 0) to the PPU and increment
 STA PPU_DATA           \ the index in Y
 INY

 LDA (SC),Y             \ Send the Y-th byte of SC(1 0) to the PPU and increment
 STA PPU_DATA           \ the index in Y
 INY

 LDA (SC),Y             \ Send the Y-th byte of SC(1 0) to the PPU and increment
 STA PPU_DATA           \ the index in Y
 INY

 LDA (SC),Y             \ Send the Y-th byte of SC(1 0) to the PPU and increment
 STA PPU_DATA           \ the index in Y
 INY

 BNE sppu2              \ If Y just wrapped around to zero, increment the high
 INC SC+1               \ byte of SC(1 0) to point to the next page in memory

.sppu2

 LDA #0                 \ Send the pattern's second bitplane to the PPU, so all
 STA PPU_DATA           \ eight bytes of the pattern in bitplane 1 are set to
 STA PPU_DATA           \ zero (so bit 1 of the colour number is zero)
 STA PPU_DATA
 STA PPU_DATA
 STA PPU_DATA
 STA PPU_DATA
 STA PPU_DATA
 STA PPU_DATA

 DEX                    \ Decrement the pattern counter in X

 BNE sppu1              \ Loop back to send the next pattern to the PPU until we
                        \ have sent X patterns

 RTS                    \ Return from the subroutine

