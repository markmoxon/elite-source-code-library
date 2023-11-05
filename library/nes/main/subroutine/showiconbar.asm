\ ******************************************************************************
\
\       Name: ShowIconBar
\       Type: Subroutine
\   Category: Icon bar
\    Summary: Show a specified icon bar on-screen
\  Deep dive: Views and view types in NES Elite
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The type of icon bar to show:
\
\                         * 0 = Docked
\
\                         * 1 = Flight
\
\                         * 2 = Charts
\
\                         * 3 = Pause
\
\                         * 4 = Title screen copyright message
\
\ ******************************************************************************

.ShowIconBar

 TAY                    \ Copy the icon bar type into Y

 LDA QQ11               \ If bit 6 of the view type is set, then there is no
 AND #%01000000         \ icon bar on the screen, so jump to RTS9 to return
 BNE RTS9               \ from the subroutine as there is nothing to show

 STY iconBarType        \ Set the type of the current icon bar in iconBarType to
                        \ to the new type in Y

 JSR BlankAllButtons    \ Blank all the buttons on the icon bar

 LDA #HI(20*32)         \ Set iconBarRow(1 0) = 20*32
 STA iconBarRow+1
 LDA #LO(20*32)
 STA iconBarRow

 LDA QQ11               \ If bit 7 of the view type in QQ11 is clear then there
 BPL obar1              \ is a dashboard, so jump to obar1 to keep this value of
                        \ iconBarRow

 LDA #HI(27*32)         \ Set iconBarRow(1 0) = 27*32
 STA iconBarRow+1       \
 LDA #LO(27*32)         \ So the icon bar is on row 20 if bit 7 of the view
 STA iconBarRow         \ number is clear (so there is a dashboard), and it's on
                        \ row 27 is bit 7 is set (so there is no dashboard)

.obar1

 LDA iconBarType        \ Set iconBarImageHi to the high byte of the correct
 ASL A                  \ icon bar image block for the current icon bar type,
 ASL A                  \ which we can calculate like this:
 ADC #HI(iconBarImage0) \
 STA iconBarImageHi     \   HI(iconBarImage0) + 4 * iconBarType
                        \
                        \ as each icon bar image block contains &0400 bytes,
                        \ and iconBarType is the icon bar type, 0 to 4

 LDX #0                 \ Set barPatternCounter = 0 so the NMI handler sends the
 STX barPatternCounter  \ icon bar's nametable and pattern data to the PPU

.obar2

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA barPatternCounter  \ Loop back to keep the PPU configured in this way until
 BPL obar2              \ barPatternCounter is set to 128
                        \
                        \ This happens when the NMI handler has finished sending
                        \ all the icon bar's nametable and pattern data to
                        \ the PPU, so this loop keeps the PPU configured to use
                        \ nametable 0 and pattern table 0 until the icon bar
                        \ nametable and pattern data have all been sent

                        \ Fall through into UpdateIconBar to update the icon bar

