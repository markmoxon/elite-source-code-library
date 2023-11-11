.barPatternCounter

 SKIP 1                 \ The number of icon bar nametable and pattern entries
                        \ that need to be sent to the PPU in the NMI handler
                        \
                        \   * 0 = send the nametable entries and the first four
                        \         patterns in the next NMI call (and update
                        \         barPatternCounter to 4 when done)
                        \
                        \   * 1-127 = counts the number of pattern bytes already
                        \             sent to the PPU, which get sent in batches
                        \             of four patterns (32 bytes), split across
                        \             multiple NMI calls, until we have send all
                        \             32 patterns and the value is 128
                        \
                        \   * 128 = do not send any tiles

