.SOFRQ

 EQUB 0                 \ Sound buffer for sound effect frequencies
 EQUB 0                 \
 EQUB 0                 \ SOFRQ,Y contains the frequency of the sound currently
                        \ being made on voice Y
                        \
                        \ These values come from the SFXFQ table, and have the
                        \ frequency change from the SFXFRCH table applied in
                        \ each frame
IF _C64_VERSION
                        \
                        \ The frequency sent to the SID chip is SOFRQ * 64
ENDIF

