\ ******************************************************************************
\
\       Name: LoadHighFont
\       Type: Subroutine
\   Category: Text
\    Summary: Load the highlight font into the pattern buffer from pattern 161
\             to 255
\
\ ------------------------------------------------------------------------------
\
\ This routine fills the pattern buffer from pattern 161 to 255 with the font in
\ colour 3 on a colour 1 background (which is typically a green font on a grey
\ background that can be used for drawing highlighted text in menu selections).
\
\ If the view type in QQ11 is &BB (Save and load with the normal and highlight
\ fonts loaded), then only the first 70 characters of the font are loaded, into
\ patterns 161 to 230.
\
\ ******************************************************************************

.LoadHighFont

 LDA #HI(pattBuffer0+8*161) \ Set SC(1 0) to the address of pattern 161 in
 STA SC2+1                  \ pattern buffer 0
 LDA #LO(pattBuffer0+8*161)
 STA SC2

 LDA #HI(pattBuffer1+8*161) \ Set SC(1 0) to the address of pattern 161 in
 STA SC+1                   \ pattern buffer 1
 LDA #LO(pattBuffer1+8*161)
 STA SC

 LDX #95                \ There are 95 characters in the game font, so set a
                        \ character counter in X to count down from 95 to 1
                        \
                        \ The font pattern data at fontImage actually contains
                        \ 96 characters, but we ignore the last one, which is
                        \ full of random noise

 LDA QQ11               \ If the view type in QQ11 is not &BB (Save and load
 CMP #&BB               \ with the normal and highlight fonts loaded), jump to
 BNE font1              \ font1 to skip the following instruction

 LDX #70                \ This is the save and load screen with font loaded in
                        \ both bitplanes, so set X = 70 so that we only copy 70
                        \ characters from the font

.font1

 TXA                    \ Set firstFreePattern = firstFreePattern + X
 CLC                    \
 ADC firstFreePattern   \ We are about to copy X character patterns for the
 STA firstFreePattern   \ font, so this sets the next free pattern number in
                        \ firstFreePattern to the pattern that is X patterns
                        \ after its current value, i.e. just after the font we
                        \ are copying

 LDA #HI(fontImage)     \ Set V(1 0) = fontImage, so we copy the font patterns
 STA V+1                \ to the pattern buffers in the following
 LDA #LO(fontImage)
 STA V

 LDY #0                 \ Set Y to use as an index counter as we copy the font
                        \ to the pattern buffers

.font2

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

                        \ We repeat the following code eight times, so it sends
                        \ all eight bytes of this character's font pattern to
                        \ both pattern buffers

 LDA (V),Y              \ Copy the Y-th pattern byte from the font to pattern
 STA (SC),Y             \ buffer 1, set the Y-th pattern byte in pattern buffer
 LDA #&FF               \ 0 to a row of eight set pixels, and increment the
 STA (SC2),Y            \ index in Y
 INY

 LDA (V),Y              \ Copy the Y-th pattern byte from the font to pattern
 STA (SC),Y             \ buffer 1, set the Y-th pattern byte in pattern buffer
 LDA #&FF               \ 0 to a row of eight set pixels, and increment the
 STA (SC2),Y            \ index in Y
 INY

 LDA (V),Y              \ Copy the Y-th pattern byte from the font to pattern
 STA (SC),Y             \ buffer 1, set the Y-th pattern byte in pattern buffer
 LDA #&FF               \ 0 to a row of eight set pixels, and increment the
 STA (SC2),Y            \ index in Y
 INY

 LDA (V),Y              \ Copy the Y-th pattern byte from the font to pattern
 STA (SC),Y             \ buffer 1, set the Y-th pattern byte in pattern buffer
 LDA #&FF               \ 0 to a row of eight set pixels, and increment the
 STA (SC2),Y            \ index in Y
 INY

 LDA (V),Y              \ Copy the Y-th pattern byte from the font to pattern
 STA (SC),Y             \ buffer 1, set the Y-th pattern byte in pattern buffer
 LDA #&FF               \ 0 to a row of eight set pixels, and increment the
 STA (SC2),Y            \ index in Y
 INY

 LDA (V),Y              \ Copy the Y-th pattern byte from the font to pattern
 STA (SC),Y             \ buffer 1, set the Y-th pattern byte in pattern buffer
 LDA #&FF               \ 0 to a row of eight set pixels, and increment the
 STA (SC2),Y            \ index in Y
 INY

 LDA (V),Y              \ Copy the Y-th pattern byte from the font to pattern
 STA (SC),Y             \ buffer 1, set the Y-th pattern byte in pattern buffer
 LDA #&FF               \ 0 to a row of eight set pixels, and increment the
 STA (SC2),Y            \ index in Y
 INY

 LDA (V),Y              \ Copy the Y-th pattern byte from the font to pattern
 STA (SC),Y             \ buffer 1, set the Y-th pattern byte in pattern buffer
 LDA #&FF               \ 0 to a row of eight set pixels, and increment the
 STA (SC2),Y            \ index in Y
 INY

 BNE font3              \ If we just incremented Y back around to 0, then
 INC V+1                \ increment the high bytes of V(1 0), SC(1 0) and
 INC SC+1               \ SC2(1 0) to point to the next page in memory
 INC SC2+1

.font3

 DEX                    \ Decrement the character counter in X

 BNE font2              \ Loop back until we have copied all 95 characters to
                        \ the pattern buffers

 RTS                    \ Return from the subroutine

