.SOFLG

 EQUB 0                 \ Sound buffer for sound effect flags
 EQUB 0                 \
 EQUB 0                 \ SOFLG,Y contains the following:
                        \
                        \   * Bits 0-5: sound effect number + 1 of the sound
                        \               currently being made on voice Y
                        \
                        \   * Bit 7 is set if this is a new sound being made,
                        \     rather than one that is in progress

