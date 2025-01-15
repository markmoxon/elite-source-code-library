.UPTOG

IF NOT(_APPLE_VERSION)

 SKIP 1                 \ The configuration setting for toggle key "U", which
                        \ isn't actually used but is still updated by pressing
                        \ "U" while the game is paused. This is a configuration
                        \ option from the Apple II version of Elite that lets
                        \ you switch between lower-case and upper-case text

ELIF _APPLE_VERSION

 SKIP 1                 \ Upper case configuration setting
                        \
                        \   * 0 = display upper and lower case letters (default)
                        \
                        \   * &FF = only display upper case letters
                        \
                        \ Toggled by pressing "U" when paused, see the DK4
                        \ routine for details

ENDIF

