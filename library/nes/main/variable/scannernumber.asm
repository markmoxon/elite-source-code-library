.scannerNumber

 SKIP 10                \ Details of which scanner numbers are allocated to
                        \ ships on the scanner
                        \
                        \ Bytes 1 to 8 contain the following:
                        \
                        \   * &FF indicates that this scanner number (1 to 8)
                        \     is allocated to a ship so that is it shown on
                        \     the scanner (the scanner number is stored in byte
                        \     #33 of the ship's data block)
                        \
                        \   * 0 indicates that this scanner number (1 to 8) is
                        \     not yet allocated to a ship
                        \
                        \ Bytes 0 and 9 in the table are unused

