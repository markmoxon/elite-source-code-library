IF NOT(_ELITE_A_VERSION)

 SKIP 2                 \ These bytes appear to be unused (they were originally
                        \ used for up/down lasers, but they were dropped)

ELIF _ELITE_A_VERSION

 SKIP 1                 \ This byte appears to be unused

.new_type
.cmdr_ship

 SKIP 1                 \ AJD

ENDIF

