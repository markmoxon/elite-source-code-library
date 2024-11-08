.PATG

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _C64_VERSION OR _MASTER_VERSION \ Comment

 SKIP 1                 \ Configuration setting to show the author names on the
                        \ start-up screen and enable manual hyperspace mis-jumps
                        \
                        \   * 0 = no author names or manual mis-jumps (default)
                        \
                        \   * &FF = show author names and allow manual mis-jumps
                        \
                        \ Toggled by pressing "X" when paused, see the DKS3
                        \ routine for details
                        \
                        \ This needs to be turned on for manual mis-jumps to be
                        \ possible. To do a manual mis-jump, first toggle the
                        \ author display by pausing the game and pressing "X",
                        \ and during the next hyperspace, hold down CTRL to
                        \ force a mis-jump. See routine ee5 for the "AND PATG"
                        \ instruction that implements this logic

ELIF _ELECTRON_VERSION

 SKIP 1                 \ Configuration setting to show the author names on the
                        \ start-up screen
                        \
                        \   * 0 = no author names (default)
                        \
                        \   * &FF = show author names
                        \
                        \ Toggled by pressing "X" when paused, see the DKS3
                        \ routine for details

ELIF _APPLE_VERSION

 SKIP 1                 \ Configuration setting to show the author names on the
                        \ start-up screen and enable manual hyperspace mis-jumps
                        \
                        \   * 0 = no author names or manual mis-jumps (default)
                        \
                        \   * &FF = show author names and allow manual mis-jumps
                        \
                        \ Toggled by pressing "X" when paused, see the DKS3
                        \ routine for details
                        \
                        \ This needs to be turned on for manual mis-jumps to be
                        \ possible. To do a manual mis-jump, first toggle the
                        \ author display by pausing the game and pressing "X",
                        \ and during the next hyperspace, hold down ??? to
                        \ force a mis-jump. See routine ee5 for the "AND PATG"
                        \ instruction that implements this logic

ENDIF

