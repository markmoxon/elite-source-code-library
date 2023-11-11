.updatePaletteInNMI

 SKIP 1                 \ A flag that controls whether to send the palette data
                        \ from XX3 to the PPU during NMI:
                        \
                        \   * 0 = do not send palette data
                        \
                        \   * Non-zero = do send palette data

