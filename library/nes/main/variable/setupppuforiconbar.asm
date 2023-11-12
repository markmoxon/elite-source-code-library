.setupPPUForIconBar

 SKIP 1                 \ Controls whether we force the nametable and pattern
                        \ table to 0 when the PPU starts drawing the icon bar
                        \
                        \   * Bit 7 clear = do nothing when the PPU starts
                        \                   drawing the icon bar
                        \
                        \   * Bit 7 set = configure the PPU to display nametable
                        \                 0 and pattern table 0 when the PPU
                        \                 starts drawing the icon bar

