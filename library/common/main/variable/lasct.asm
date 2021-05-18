.LASCT

 SKIP 1                 \ The laser pulse count for the current laser
                        \
                        \ This is a counter that defines the gap between the
                        \ pulses of a pulse laser. It is set as follows:
                        \
                        \   * 0 for a beam laser
                        \
                        \   * 10 for a pulse laser
                        \
IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Comment
                        \ It gets decremented every vertical sync (in the LINSCN
                        \ routine, which is called 50 times a second) and is set
                        \ to a non-zero value for pulse lasers only
                        \
                        \ The laser only fires when the value of LASCT hits
                        \ zero, so for pulse lasers with a value of 10, that
                        \ means the laser fires once every 10 vertical syncs (or
                        \ 5 times a second)
ELIF _ELECTRON_VERSION
                        \ It gets decremented by 4 on each iteration round the
                        \ main game loop and is set to a non-zero value for
                        \ pulse lasers only
                        \
                        \ The laser only fires when the value of LASCT hits
                        \ zero, so for pulse lasers with a value of 10, that
                        \ means the laser fires once every four iterations
                        \ round the main game loop (LASCT = 10, 6, 2, 0)
ENDIF
                        \
                        \ In comparison, beam lasers fire continuously as the
                        \ value of LASCT is always 0

