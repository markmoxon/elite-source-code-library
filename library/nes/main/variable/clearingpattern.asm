.clearingPattern

 SKIP 1                 \ The number of the first pattern to clear in pattern
                        \ buffer 0 when the NMI handler clears patterns
                        \
                        \ This variable is saved by the NMI handler so the
                        \ buffers can be cleared across multiple VBlanks

 SKIP 1                 \ The number of the first pattern to clear in pattern
                        \ buffer 1 when the NMI handler clears patterns
                        \
                        \ This variable is saved by the NMI handler so the
                        \ buffers can be cleared across multiple VBlanks

