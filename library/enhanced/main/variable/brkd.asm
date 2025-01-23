\ ******************************************************************************
\
\       Name: brkd
\       Type: Variable
\   Category: Utility routines
\    Summary: A flag that indicates whether a system error has occurred
\
\ ******************************************************************************

.brkd

 EQUB 0                 \ A flag to record whether a system error has occurred,
                        \ so we can print it out
                        \
                        \   * 0 = no system error has occurred
                        \
                        \   * &FF = a system error has occurred

