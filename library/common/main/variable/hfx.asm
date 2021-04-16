.HFX

 SKIP 1                 \ A flag that toggles the hyperspace colour effect
                        \
                        \   * 0 = no colour effect
                        \
                        \   * Non-zero = hyperspace colour effect enabled
                        \
IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION \ Comment
                        \ When HFS is set to 1, the mode 4 screen that makes
                        \ up the top part of the display is temporarily switched
                        \ to mode 5 (the same screen mode as the dashboard),
                        \ which has the effect of blurring and colouring the
                        \ hyperspace rings in the top part of the screen. The
                        \ code to do this is in the LINSCN routine, which is
                        \ called as part of the screen mode routine at IRQ1.
                        \ It's in LINSCN that HFX is checked, and if it is
                        \ non-zero, the top part of the screen is not switched
                        \ to mode 4, thus leaving the top part of the screen in
                        \ the more colourful mode 5
ELIF _6502SP_VERSION
                        \ When HFS is set to 1, the mode 1 screen that makes
                        \ up the top part of the display is temporarily switched
                        \ to mode 2 (the same screen mode as the dashboard),
                        \ which has the effect of blurring and colouring the
                        \ hyperspace rings in the top part of the screen. The
                        \ code to do this is in the LINSCN routine, which is
                        \ called as part of the screen mode routine at IRQ1.
                        \ It's in LINSCN that HFX is checked, and if it is
                        \ non-zero, the top part of the screen is not switched
                        \ to mode 1, thus leaving the top part of the screen in
                        \ the more colourful mode 2
ENDIF

