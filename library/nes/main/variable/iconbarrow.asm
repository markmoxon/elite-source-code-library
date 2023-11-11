.iconBarRow

 SKIP 2                 \ The row on which the icon bar appears
                        \
                        \ This is stored as an offset from the start of the
                        \ nametable buffer, so it's the number of the nametable
                        \ entry for the top-left tile of the icon bar
                        \
                        \ This can have two values:
                        \
                        \   * 20*32 = icon bar is on row 20 (just above the
                        \             dashboard)
                        \
                        \   * 27*32 = icon bar is on tow 27 (at the bottom of
                        \             the screen, where there is no dashboard)

