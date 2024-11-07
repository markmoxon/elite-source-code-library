.thiskey

IF _C64_VERSION

 SKIP 1                 \ The following bytes implement a key logger that
                        \ enables Elite to scan for concurrent key presses of
                        \ the primary flight keys, plus a secondary flight key
                        \
                        \ See the deep dive on "The key logger" for more details
                        \
                        \ If a key is being pressed that is not in the keyboard
                        \ table at KYTB, it can be stored here (as seen in
                        \ routine DK4, for example)

ELIF _APPLE_VERSION

 SKIP 0                 \ If a key is being pressed that is not in the keyboard
                        \ table at KYTB, it can be stored in KL and thisley (as
                        \ seen in routine DK4, for example)

ENDIF

