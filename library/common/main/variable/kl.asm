.KL

IF NOT(_NES_VERSION)

 SKIP 1                 \ The following bytes implement a key logger that
                        \ enables Elite to scan for concurrent key presses of
                        \ the primary flight keys, plus a secondary flight key
                        \
                        \ See the deep dive on "The key logger" for more details
                        \
                        \ If a key is being pressed that is not in the keyboard
                        \ table at KYTB, it can be stored here (as seen in
                        \ routine DK4, for example)

ELIF _NES_VERSION

 SKIP 0                 \ The following bytes implement a key logger that gets
                        \ updated according to the controller button presses
                        \
                        \ This enables code from the BBC Micro version to be
                        \ reused without rewriting the key press logic to work
                        \ with the NES controllers, as it's easier just to
                        \ populate the BBC's key logger table, so the code
                        \ thinks that keys are being pressed when they are
                        \ actually controller buttons

ENDIF

