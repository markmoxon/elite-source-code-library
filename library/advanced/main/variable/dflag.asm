.DFLAG

IF NOT(_C64_VERSION)

 SKIP 1                 \ This byte appears to be unused

ELIF _C64_VERSION

 SKIP 1                 \ A flag to indicate whether we need to show the
                        \ dashboard on-screen in the current view (as it is
                        \ hidden for the trading screens) ???
                        \
                        \   * 0 = do show the dashboard
                        \
                        \   * &FF = do not show the dashboard

ENDIF

