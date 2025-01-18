.dials

IF NOT(_APPLE_VERSION)

 SKIP 14                \ These bytes appear to be unused

ELIF _APPLE_VERSION

 SKIP 14                \ Current dashboard indicator values
                        \
                        \ The current value of each of the indicators on the
                        \ dashboard, so we can check whether an indicator's
                        \ value has changed when updating it

ENDIF


