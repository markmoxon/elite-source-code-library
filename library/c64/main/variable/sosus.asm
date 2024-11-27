.SOSUS

 EQUB 0                 \ Sound buffer for release length and sustain volume
 EQUB 0                 \
 EQUB 0                 \ SOATK,Y contains the release length and sustain volume
                        \ for the sound currently being made on voice Y
                        \
                        \   * Bits 0-3 = release length
                        \
                        \   * Bits 4-7 = sustain volume
                        \
                        \ These values come from the SFXSUS table, but can be
                        \ overridden manually using the NOISE2 routine

