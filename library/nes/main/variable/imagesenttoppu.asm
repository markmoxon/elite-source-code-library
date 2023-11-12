.imageSentToPPU

 SKIP 1                 \ Records when images have been sent to the PPU or
                        \ unpacked into the buffers, so we don't repeat the
                        \ process unnecessarily
                        \
                        \   * 0 = dashboard image has been sent to the PPU
                        \
                        \   * 1 = font image has been sent to the PPU
                        \
                        \   * 2 = Cobra Mk III image has been sent to the PPU
                        \         for the Equip Ship screen
                        \
                        \   * 3 = the small Elite logo has been sent to the PPU
                        \         for the Save and Load screen
                        \
                        \   * 245 = the inventory icon image has been sent to
                        \           the PPU for the Market Price screen
                        \
                        \   * %1000xxxx = the headshot image has been sent to
                        \                 the PPU for the Status Mode screen,
                        \                 where %xxxx is the headshot number
                        \                 (0-13)
                        \
                        \   * %1100xxxx = the system background image has been
                        \                 unpacked into the buffers for the Data
                        \                 on System screen, where %xxxx is the
                        \                 system image number (0-14)

