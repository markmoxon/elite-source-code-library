.TP

IF _CASSETTE_VERSION OR _DISC_VERSION \ Comment

 SKIP 1                 \ The current mission status, which is always 0 for the
                        \ cassette version of Elite as there are no missions

ELIF _6502SP_VERSION

 SKIP 1                 \ The current mission status:
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

