\ ******************************************************************************
\
\       Name: LoadNormalFont
\       Type: Subroutine
\   Category: Text
\    Summary: Load the normal font into the pattern buffer from pattern 66 to
\             160
\
\ ------------------------------------------------------------------------------
\
\ This routine fills the pattern buffer from pattern 66 to 160 with the font in
\ colour 1 on a colour 0 background (typically a white or cyan font on a black
\ background).
\
\ If the view type in QQ11 is &BB (Save and load with the normal and highlight
\ fonts loaded), then the font is in colour 1 on a colour 2 background (which
\ is a grey font on a red background in that view's palette).
\
\ This is always called with A = 66, so it always loads the fonts from pattern
\ 66 to 160.
\
\ Arguments:
\
\   A                   The pattern number to start at when loading the font
\                       patterns into the pattern buffers
\
\ ******************************************************************************

.LoadNormalFont

 STA SC                 \ Set SC to the pattern number where we need to load the
                        \ font patterns

 SEC                    \ Set asciiToPattern = A - ASCII code for space
 SBC #' '               \                    = start pattern - ASCII for space
 STA asciiToPattern     \
                        \ The font that we load starts with a space character as
                        \ the first entry, so asciiToPattern is the number we
                        \ need to add to an ASCII code to get the corresponding
                        \ character pattern

 LDA SC                 \ Set firstFreeTile = SC + 95
 CLC                    \
 ADC #95                \ There are 95 characters in the font, and we are about
 STA firstFreeTile      \ to load them at pattern number SC in the buffers, so
                        \ this sets the next free tile number in firstFreeTile
                        \ to the tile after the 95 font patterns we are loading
                        \
                        \ The font pattern data at fontImage actually contains
                        \ 96 characters, but we ignore the last one, which is
                        \ full of random noise

 LDX #0                 \ Set X = 0 to use in the font inversion logic below

 LDA QQ11               \ If the view type in QQ11 is not &BB (Save and load
 CMP #&BB               \ with the normal and highlight fonts loaded), jump to
 BNE ifon1              \ ifon1 to skip the following instruction

 DEX                    \ This is the save and load screen with font loaded in
                        \ both bitplanes, so set X = &FF to use in the font
                        \ inversion logic below

.ifon1

 STX T                  \ Set T = X, so we have the following:
                        \
                        \   * T = &FF if QQ11 is &BB (Save and load screen with
                        \         the normal and highlight fonts loaded)
                        \
                        \   * T = 0 for all other screens
                        \
                        \ This is used to invert the font characters below

 LDA #0                 \ Set SC2(1 0) = pattBuffer0 + SC * 8
 ASL SC                 \
 ROL A                  \ So this points to the pattern in pattern buffer 0 that
 ASL SC                 \ corresponds to tile number SC
 ROL A
 ASL SC
 ROL A
 ADC #HI(pattBuffer0)
 STA SC2+1

 ADC #8                 \ Set SC(1 0) = SC2(1 0) + (8 0)
 STA SC+1               \
 LDA SC                 \ Pattern buffer 0 consists of 8 pages of memory and is
 STA SC2                \ followed by pattern buffer 1, so this sets SC(1 0) to
                        \ the pattern in pattern buffer 1 that corresponds to
                        \ tile number SC

 LDA #HI(fontImage)     \ Set V(1 0) = fontImage, so we copy the font patterns
 STA V+1                \ to the pattern buffers in the following
 LDA #LO(fontImage)
 STA V

 LDX #95                \ There are 95 characters in the game font, so set a
                        \ character counter in X to count down from 95 to 1

 LDY #0                 \ Set Y to use as an index counter as we copy the font
                        \ to the pattern buffers

.ifon2

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

                        \ We repeat the following code eight times, so it sends
                        \ all eight bytes of this character's font pattern to
                        \ both pattern buffers
                        \
                        \ In each of the following, the font character is copied
                        \ into pattern buffer 0 unchanged, but when the same
                        \ character is copied into pattern buffer 1, the
                        \ following transformation is applied:
                        \
                        \   AND T
                        \   EOR T
                        \
                        \ T is 0, unless this is the save and load screen, in
                        \ which case T is &FF
                        \
                        \ When T = 0, we have A AND 0 EOR 0, which is 0, so
                        \ pattern buffer 1 gets filled with zeroes, and as
                        \ pattern buffer 0 contains the font, this means the
                        \ pattern buffer contains the font in colour 1 on a
                        \ colour 0 background (i.e. a black background)
                        \
                        \ When T = &FF, we have A AND &FF EOR &FF, which is the
                        \ same as A EOR &FF, which is the value in A inverted,
                        \ so pattern buffer 1 gets filled with the font, but
                        \ with ones for the background and zeroes for the
                        \ foreground, which means the pattern buffer contains
                        \ the font in colour 2 on a colour 1 background

 LDA (V),Y              \ Copy the Y-th pattern byte from the font to pattern
 STA (SC2),Y            \ buffer 0, and copy the same pattern to pattern buffer
 AND T                  \ 1, either as a row of eight filled pixels or as an
 EOR T                  \ inverted font, and increment the index in Y
 STA (SC),Y
 INY

 LDA (V),Y              \ Copy the Y-th pattern byte from the font to pattern
 STA (SC2),Y            \ buffer 0, and copy the same pattern to pattern buffer
 AND T                  \ 1, either as a white block or as an inverted font, and
 EOR T                  \ increment the index in Y
 STA (SC),Y
 INY

 LDA (V),Y              \ Copy the Y-th pattern byte from the font to pattern
 STA (SC2),Y            \ buffer 0, and copy the same pattern to pattern buffer
 AND T                  \ 1, either as a white block or as an inverted font, and
 EOR T                  \ increment the index in Y
 STA (SC),Y
 INY

 LDA (V),Y              \ Copy the Y-th pattern byte from the font to pattern
 STA (SC2),Y            \ buffer 0, and copy the same pattern to pattern buffer
 AND T                  \ 1, either as a white block or as an inverted font, and
 EOR T                  \ increment the index in Y
 STA (SC),Y
 INY

 LDA (V),Y              \ Copy the Y-th pattern byte from the font to pattern
 STA (SC2),Y            \ buffer 0, and copy the same pattern to pattern buffer
 AND T                  \ 1, either as a white block or as an inverted font, and
 EOR T                  \ increment the index in Y
 STA (SC),Y
 INY

 LDA (V),Y              \ Copy the Y-th pattern byte from the font to pattern
 STA (SC2),Y            \ buffer 0, and copy the same pattern to pattern buffer
 AND T                  \ 1, either as a white block or as an inverted font, and
 EOR T                  \ increment the index in Y
 STA (SC),Y
 INY

 LDA (V),Y              \ Copy the Y-th pattern byte from the font to pattern
 STA (SC2),Y            \ buffer 0, and copy the same pattern to pattern buffer
 AND T                  \ 1, either as a white block or as an inverted font, and
 EOR T                  \ increment the index in Y
 STA (SC),Y
 INY

 LDA (V),Y              \ Copy the Y-th pattern byte from the font to pattern
 STA (SC2),Y            \ buffer 0, and copy the same pattern to pattern buffer
 AND T                  \ 1, either as a white block or as an inverted font, and
 EOR T                  \ increment the index in Y
 STA (SC),Y
 INY

 BNE ifon3              \ If we just incremented Y back around to 0, then
 INC V+1                \ increment the high bytes of V(1 0), SC(1 0) and
 INC SC2+1              \ SC2(1 0) to point to the next page in memory
 INC SC+1

.ifon3

 DEX                    \ Decrement the character counter in X

 BNE ifon2              \ Loop back until we have copied all 95 characters to
                        \ the pattern buffers

 RTS                    \ Return from the subroutine

