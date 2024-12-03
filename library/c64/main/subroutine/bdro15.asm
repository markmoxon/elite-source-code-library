\ ******************************************************************************
\
\       Name: BDRO15
\       Type: Subroutine
\   Category: Sound
\    Summary: Process music command <#15> to rest for 2 * value4 interrupts
\
\ ******************************************************************************

.BDRO15

 LDA BDBUFF             \ Slide the value %1000 (8) into the low nibble of
 SEC                    \ BDBUFF while shifting the original low nibble into
 ROL A                  \ the high nibble
 ASL A                  \
 ASL A                  \ Because we process the low nibble first in each music
 ASL A                  \ data byte, this inserts command <#8> into the queue as
 STA BDBUFF             \ the next command to be processed, after we fall
                        \ through into BDRO8 to process another command <#8>
                        \ first
                        \
                        \ In other words, this processes two command <#8>s in a
                        \ row, which implements a double-length rest

                        \ Fall into BDRO8 to rest for value4 interrupts

