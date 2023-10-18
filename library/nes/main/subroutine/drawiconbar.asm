\ ******************************************************************************
\
\       Name: DrawIconBar
\       Type: Subroutine
\   Category: Icon bar
\    Summary: Draw the icon bar into the nametable buffers for both bitplanes
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   SC(1 0)             The address of the nametable entries for the on-screen
\                       icon bar in nametable buffer 0
\
\   SC2(1 0)            The address of the nametable entries for the on-screen
\                       icon bar in nametable buffer 1
\
\ ******************************************************************************

.DrawIconBar

                        \ We start by setting V(1 0) to the address of the
                        \ barNames table that corresponds to the current icon
                        \ bar type (i.e. barNames0 to barNames4)
                        \
                        \ This contains the nametable entries we need to put in
                        \ the nametable buffer to show this icon bar type on
                        \ the screen

 LDA iconBarType        \ Set (C Y) = iconBarType << 6
 ASL A                  \           = iconBarType * 64
 ASL A
 ASL A
 ASL A
 ASL A
 ASL A
 TAY

 BNE dbar1              \ If Y is non-zero (i.e. iconBarType = 1 to 3), jump to
                        \ dbar1 to set A = HI(barNames0)

 LDA #HI(barNames0)-1   \ Otherwise Y is zero (i.e. iconBarType = 0 or 4) so set
 BNE dbar2              \ A = HI(barNames0) - 1 and jump to dbar2 to skip the
                        \ following (this BNE is effectively a JMP as A is never
                        \ zero)

.dbar1

 LDA #HI(barNames0)     \ Set A = HI(barNames0) for when iconBarType = 1 to 3

.dbar2

                        \ When we get here, we have A set as follows:
                        \
                        \   * HI(barNames0) - 1        when iconBarType = 0 or 4
                        \
                        \   * HI(barNames0)            when iconBarType = 1 to 3

 DEY                    \ Decrement Y, so Y is now:
                        \
                        \   * &FF                     when iconBarType = 0 or 4
                        \
                        \   * iconBarType * 64 - 1    when iconBarType = 1 to 3

 STY V                  \ Set V(1 0) = (A 0) + (C 0) + Y
 ADC #0                 \
 STA V+1                \ So this sets V(1 0) to the following:
                        \
                        \   * When iconBarType = 0:
                        \
                        \       (HI(barNames0)-1 0) + (0 0) + &FF
                        \       (HI(barNames0)-1 0) + &FF
                        \     = (HI(barNames0)-1 0) + (1 0) - 1
                        \     = (HI(barNames0) 0) - 1
                        \     = (HI(barNames0) 0) + iconBarType * 64 - 1
                        \
                        \   * When iconBarType = 1 to 3
                        \
                        \       (HI(barNames0) 0) + (0 0) + iconBarType * 64 - 1
                        \     = (HI(barNames0) 0) + iconBarType * 64 - 1
                        \
                        \   * When iconBarType = 4
                        \
                        \       (HI(barNames0-1 0) + (1 0) + &FF
                        \     = (HI(barNames0-1 0) + (1 0) + (1 0) - 1
                        \     = (HI(barNames0) 0) + (1 0) - 1
                        \     = (HI(barNames0) 0) + 4 * 64 - 1
                        \     = (HI(barNames0) 0) + iconBarType * 64 - 1
                        \
                        \ In other words, V(1 0) is as follows, for all the icon
                        \ bar types:
                        \
                        \   V(1 0) = (HI(barNames0) 0) + iconBarType * 64 - 1
                        \
                        \ and because barNames0 is on a page boundary, we know
                        \ that LO(barNames0) = 0, so:
                        \
                        \   (HI(barNames0) 0) = (HI(barNames0) LO(barNames0))
                        \                     = barNames0(1 0)
                        \
                        \ So we have:
                        \
                        \   V(1 0) = barNames0(1 0) + iconBarType * 64 - 1
                        \
                        \ barNames0 through barNames4 each contain 64 bytes, for
                        \ the two rows of 32 tiles that make up the icon bar,
                        \ and they are one after the other in memory, so V(1 0)
                        \ therefore contains the address of the relevant table
                        \ for the current icon bar's nametable entries (i.e.
                        \ barNames0 to barNames4), minus 1
                        \
                        \ Let's refer to the relevant table from barNames0 to
                        \ barNames4 as barNames, to make things simpler, so we
                        \ have the following:
                        \
                        \   V(1 0) = barNames - 1

                        \ Next, we set SC(1 0) and SC2(1 0) to the addresses in
                        \ the two nametable buffers for the icon bar, so we can
                        \ write the nametable entries there to draw the icon bar
                        \ on-screen

 LDA QQ11               \ If bit 7 of the view type in QQ11 is set then there
 BMI dbar3              \ is no dashboard and the icon bar is at the bottom of
                        \ the screen, so jump to dbar3 to set SC(1 0) and
                        \ SC2(1 0) accordingly

 LDA #HI(nameBuffer0+20*32) \ Set SC(1 0) to the address of the first tile on
 STA SC+1                   \ tile row 20 in nametable buffer 0
 LDA #LO(nameBuffer0+20*32)
 STA SC

 LDA #HI(nameBuffer1+20*32) \ Set SC2(1 0) to the address of the first tile on
 STA SC2+1                  \ tile row 20 in nametable buffer 1
 LDA #LO(nameBuffer1+20*32)
 STA SC2

 JMP dbar4              \ Jump to dbar4 to skip the following

.dbar3

 LDA #HI(nameBuffer0+27*32) \ Set SC(1 0) to the address of the first tile on
 STA SC+1                   \ tile row 27 in nametable buffer 0
 LDA #LO(nameBuffer0+27*32)
 STA SC

 LDA #HI(nameBuffer1+27*32) \ Set SC2(1 0) to the address of the first tile on
 STA SC2+1                  \ tile row 27 in nametable buffer 1
 LDA #LO(nameBuffer1+27*32)
 STA SC2

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

.dbar4

                        \ By this point, we have the following:
                        \
                        \   * V(1 0) is the address of the icon bar's nametable
                        \     table (from barNames0 to barNames4), minus 1,
                        \     i.e. V(1 0) = barNames - 1
                        \
                        \   * SC(1 0) is the address of the nametable entries
                        \     for the on-screen icon bar in nametable buffer 0
                        \
                        \   * SC2(1 0) is the address of the nametable entries
                        \     for the on-screen icon bar in nametable buffer 1
                        \
                        \ So to draw the icon bar on-screen, we need to copy the
                        \ nametable entries from V(1 0) to both SC(1 0) and
                        \ SC2(1 0)

 LDY #63                \ Set Y as an index, which will count down from 63 to 1,
                        \ so we copy bytes 0 to 62 in V(1 0) to bytes 1 to 63
                        \ in the nametable buffers
                        \
                        \ We do this in two stages purely so we can clip in a
                        \ call to the SETUP_PPU_FOR_ICON_BAR macro

.dbar5

 LDA (V),Y              \ Copy the Y-th nametable entry from V(1 0) to SC(1 0)
 STA (SC),Y

 STA (SC2),Y            \ Copy the Y-th nametable entry from V(1 0) to SC2(1 0)

 DEY                    \ Decrement the index counter

 CPY #33                \ Loop back until we have done Y = 63 to 34
 BNE dbar5

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

.dbar6

 LDA (V),Y              \ Copy the Y-th nametable entry from V(1 0) to SC(1 0)
 STA (SC),Y

 STA (SC2),Y            \ Copy the Y-th nametable entry from V(1 0) to SC2(1 0)

 DEY                    \ Decrement the index counter

 BNE dbar6              \ Loop back until we have done Y = 33 to 1

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

                        \ By this point we have copied bytes 0 to 62 in V(1 0)
                        \ to bytes 1 to 63 in the nametable buffers, and because
                        \ V(1 0) = barNames - 1, this means we have copied
                        \ bytes 1 to 63 from the relevant barNames table to the
                        \ nametable buffers
                        \
                        \ This covers almost all of the two rows of 3 characters
                        \ that make up the icon bar, but it is one short, as we
                        \ aren't done yet
                        \
                        \ Because the horizontal scroll in PPU_SCROLL is set to
                        \ 8, the leftmost tile on each row is scrolled around to
                        \ the right side, which means that in terms of tiles,
                        \ column 1 is the left edge of the screen, then columns
                        \ 2 to 31 form the body of the screen, and column 0 is
                        \ the right edge of the screen
                        \
                        \ We therefore have to fix the tiles that appear at the
                        \ end of each row, i.e. column 0 on row 0 (for the end
                        \ of the top row of the icon bar) and column 0 on row 1
                        \ (for the end of the bottom row of the icon bar)

 LDY #32                \ Copy byte 32 from V(1 0), i.e. byte 31 of barNames,
 LDA (V),Y              \ to byte 0 of SC(1 0) and SC2(1 0), which moves the
 LDY #0                 \ tile at the end of the first row of the icon bar into
 STA (SC),Y             \ column 0 on row 0 (for the end of the top row of the
 STA (SC2),Y            \ icon bar on-screen)

 LDY #64                \ Copy byte 64 from V(1 0), i.e. byte 63 of barNames,
 LDA (V),Y              \ to byte 32 of SC(1 0) and SC2(1 0), which moves the
 LDY #32                \ tile at the end of the second row of the icon bar into
 STA (SC),Y             \ column 0 on row 1 (for the end of the bottom row of
 STA (SC2),Y            \ the icon bar on-screen)

 RTS                    \ Return from the subroutine

