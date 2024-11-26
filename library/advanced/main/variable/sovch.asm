.SOVCH

 EQUB 0                 \ Sound buffer for the volume change rate
 EQUB 0                 \
 EQUB 0                 \ SOVCH,Y contains the volumen change rate of the sound
                        \ currently being made on voice Y
                        \
                        \ The sound's volume gets reduced by one every SOVCH,Y
                        \ frames
                        \
                        \ These values come from the SFXVCH table

