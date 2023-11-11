.iconBarKeyPress

 SKIP 1                 \ The button number of an icon bar button if an icon bar
                        \ button has been chosen
                        \
                        \ This gets set along with the key logger, copying the
                        \ value from iconBarChoice (the latter gets set in the
                        \ NMI handler with the icon bar button number, so
                        \ iconBarKeyPress effectively latches the value from
                        \ iconBarChoice)

