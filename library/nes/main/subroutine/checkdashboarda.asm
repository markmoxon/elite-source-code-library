\ ******************************************************************************
\
\       Name: CheckDashboardA
\       Type: Subroutine
\   Category: Screen mode
\    Summary: Check the dashboard while preserving the value of A
\
\ ******************************************************************************

.CheckDashboardA

 PHA                    \ Store the value of A on the stack so we can restore
                        \ it after the macro

 CHECK_DASHBOARD        \ If the PPU has started drawing the dashboard, switch
                        \ to nametable 0 (&2000) and pattern table 0 (&0000)

 PLA                    \ Restore the value of A so it is preserved

 RTS                    \ Return from the subroutine

