.allowInSystemJump

 SKIP 1                 \ Bits 6 and 7 record whether it is safe to perform an
                        \ in-system jump
                        \
                        \ Bits are set if, for example, hostile ships are in the
                        \ vicinity, or we are too near a station, the planet or
                        \ the sun
                        \
                        \ We can only do a jump if both bits are clear

