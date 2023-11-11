.skipBarPatternsPPU

 SKIP 1                 \ A flag to control whether to send the icon bar's
                        \ patterns to the PPU, after sending the nametable
                        \ entries (this only applies if barPatternCounter = 0)
                        \
                        \   * Bit 7 set = do not send patterns
                        \
                        \   * Bit 7 clear = send patterns
                        \
                        \ This means that if barPatternCounter is set to zero
                        \ and bit 7 of skipBarPatternsPPU is set, then only the
                        \ nametable entries for the icon bar will be sent to the
                        \ PPU, but if barPatternCounter is set to zero and bit 7
                        \ of skipBarPatternsPPU is clear, both the nametable
                        \ entries and patterns will be sent

