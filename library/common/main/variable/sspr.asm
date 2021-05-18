.SSPR

 SKIP NTY + 1 - SST     \ "Space station present" flag
                        \
                        \   * Non-zero if we are inside the space station's safe
                        \     zone
                        \
IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Comment
                        \   * 0 if we aren't (in which case we can show the sun)
ELIF _ELECTRON_VERSION
                        \   * 0 if we aren't
ENDIF
                        \
                        \ This flag is at MANY+SST, which is no coincidence, as
                        \ MANY+SST is a count of how many space stations there
                        \ are in our local bubble, which is the same as saying
                        \ "space station present"

