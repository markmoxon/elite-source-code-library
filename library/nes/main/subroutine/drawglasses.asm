\ ******************************************************************************
\
\       Name: DrawGlasses
\       Type: Subroutine
\   Category: Status
\    Summary: Draw a pair of dark glasses on the commander image
\
\ ******************************************************************************

.DrawGlasses

 LDA #104               \ Set the pattern number for sprite 8 to 104, which is
 STA pattSprite8        \ the left part of the dark glasses

 LDA #%00000000         \ Set the attributes for sprite 8 as follows:
 STA attrSprite8        \
                        \   * Bits 0-1    = sprite palette 0
                        \   * Bit 5 clear = show in front of background
                        \   * Bit 6 clear = do not flip horizontally
                        \   * Bit 7 clear = do not flip vertically

 LDA #203               \ Set the x-coordinate for sprite 8 to 203
 STA xSprite8

 LDA languageNumber     \ If bit 2 of languageNumber is clear then the chosen
 AND #%00000100         \ language is not French, so jump to glas1 with A = 0
 BEQ glas1

 LDA #16                \ The chosen language is French, so the commander image
                        \ is 16 pixels lower down the screen, so set A = 16 to
                        \ add to the y-coordinate of the glasses

.glas1

 CLC                    \ Set the y-coordinate for sprite 8 to 90, plus the
 ADC #90+YPAL           \ margin we just set in A
 STA ySprite8

 LDA #105               \ Set the pattern number for sprite 9 to 105, which is
 STA pattSprite9        \ the middle part of the dark glasses

 LDA #%00000000         \ Set the attributes for sprite 9 as follows:
 STA attrSprite9        \
                        \   * Bits 0-1    = sprite palette 0
                        \   * Bit 5 clear = show in front of background
                        \   * Bit 6 clear = do not flip horizontally
                        \   * Bit 7 clear = do not flip vertically

 LDA #211               \ Set the x-coordinate for sprite 9 to 211
 STA xSprite9

 LDA languageNumber     \ If bit 2 of languageNumber is clear then the chosen
 AND #%00000100         \ language is not French, so jump to glas2 with A = 0
 BEQ glas2

 LDA #16                \ The chosen language is French, so the commander image
                        \ is 16 pixels lower down the screen, so set A = 16 to
                        \ add to the y-coordinate of the glasses

.glas2

 CLC                    \ Set the y-coordinate for sprite 9 to 90, plus the
 ADC #90+YPAL           \ margin we just set in A
 STA ySprite9

 LDA #106               \ Set the pattern number for sprite 10 to 106, which is
 STA pattSprite10       \ the right part of the dark glasses

 LDA #%00000000         \ Set the attributes for sprite 10 as follows:
 STA attrSprite10       \
                        \   * Bits 0-1    = sprite palette 0
                        \   * Bit 5 clear = show in front of background
                        \   * Bit 6 clear = do not flip horizontally
                        \   * Bit 7 clear = do not flip vertically


 LDA #219               \ Set the x-coordinate for sprite 10 to 219
 STA xSprite10

 LDA languageNumber     \ If bit 2 of languageNumber is clear then the chosen
 AND #%00000100         \ language is not French, so jump to glas3 with A = 0
 BEQ glas3

 LDA #16                \ The chosen language is French, so the commander image
                        \ is 16 pixels lower down the screen, so set A = 16 to
                        \ add to the y-coordinate of the glasses

.glas3

 CLC                    \ Set the y-coordinate for sprite 10 to 90, plus the
 ADC #90+YPAL           \ margin we just set in A
 STA ySprite10

 RTS                    \ Return from the subroutine

