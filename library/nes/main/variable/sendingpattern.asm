.sendingPattern

 SKIP 1                 \ The number of the most recent pattern that was sent to
                        \ the PPU pattern table by the NMI handler for bitplane
                        \ 0 (or the number of the first pattern to send if none
                        \ have been sent)
                        \
                        \ This variable is saved by the NMI handler so the
                        \ buffers can be cleared across multiple VBlanks

 SKIP 1                 \ The number of the most recent pattern that was sent to
                        \ the PPU pattern table by the NMI handler for bitplane
                        \ 1 (or the number of the first pattern to send if none
                        \ have been sent)
                        \
                        \ This variable is saved by the NMI handler so the
                        \ buffers can be cleared across multiple VBlanks

