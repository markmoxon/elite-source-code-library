.buffr2

 SKIP 350               \ A 342-byte buffer for storing data in the 6-bit nibble
                        \ format
                        \
                        \ This is where we load file data from the disk in the
                        \ 6-bit nibble format, so it can be post-nibblized into
                        \ 8-bit bytes and stored in buffer
                        \
                        \ It is also where we store nibblized data that is ready
                        \ to be saved to the disk

