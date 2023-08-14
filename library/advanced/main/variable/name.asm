.NAME

IF NOT(_NES_VERSION)

 SKIP 8                 \ The current commander name
                        \
                        \ The commander name can be up to 7 characters (the DFS
                        \ limit for filenames), and is terminated by a carriage
                        \ return

ELIF _NES_VERSION

 SKIP 7                 \ The current commander name
                        \
                        \ The commander name can be up to 7 characters long

ENDIF

