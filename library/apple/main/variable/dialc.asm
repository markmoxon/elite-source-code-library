.dialc

IF _MASTER_VERSION

 SKIP 14                \ These bytes are unused in this version of Elite
                        \
                        \ They are left over from the Apple II version, where
                        \ they are used to store the current colour of the
                        \ dashboard indicators

ELIF _APPLE_VERSION

 SKIP 14                \ Current dashboard indicator colours
                        \
                        \ The current colour of each of the indicators on the
                        \ dashboard, so we can check whether an indicator's
                        \ colour has changed when updating it

ENDIF

