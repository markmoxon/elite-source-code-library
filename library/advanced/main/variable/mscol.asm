.mscol

IF NOT(_APPLE_VERSION)

 SKIP 4                 \ This byte appears to be unused

ELIF _APPLE_VERSION

 SKIP 4                 \ Current missile indicator colours
                        \
                        \ The current colour of each of the missile indicators
                        \ on the dashboard, so we can check whether an
                        \ indicator's colour has changed when updating it

ENDIF

