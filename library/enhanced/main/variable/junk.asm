.JUNK

 SKIP 1                 \ The amount of junk in the local bubble
                        \
                        \ "Junk" is defined as being one of these:
                        \
                        \   * Escape pod
                        \   * Alloy plate
                        \   * Cargo canister
                        \   * Asteroid
                        \   * Splinter
                        \   * Shuttle
                        \   * Transporter
IF _DISC_VERSION OR _ELITE_A_VERSION \ Comment
                        \
                        \ Junk is the range of ship types from #JL to #JH - 1

ELIF _6502SP_VERSION
                        \   * Rock hermit
                        \
                        \ Apart from the rock hermit, junk is the range of ship
                        \ types from #JL to #JH - 1

ENDIF

