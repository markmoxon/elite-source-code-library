\ ******************************************************************************
\
\       Name: SetupIconBar
\       Type: Subroutine
\   Category: Icon bar
\    Summary: Set up the icons on the icon bar to show all available options
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The type of the icon bar to set up:
\
\                         * 0 = Docked
\
\                         * 1 = Flight
\
\                         * 2 = Charts
\
\                         * 3 = Pause
\
\                         * 4 = Title screen copyright message
\
\                         * &FF = Hide the icon bar on row 27
\
\ ******************************************************************************

.SetupIconBar

 TAY                    \ Copy the icon bar type into Y

 BMI HideIconBar        \ If the icon bar type has bit 7 set, then this must be
                        \ type &FF, so jump to HideIconBar to hide the icon bar
                        \ on row 27, returning from the subroutine using a tail
                        \ call

 STA iconBarType        \ Set the type of the current icon bar in iconBarType to
                        \ to the new type in A

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 JSR DrawIconBar        \ Draw the icon bar into the nametable buffers for both
                        \ bitplanes

 LDA iconBarType        \ If iconBarType = 0 then jump to SetupIconBarDocked to
 BEQ SetupIconBarDocked \ set up the Docked icon bar, returning from the
                        \ subroutine using a tail call

 CMP #1                 \ If iconBarType = 1 then jump to SetupIconBarFlight to
 BEQ SetupIconBarFlight \ set up the Flight icon bar, returning from the
                        \ subroutine using a tail call

 CMP #3                 \ If iconBarType = 3 then jump to SetupIconBarPause to
 BEQ SetupIconBarPause  \ set up the Pause icon bar, returning from the
                        \ subroutine using a tail call

 CMP #2                 \ If iconBarType <> 2 then it must be 4, so this is the
 BNE SetIconBarButtonsS \ title screen and we need to show the title screen
                        \ copyright message in place of the icon bar, so jump to
                        \ SetIconBarButtons via SetIconBarButtonsS to skip
                        \ setting up any bespoke buttons and simply display the
                        \ copyright message patterns as they are, returning from
                        \ the subroutine using a tail call

 JMP SetupIconBarCharts \ Otherwise iconBarType must be 2, so jump to
                        \ SetupIconBarCharts to set up the Charts icon bar,
                        \ returning from the subroutine using a tail call

