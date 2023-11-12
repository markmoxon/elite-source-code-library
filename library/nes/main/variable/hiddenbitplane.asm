.hiddenBitplane

 SKIP 1                 \ The bitplane that is currently hidden from view in the
                        \ space view
                        \
                        \   * 0 = bitplane 0 is hidden, so:
                        \         * Colour %01 (1) is the hidden colour (black)
                        \         * Colour %10 (2) is the visible colour (cyan)
                        \
                        \   * 1 = bitplane 1 is hidden, so:
                        \         * Colour %01 (1) is the visible colour (cyan)
                        \         * Colour %10 (2) is the hidden colour (black)
                        \
                        \ Note that bitplane 0 corresponds to bit 0 of the
                        \ colour number, while bitplane 1 corresponds to bit 1
                        \ of the colour number (as this is how the NES stores
                        \ pattern data - the first block of eight bytes in each
                        \ pattern controls bit 0 of the colour, while the second
                        \ block controls bit 1)
                        \
                        \ In other words:
                        \
                        \   * Bitplane 0 = bit 0 = colour %01 = colour 1
                        \
                        \   * Bitplane 1 = bit 1 = colour %10 = colour 2

