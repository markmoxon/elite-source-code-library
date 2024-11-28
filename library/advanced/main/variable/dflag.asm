.DFLAG

IF NOT(_C64_VERSION)

 SKIP 1                 \ This byte appears to be unused

ELIF _C64_VERSION

 SKIP 1                 \ A flag that indicates whether the dashboard is
                        \ currently being shown on-screen
                        \
                        \   * 0 = there is no dashboard on-screen
                        \
                        \   * &FF = the dashboard is on-screen

ENDIF

