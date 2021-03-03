\ ******************************************************************************
\
\       Name: SP2
\       Type: Subroutine
\   Category: Dashboard
\    Summary: Draw a dot on the compass, given the planet/station vector
\
\ ------------------------------------------------------------------------------
\
\ Draw a dot on the compass to represent the planet or station, whose normalised
\ vector is in XX15.
\
\   XX15 to XX15+2      The normalised vector to the planet or space station,
\                       stored as x in XX15, y in XX15+1 and z in XX15+2
\
\ ******************************************************************************

.SP2

 LDA XX15               \ Set A to the x-coordinate of the planet or station to
                        \ show on the compass, which will be in the range -96 to
                        \ +96 as the vector has been normalised

 JSR SPS2               \ Set (Y X) = A / 10, so X will be from -9 to +9, which
                        \ is the x-offset from the centre of the compass of the
                        \ dot we want to draw. Returns with the C flag clear

 TXA                    \ Set COMX = 195 + X, as 186 is the pixel x-coordinate
 ADC #195               \ of the leftmost dot possible on the compass, and X can
 STA COMX               \ be -9, which would be 195 - 9 = 186. This also means
                        \ that the highest value for COMX is 195 + 9 = 204,
                        \ which is the pixel x-coordinate of the rightmost dot
                        \ in the compass... but the compass dot is actually two
                        \ pixels wide, so the compass dot can overlap the right
                        \ edge of the compass, but not the left edge

 LDA XX15+1             \ Set A to the y-coordinate of the planet or station to
                        \ show on the compass, which will be in the range -96 to
                        \ +96 as the vector has been normalised

 JSR SPS2               \ Set (Y X) = A / 10, so X will be from -9 to +9, which
                        \ is the y-offset from the centre of the compass of the
                        \ dot we want to draw. Returns with the C flag clear

 STX T                  \ Set COMY = 204 - X, as 203 is the pixel y-coordinate
 LDA #204               \ of the centre of the compass, the C flag is clear,
 SBC T                  \ and the y-axis needs to be flipped around (because
 STA COMY               \ when the planet or station is above us, and the
                        \ vector is therefore positive, we want to show the dot
                        \ higher up on the compass, which has a smaller pixel
                        \ y-coordinate). So this calculation does this:
                        \
                        \   COMY = 204 - X - (1 - 0) = 203 - X

IF _CASSETTE_VERSION OR _DISC_FLIGHT \ Screen

 LDA #&F0               \ Set A to a 4-pixel mode 5 byte row in colour 2
                        \ (yellow/white), the colour for when the planet or
                        \ station in the compass is in front of us

ELIF _6502SP_VERSION

 LDA #WHITE2            \ Set A to white, the colour for when the planet or
                        \ station in the compass is in front of us

ENDIF

 LDX XX15+2             \ If the z-coordinate of the XX15 vector is positive,
 BPL P%+4               \ skip the following instruction

IF _CASSETTE_VERSION OR _DISC_FLIGHT \ Screen

 LDA #&FF               \ The z-coordinate of XX15 is negative, so the planet or
                        \ station is behind us and the compass dot should be in
                        \ green/cyan, so set A to a 4-pixel mode 5 byte row in
                        \ colour 3

ELIF _6502SP_VERSION

 LDA #GREEN2            \ The z-coordinate of XX15 is negative, so the planet or
                        \ station is behind us and the compass dot should be in
                        \ green, so set A accordingly

ENDIF

 STA COMC               \ Store the compass colour in COMC

                        \ Fall through into DOT to draw the dot on the compass

