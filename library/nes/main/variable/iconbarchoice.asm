.iconBarChoice

 SKIP 1                 \ The number of the icon bar button that's just been
                        \ selected
                        \
                        \   * 0 means no button has been selected
                        \
                        \   * A button number from the iconBarButtons table
                        \     means that button has been selected by pressing
                        \     Select on that button (or the B button has been
                        \     tapped twice)
                        \
                        \   * 80 means the Start has been pressed to pause the
                        \     game
                        \
                        \ This variable is set in the NMI handler, so the
                        \ selection is recorded in the background

