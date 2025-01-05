\ ******************************************************************************
\
\       Name: brkd
\       Type: Variable
\   Category: Utility routines
\    Summary: A flag that indicates whether a system error has occured
\
\ ******************************************************************************

.brkd

 EQUB 0                 \ A flag to record whether a system error has occured,
                        \ so we can print it out
                        \
                        \   * 0 = no system error has occured
                        \
                        \   * &FF = a system error has occured

