.DISK

IF NOT(_C64_VERSION)

 SKIP 1                 \ The configuration setting for toggle key "T", which
                        \ isn't actually used but is still updated by pressing
                        \ "T" while the game is paused. This is a configuration
                        \ option from some non-BBC versions of Elite that lets
                        \ you switch between tape and disc

ELIF _C64_VERSION

 SKIP 1                 \ Current media configuration setting
                        \
                        \   * 0 = tape (default)
                        \
                        \   * &FF = disk
                        \
                        \ Toggled by pressing "D" when paused, see the DK4
                        \ routine for details

ENDIF
