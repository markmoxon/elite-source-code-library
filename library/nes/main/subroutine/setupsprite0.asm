\ ******************************************************************************
\
\       Name: SetupSprite0
\       Type: Subroutine
\   Category: PPU
\    Summary: Set the coordinates of sprite 0 so we can detect when the PPU
\             starts to draw the icon bar
\
\ ******************************************************************************

.SetupSprite0

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA #248               \ Set the x-coordinate of sprite 0 to 248
 STA xSprite0

                        \ We now set X and Y depending on the type of view, as
                        \ follows:
                        \
                        \   * X is the pixel y-coordinate of sprite 0, which is
                        \     positioned just above the icon bar
                        \
                        \   * Y is the row containing the top part of the icon
                        \     bar pointer

 LDY #18                \ Set Y = 18

 LDX #157+YPAL          \ Set X = 157

 LDA QQ11               \ If bit 7 of the view type in QQ11 is clear then there
 BPL sets4              \ is a dashboard, so jump to sets4 with X = 157 and
                        \ Y = 18

 CMP #&C4               \ If the view type in QQ11 is not &C4 (Game Over screen)
 BNE sets1              \ then jump to sets1 to keep checking the view type

 LDX #240               \ This is the Game Over screen, so jump to sets 4 with
 BNE sets4              \ X = 240 and Y = 18 (this BNE is effectively a JMP as
                        \ X is never zero)

.sets1

 LDY #25                \ Set Y = 25

 LDX #213+YPAL          \ Set X = 213

 CMP #&B9               \ If the view type in QQ11 is not &B9 (Equip Ship) then
 BNE sets2              \ jump to sets2 to keep checking the view type

 LDX #150+YPAL          \ This is the Equip Ship screen, so set X = 150

 LDA #248               \ Set the x-coordinate of sprite 0 to 248 (though we
 STA xSprite0           \ already did this above, so perhaps this is left over
                        \ code from development)

.sets2

 LDA QQ11               \ If the view type in QQ11 is not &xF (the Start screen
 AND #&0F               \ in any of its font configurations), jump to sets3 to
 CMP #&0F               \ keep checking the view type
 BNE sets3

 LDX #166+YPAL          \ This is the Start screen, so set X = 166

.sets3

 CMP #&0D               \ If the view type in QQ11 is not &xD (the Long-range or
 BNE sets4              \ Short-range Chart), jump to sets4 to use the current
                        \ values of X and Y

 LDX #173+YPAL          \ This is a chart screen, so set X = 173

 LDA #248               \ Set the x-coordinate of sprite 0 to 248 (though we
 STA xSprite0           \ already did this above, so perhaps this is left over
                        \ code from development)

.sets4

                        \ We get here with X and Y set as follows:
                        \
                        \   * X = 157, Y = 18 if there is a dashboard
                        \   * X = 240, Y = 18 if this is the Game Over screen
                        \   * X = 150, Y = 25 if this is the Equip Ship screen
                        \   * X = 166, Y = 25 if this is the Start screen
                        \   * X = 173, Y = 25 if this is a chart screen
                        \   * X = 213, Y = 25 otherwise
                        \
                        \ In all cases the x-coordinate of sprite 0 is 248

 STX ySprite0           \ Set the y-coordinate of sprite 0 to X
                        \
                        \ This means that sprite 0 is at these coordinates:
                        \
                        \   * (248, 157) if there is a dashboard
                        \   * (248, 240) if this is the Game Over screen
                        \   * (248, 150) if this is the Equip Ship screen
                        \   * (248, 166) if this is the Start screen
                        \   * (248, 173) if this is a chart screen
                        \   * (248, 213) otherwise

 TYA                    \ Set the y-coordinate of the icon bar pointer in
 SEC                    \ yIconBarPointer to Y * 8 + %100, which is either
 ROL A                  \ 148 or 204 (when Y is 18 or 25)
 ASL A                  \
 ASL A                  \ This means the icon bar pointer is at y-coordinate
 STA yIconBarPointer    \ 148 when there is a dashboard or this is the Game Over
                        \ screen, and it's at y-coordinate 204 otherwise

 LDA iconBarType        \ Set iconBarImageHi to the high byte of the correct
 ASL A                  \ icon bar image block for the current icon bar type,
 ASL A                  \ which we can calculate like this:
 ADC #HI(iconBarImage0) \
 STA iconBarImageHi     \   HI(iconBarImage0) + 4 * iconBarType
                        \
                        \ as each icon bar image block contains &0400 bytes,
                        \ and iconBarType is the icon bar type, 0 to 4

 LDA QQ11               \ If bit 6 of the view type is set, then there is no
 AND #%01000000         \ icon bar, so jump to sets5 to skip the following
 BNE sets5              \ instruction

 LDX #0                 \ If we get here then there is an icon bar, so set
 STX barPatternCounter  \ barPatternCounter = 0 so the NMI handler sends the
                        \ icon bar's nametable and pattern data to the PPU

.sets5

 RTS                    \ Return from the subroutine

