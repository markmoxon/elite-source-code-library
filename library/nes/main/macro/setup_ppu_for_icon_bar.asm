\ ******************************************************************************
\
\       Name: SETUP_PPU_FOR_ICON_BAR
\       Type: Macro
\   Category: PPU
\    Summary: If the PPU has started drawing the icon bar, configure the PPU to
\             use nametable 0 and pattern table 0
\
\ ------------------------------------------------------------------------------
\
\ The following macro is used to ensure the game switches to the correct PPU
\ nametable and pattern table for drawing the icon bar:
\
\   SETUP_PPU_FOR_ICON_BAR
\
\ It checks whether the PPU has started drawing the icon bar (which it does
\ using sprite 0), and if it has it switches the PPU to nametable 0 and pattern
\ table 0, as that's where the icon bar tiles live.
\
\ There are no arguments.
\
\ ******************************************************************************

MACRO SETUP_PPU_FOR_ICON_BAR

 LDA setupPPUForIconBar \ If bit 7 of setupPPUForIconBar is clear then jump to
 BPL skip               \ skip1, so we only update the PPU if bit 7 is set
                        \
                        \ Bit 7 of setupPPUForIconBar is set when there is an
                        \ on-screen user interface (i.e. an icon bar), and it
                        \ is only clear if we are on the game over screen, which
                        \ doesn't have an icon bar

 LDA PPU_STATUS         \ If bit 6 of PPU_STATUS is clear then jump to skip1,
 ASL A                  \ so we only update the PPU if bit 6 is set
 BPL skip               \
                        \ Bit 6 of PPU_STATUS is the sprite 0 hit flag, which is
                        \ set when a non-transparent pixel in sprite 0 is drawn
                        \ over a non-transparent background pixel
                        \
                        \ It gets zeroed at the start of each frame and set when
                        \ sprite 0 is drawn
                        \
                        \ Sprite 0 is at the bottom-right corner of the space
                        \ view, at coordinates (248, 163), so this means bit 6
                        \ of PPU_STATUS gets set when the PPU starts drawing the
                        \ icon bar

 JSR SetPPUTablesTo0    \ If we get here then both bit 7 of setupPPUForIconBar
                        \ and bit 6 of PPU_STATUS are set, which means there is
                        \ an icon bar on-screen and the PPU has just started
                        \ drawing it, so we call SetPPUTablesTo0 to:
                        \
                        \   * Zero setupPPUForIconBar to disable this process
                        \     until the next NMI interrupt at the next VBlank
                        \
                        \   * Clear bits 0 and 4 of PPU_CTRL, to set the base
                        \     nametable address to $2000 (for nametable 0) and
                        \     the pattern table to $0000 (for pattern table 0)
                        \
                        \   * Clear the C flag

.skip

ENDMACRO

