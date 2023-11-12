.patternBufferHi

 SKIP 1                 \ (patternBufferHi patternBufferLo) contains the address
                        \ of the pattern buffer for the pattern we are sending
                        \ to the PPU from bitplane 0 (i.e. for pattern number
                        \ sendingPattern in bitplane 0)
                        \
                        \ This variable is saved by the NMI handler so the
                        \ buffers can be cleared across multiple VBlanks

 SKIP 1                 \ (patternBufferHi patternBufferLo) contains the address
                        \ of the pattern buffer for the pattern we are sending
                        \ to the PPU from bitplane 1 (i.e. for pattern number
                        \ sendingPattern in bitplane 1)
                        \
                        \ This variable is saved by the NMI handler so the
                        \ buffers can be cleared across multiple VBlanks

