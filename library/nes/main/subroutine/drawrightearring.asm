\ ******************************************************************************
\
\       Name: DrawRightEarring
\       Type: Subroutine
\   Category: Status
\    Summary: Draw an earring in the commander's right ear (i.e. on the left
\             side of the commander image
\
\ ******************************************************************************

.DrawRightEarring

 LDA #107               \ Set the pattern number for sprite 11 to 107, which is
 STA pattSprite11       \ the right earring

 LDA #%00000010         \ Set the attributes for sprite 11 as follows:
 STA attrSprite11       \
                        \   * Bits 0-1    = sprite palette 2
                        \   * Bit 5 clear = show in front of background
                        \   * Bit 6 clear = do not flip horizontally
                        \   * Bit 7 clear = do not flip vertically

 LDA #195               \ Set the x-coordinate for sprite 11 to 195
 STA xSprite11

 LDA languageNumber     \ If bit 2 of languageNumber is clear then the chosen
 AND #%00000100         \ language is not French, so jump to earr1 with A = 0
 BEQ earr1

 LDA #16                \ The chosen language is French, so the commander image
                        \ is 16 pixels lower down the screen, so set A = 16 to
                        \ add to the y-coordinate of the earring

.earr1

 CLC                    \ Set the y-coordinate for sprite 11 to 98, plus the
 ADC #98+YPAL           \ margin we just set in A
 STA ySprite11

 RTS                    \ Return from the subroutine

