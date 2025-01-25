.buffer

 SKIP 48                \ A 256-byte sector buffer, where we can load sectors
                        \ from the disk, such as the track/sector list, or the
                        \ commander file contents
                        \
                        \ For file data, this is where we store the data that
                        \ we want to save, before it is pre-nibblized into
                        \ 6-bit nibbles in buff2 by the prenib routine
                        \
                        \ It is also where file data is stored after being
                        \ post-nibblized, in which case the 6-bit nibbles in
                        \ buffr2 are converted into 8-bit bytes and stored here

