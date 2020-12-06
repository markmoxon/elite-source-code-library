.NEEDKEY

 SKIP 1                 \ Flag to ask the I/O processor to update the key logger
                        \ buffer at KTRAN
                        \
                        \   * 0 = do not update KTRAN
                        \
                        \   * Non-zero = Ask the I/O processor to update KTRAN
                        \     in the next call to LL9 or DOKEY
                        \
                        \ A non-zero value has the following effect:
                        \
                        \   * When DOKEY is called to scan for primary flight
                        \     keys, the key logger buffer is updated before the
                        \     key logger is updated
                        \
                        \   * When drawing ships in LL9, the keyboard is scanned
                        \     for key presses, which is used in the title screen
                        \     and mission briefings

