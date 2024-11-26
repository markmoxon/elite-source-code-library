.SOCNT

 EQUB 0                 \ Sound buffer for sound effect counters
 EQUB 0                 \
 EQUB 0                 \ SOCNT,Y contains the counter of the sound currently
                        \ being made on voice Y
                        \
                        \ The counter decrements each frame, and when it reaches
                        \ zero, the sound effect has finished
                        \
                        \ These values come from the SFXCNT table

