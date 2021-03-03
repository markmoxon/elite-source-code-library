.QQ11

 SKIP 1                 \ The number of the current view:
                        \
                        \   0   = Space view
                        \   1   = Title screen
                        \         Get commander name ("@", save/load commander)
                        \         In-system jump just arrived ("J")
                        \         Data on System screen (red key f6)
IF _CASSETTE_VERSION OR _DISC_VERSION \ Comment
                        \         Buy Cargo screen (red key f1)
                        \         Mis-jump just arrived (witchspace)
ELIF _6502SP_VERSION
                        \   2   = Buy Cargo screen (red key f1)
                        \   3   = Mis-jump just arrived (witchspace)
ENDIF
                        \   4   = Sell Cargo screen (red key f2)
                        \   6   = Death screen
                        \   8   = Status Mode screen (red key f8)
                        \         Inventory screen (red key f9)
                        \   16  = Market Price screen (red key f7)
                        \   32  = Equip Ship screen (red key f3)
                        \   64  = Long-range Chart (red key f4)
                        \   128 = Short-range Chart (red key f5)
IF _6502SP_VERSION \ Comment
                        \   255 = Launch view
ENDIF
                        \
                        \ This value is typically set by calling routine TT66

