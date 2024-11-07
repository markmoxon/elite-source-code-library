.LASER

 SKIP 4                 \ The specifications of the lasers fitted to each of the
                        \ four space views:
                        \
                        \   * Byte #0 = front view
                        \   * Byte #1 = rear view
                        \   * Byte #2 = left view
                        \   * Byte #3 = right view
                        \
                        \ For each of the views:
                        \
                        \   * 0 = no laser is fitted to this view
                        \
                        \   * Non-zero = a laser is fitted to this view, with
                        \     the following specification:
                        \
                        \     * Bits 0-6 contain the laser's power
                        \
                        \     * Bit 7 determines whether or not the laser pulses
IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Comment
                        \       (0 = pulse laser) or is always on (1 = beam
                        \       laser)
ELIF _6502SP_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _MASTER_VERSION OR _NES_VERSION
                        \       (0 = pulse or mining laser) or is always on
                        \       (1 = beam or military laser)
ENDIF

