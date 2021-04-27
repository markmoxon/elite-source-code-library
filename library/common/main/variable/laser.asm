.LASER

 SKIP 4                 \ The specifications of the lasers fitted to each of the
                        \ four space views:
                        \
IF _CASSETTE_VERSION OR _6502SP_VERSION OR _DISC_VERSION OR _MASTER_VERSION \ Comment
                        \   * Byte #0 = front view (red key f0)
                        \   * Byte #1 = rear view (red key f1)
                        \   * Byte #2 = left view (red key f2)
                        \   * Byte #3 = right view (red key f3)
ELIF _ELECTRON_VERSION
                        \   * Byte #0 = front view (FUNC-1)
                        \   * Byte #1 = rear view (FUNC-2)
                        \   * Byte #2 = left view (FUNC-3)
                        \   * Byte #3 = right view (FUNC-4)
ENDIF
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
ELIF _6502SP_VERSION OR _DISC_VERSION OR _MASTER_VERSION
                        \       (0 = pulse or mining laser) or is always on
                        \       (1 = beam or military laser)
ENDIF

