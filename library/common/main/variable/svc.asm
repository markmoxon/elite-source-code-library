.SVC

IF NOT(_NES_VERSION)

 SKIP 1                 \ The save count
                        \
                        \ When a new commander is created, the save count gets
                        \ set to 128. This value gets halved each time the
                        \ commander file is saved, but it is otherwise unused.
                        \ It is presumably part of the security system for the
                        \ competition, possibly another flag to catch out
                        \ entries with manually altered commander files

 SKIP 2                 \ The commander file checksum
                        \
                        \ These two bytes are reserved for the commander file
                        \ checksum, so when the current commander block is
                        \ copied from here to the last saved commander block at
                        \ NA%, CHK and CHK2 get overwritten

ELIF _NES_VERSION

 SKIP 1                 \ The save count
                        \
                        \   * Bits 0-6 contains the save count, which gets
                        \     incremented when buying or selling equipment or
                        \     cargo, or launching from a station (at which point
                        \     bit 7 also gets set, so we only increment once
                        \     between each save)
                        \
                        \   * Bit 7:
                        \
                        \       * 0 = The save counter can be incremented
                        \
                        \       * 1 = We have already incremented the save
                        \             counter for this commander but have not
                        \             saved it yet, so do not increment it again
                        \             until the file is saved (at which point we
                        \             clear bit 7 again)

ENDIF

IF _C64_VERSION OR _APPLE_VERSION

 SKIP 1                 \ The second commander file checksum
                        \
                        \ This byte is reserved for the second commander file
                        \ checksum in CHK3

ENDIF

IF _CASSETTE_VERSION OR _ELECTRON_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION \ Platform

 NT% = SVC + 2 - TP     \ This sets the variable NT% to the size of the current
                        \ commander data block, which starts at TP and ends at
                        \ SVC+2 (inclusive)

ELIF _MASTER_VERSION OR _C64_VERSION OR _APPLE_VERSION

 NT% = SVC + 3 - TP     \ This sets the variable NT% to the size of the current
                        \ commander data block, which starts at TP and ends at
                        \ SVC+3 (inclusive), i.e. with the last checksum byte

ENDIF

