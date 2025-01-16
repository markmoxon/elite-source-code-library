.DL

IF _CASSETTE_VERSION OR _DISC_VERSION OR _ELITE_A_VERSION OR _6502SP_VERSION OR _MASTER_VERSION \ Platform

 SKIP 1                 \ Vertical sync flag
                        \
                        \ DL gets set to 30 every time we reach vertical sync on
                        \ the video system, which happens 50 times a second
                        \ (50Hz). The WSCAN routine uses this to pause until the
                        \ vertical sync, by setting DL to 0 and then monitoring
                        \ its value until it changes to 30

ELIF _ELECTRON_VERSION OR _C64_VERSION OR _APPLE_VERSION

 SKIP 1                 \ This byte is unused in this version of Elite (it is
                        \ used to store the vertical sync flag in the BBC Micro
                        \ versions)

ENDIF
