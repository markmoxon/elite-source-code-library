.SOATK

 EQUB 0                 \ Sound buffer for attack and decay lengths
 EQUB 0                 \
 EQUB 0                 \ SOATK,Y contains the attack and decay length for the
                        \ sound currently being made on voice Y
                        \
                        \   * Bits 0-3 = decay length
                        \
                        \   * Bits 4-7 = attack length
                        \
                        \ These values come from the SFXATK table

