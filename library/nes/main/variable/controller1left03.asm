.controller1Left03

 SKIP 1                 \ Bits 0 to 3 of the left button controller variable
                        \
                        \ In non-space views, this contains controller1Left but
                        \ shifted left by four places, so the high nibble
                        \ contains bits 0 to 3 of controller1Left, with zeroes
                        \ in the low nibble
                        \
                        \ So bit 7 is the left button state from four VBlanks
                        \ ago, bit 6 is from five VBlanks ago, and so on

