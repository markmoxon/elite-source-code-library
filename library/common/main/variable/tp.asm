.TP

IF _CASSETTE_VERSION OR _ELECTRON_VERSION \ Comment

 SKIP 1                 \ The current mission status, which is always 0 for the
                        \ cassette version of Elite as there are no missions

ELIF _6502SP_VERSION OR _MASTER_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _C64_VERSION OR _APPLE_VERSION OR _NES_VERSION

 SKIP 1                 \ The current mission status
                        \
                        \   * Bits 0-1 = Mission 1 status
                        \
                        \     * %00 = Mission not started
                        \     * %01 = Mission in progress, hunting for ship
                        \     * %11 = Constrictor killed, not debriefed yet
                        \     * %10 = Mission and debrief complete
                        \
                        \   * Bits 2-3 = Mission 2 status
                        \
                        \     * %00 = Mission not started
                        \     * %01 = Mission in progress, plans not picked up
                        \     * %10 = Mission in progress, plans picked up
                        \     * %11 = Mission complete
ENDIF
IF _NES_VERSION OR _C64_VERSION
                        \
                        \   * Bit 4 = Trumble mission status
                        \
                        \     * %0 = Trumbles not yet offered
                        \     * %1 = Trumbles accepted or declined

ENDIF

