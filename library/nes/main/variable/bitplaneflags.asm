.bitplaneFlags

 SKIP 1                 \ Flags for bitplane 0 that control the sending of data
                        \ for this bitplane to the PPU during VBlank in the NMI
                        \ handler:
                        \
                        \   * Bit 0 is ignored and is always clear
                        \
                        \   * Bit 1 is ignored and is always clear
                        \
                        \   * Bit 2 controls whether to override the number of
                        \     the last tile or pattern to send to the PPU:
                        \
                        \     * 0 = set the last tile number to lastNameTile or
                        \           the last pattern to lastPattern for this
                        \           bitplane (when sending nametable and pattern
                        \           entries respectively)
                        \
                        \     * 1 = set the last tile number to 128 (which means
                        \           tile 8 * 128 = 1024)
                        \
                        \   * Bit 3 controls the clearing of this bitplane's
                        \     buffer in the NMI handler, once it has been sent
                        \     to the PPU:
                        \
                        \     * 0 = do not clear this bitplane's buffer
                        \
                        \     * 1 = clear this bitplane's buffer once it has
                        \           been sent to the PPU
                        \
                        \   * Bit 4 lets us query whether a tile data transfer
                        \     is already in progress for this bitplane:
                        \
                        \     * 0 = we are not currently in the process of
                        \           sending tile data to the PPU for this
                        \           bitplane
                        \
                        \     * 1 = we are in the process of sending tile data
                        \           to the PPU for the this bitplane, possibly
                        \           spread across multiple VBlanks
                        \
                        \   * Bit 5 lets us query whether we have already sent
                        \     all the data to the PPU for this bitplane:
                        \
                        \     * 0 = we have not already sent all the data to the
                        \           PPU for this bitplane
                        \
                        \     * 1 = we have already sent all the data to the PPU
                        \           for this bitplane
                        \
                        \   * Bit 6 determines whether to send nametable data as
                        \     well as pattern data:
                        \
                        \     * 0 = only send pattern data for this bitplane,
                        \           and stop sending it if the other bitplane is
                        \           ready to be sent
                        \
                        \     * 1 = send both pattern and nametable data for
                        \           this bitplane
                        \
                        \   * Bit 7 determines whether we should send data to
                        \     the PPU for this bitplane:
                        \
                        \     * 0 = do not send data to the PPU
                        \
                        \     * 1 = send data to the PPU

 SKIP 1                 \ Flags for bitplane 1 (see above)

