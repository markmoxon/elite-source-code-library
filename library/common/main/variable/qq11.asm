.QQ11

 SKIP 1                 \ The number of the current view:
                        \
                        \   0   = Space view
                        \   1   = Title screen
                        \         Buy Cargo screen (red key f1)
                        \         Data on System screen (red key f6)
                        \         Get commander name ("@", save/load commander)
                        \         In-system jump just arrived ("J")
IF _CASSETTE_VERSION
                        \         Mis-jump just arrived (witchspace)
ELIF _6502SP_VERSION
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
                        \
                        \ This value is typically set by calling routine TT66

