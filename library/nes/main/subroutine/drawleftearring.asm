\ ******************************************************************************
\
\       Name: DrawLeftEarring
\       Type: Subroutine
\   Category: Status
\    Summary: Draw an earring in the commander's left ear (i.e. on the right
\             side of the commander image
\
\ ******************************************************************************

.DrawLeftEarring

 LDA #108               \ Set the pattern number for sprite 12 to 108, which is
 STA tileSprite12       \ the left earring

 LDA #%00000010         \ Set the attributes for sprite 12 as follows:
 STA attrSprite12       \
                        \   * Bits 0-1    = sprite palette 2
                        \   * Bit 5 clear = show in front of background
                        \   * Bit 6 clear = do not flip horizontally
                        \   * Bit 7 clear = do not flip vertically

 LDA #227               \ Set the x-coordinate for sprite 12 to 227
 STA xSprite12

 LDA languageNumber     \ If bit 2 of languageNumber is clear then the chosen
 AND #%00000100         \ language is not French, so jump to earl1 with A = 0
 BEQ earl1

 LDA #16                \ The chosen language is French, so the commander image
                        \ is 16 pixels lower down the screen, so set A = 16 to
                        \ add to the y-coordinate of the earring

.earl1

 CLC                    \ Set the y-coordinate for sprite 12 to 98, plus the
 ADC #98+YPAL           \ margin we just set in A
 STA ySprite12

 RTS                    \ Return from the subroutine

