.KY12

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Comment
 SKIP 1                 \ TAB is being pressed
ELIF _ELECTRON_VERSION
 SKIP 1                 \ "-" is being pressed
ELIF _APPLE_VERSION
 SKIP 1                 \ "B" is being pressed
ELIF _C64_VERSION
 EQUS "4"               \ "C=" is being pressed
ENDIF
                        \
                        \   * 0 = no
                        \
                        \   * Non-zero = yes

