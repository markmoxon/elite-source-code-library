\ ******************************************************************************
\
\       Name: ClearScreen
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Clear the screen by clearing patterns 66 to 255 in both pattern
\             buffers, and clearing both nametable buffers to the background
\
\ ******************************************************************************

.ClearScreen

 LDA #0                 \ Set SC(1 0) = 66 * 8
 STA SC+1               \
 LDA #66                \ We use this to calculate the address of pattern 66 in
 ASL A                  \ the pattern buffers below
 ROL SC+1
 ASL A
 ROL SC+1
 ASL A
 ROL SC+1
 STA SC

 STA SC2                \ Set SC2(1 0) = pattBuffer1 + SC(1 0)
 LDA SC+1               \              = pattBuffer1 + 66 * 8
 ADC #HI(pattBuffer1)   \
 STA SC2+1              \ So SC2(1 0) contains the address of pattern 66 in
                        \ pattern buffer 1, as each pattern in the buffer
                        \ contains eight bytes

 LDA SC+1               \ Set SC(1 0) = pattBuffer0 + SC(1 0)
 ADC #HI(pattBuffer0)   \             = pattBuffer0 + 66 * 8
 STA SC+1               \
                        \ So SC2(1 0) contains the address of pattern 66 in
                        \ pattern buffer 0

 LDX #66                \ We want to zero pattern 66 onwards, so set a counter
                        \ in X to count the tile number, starting from 66

 LDY #0                 \ Set Y to use as a byte index as we zero 8 bytes for
                        \ each tile

.clsc1

 LDA #0                 \ We are going to zero the tiles to clear the patterns,
                        \ so set A = 0 so we can poke it into memory

                        \ We repeat the following code eight times, so it clears
                        \ one whole pattern of eight bytes

 STA (SC),Y             \ Zero the Y-th pattern byte in SC(1 0) and SC2(1 0), to
 STA (SC2),Y            \ clear both pattern buffer 0 and 1, and increment the
 INY                    \ byte counter in Y

 STA (SC),Y             \ Zero the Y-th pattern byte in SC(1 0) and SC2(1 0), to
 STA (SC2),Y            \ clear both pattern buffer 0 and 1, and increment the
 INY                    \ byte counter in Y

 STA (SC),Y             \ Zero the Y-th pattern byte in SC(1 0) and SC2(1 0), to
 STA (SC2),Y            \ clear both pattern buffer 0 and 1, and increment the
 INY                    \ byte counter in Y

 STA (SC),Y             \ Zero the Y-th pattern byte in SC(1 0) and SC2(1 0), to
 STA (SC2),Y            \ clear both pattern buffer 0 and 1, and increment the
 INY                    \ byte counter in Y

 STA (SC),Y             \ Zero the Y-th pattern byte in SC(1 0) and SC2(1 0), to
 STA (SC2),Y            \ clear both pattern buffer 0 and 1, and increment the
 INY                    \ byte counter in Y

 STA (SC),Y             \ Zero the Y-th pattern byte in SC(1 0) and SC2(1 0), to
 STA (SC2),Y            \ clear both pattern buffer 0 and 1, and increment the
 INY                    \ byte counter in Y

 STA (SC),Y             \ Zero the Y-th pattern byte in SC(1 0) and SC2(1 0), to
 STA (SC2),Y            \ clear both pattern buffer 0 and 1, and increment the
 INY                    \ byte counter in Y

 STA (SC),Y             \ Zero the Y-th pattern byte in SC(1 0) and SC2(1 0), to
 STA (SC2),Y            \ clear both pattern buffer 0 and 1, and increment the
 INY                    \ byte counter in Y

 BNE clsc2              \ If Y is non-zero then jump to clsc2 to skip the
                        \ following

 INC SC+1               \ Y just wrapped around to zero, so increment the high
 INC SC2+1              \ bytes of SC(1 0) and SC2(1 0) so that SC(1 0) + Y
                        \ and SC2(1 0) + Y continue to point to the correct
                        \ addresses in the pattern buffers

.clsc2

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 INX                    \ Increment the tile number in X, as we just cleared a
                        \ whole pattern

 BNE clsc1              \ Loop back to clsc1 to keep clearing patterns until we
                        \ have cleared patterns 66 through 255

                        \ We have cleared the pattern buffers, so now to clear
                        \ the nametable buffers

 LDA #LO(nameBuffer0)   \ Set SC(1 0)  = nameBuffer0
 STA SC
 STA SC2
 LDA #HI(nameBuffer0)
 STA SC+1

 LDA #HI(nameBuffer1)   \ Set SC2(1 0) = nameBuffer1
 STA SC2+1

 LDX #28                \ We are going to clear 28 rows of 32 tiles, so set a
                        \ row counter in X to count down from 28

.clsc3

 LDY #32                \ We are going to clear 32 tiles on each row, so set a
                        \ tile counter in Y to count down from 32

 LDA #0                 \ We are going to zero the nametable entry so it uses
                        \ the blank background tile, so set A = 0 so we can poke
                        \ it into memory

.clsc4

 STA (SC),Y             \ Zero the Y-th nametable entry in SC(1 0), which resets
                        \ nametable 0

 STA (SC2),Y            \ Zero the Y-th nametable entry in SC2(1 0), which
                        \ resets nametable 1

 DEY                    \ Decrement the tile counter in Y

 BPL clsc4              \ Loop back until we have zeroed all 32 tiles on this
                        \ row

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA SC                 \ Add 32 to both SC(1 0) and SC2(1 0) so they point to
 CLC                    \ the next row down in the nametables, starting with the
 ADC #32                \ low bytes
 STA SC
 STA SC2

 BCC clsc5              \ And then the high bytes
 INC SC+1
 INC SC2+1

.clsc5

 DEX                    \ Decrement the row counter in X

 BNE clsc3              \ Loop back until we have cleared all 28 rows

 RTS                    \ Return from the subroutine

