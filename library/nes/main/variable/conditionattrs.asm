\ ******************************************************************************
\
\       Name: conditionAttrs
\       Type: Variable
\   Category: Dashboard
\    Summary: Sprite attributes for the status condition indicator on the
\             dashboard
\
\ ******************************************************************************

.conditionAttrs

 EQUB %00100001         \ Attributes for sprite when condition is docked:
                        \
                        \   * Bits 0-1    = sprite palette 1
                        \   * Bit 5 set   = show behind background
                        \   * Bit 6 clear = do not flip horizontally
                        \   * Bit 7 clear = do not flip vertically

 EQUB %00100000         \ Attributes for sprite when condition is green:
                        \
                        \   * Bits 0-1    = sprite palette 0
                        \   * Bit 5 set   = show behind background
                        \   * Bit 6 clear = do not flip horizontally
                        \   * Bit 7 clear = do not flip vertically

 EQUB %00100010         \ Attributes for sprite when condition is yellow
                        \
                        \   * Bits 0-1    = sprite palette 2
                        \   * Bit 5 set   = show behind background
                        \   * Bit 6 clear = do not flip horizontally
                        \   * Bit 7 clear = do not flip vertically

 EQUB %00100010         \ Attributes for sprite when condition is red
                        \
                        \   * Bits 0-1    = sprite palette 2
                        \   * Bit 5 set   = show behind background
                        \   * Bit 6 clear = do not flip horizontally
                        \   * Bit 7 clear = do not flip vertically

