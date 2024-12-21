.COK

IF NOT(_NES_VERSION)

 SKIP 1                 \ Flags used to generate the competition code

ELIF _NES_VERSION

 SKIP 1                 \ A flag to record whether cheat mode has been applied
                        \ (by renaming the commander file to CHEATER, BETRUG or
                        \ TRICHER)
                        \
                        \   * Bit 7 clear = cheat mode has not been applied
                        \
                        \   * Bit 7 set = cheat mode has been applied

ENDIF

