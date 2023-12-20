\ ******************************************************************************
\
\       Name: StartEffect_b7
\       Type: Subroutine
\   Category: Sound
\    Summary: Call the StartEffect routine
\  Deep dive: Splitting NES Elite across multiple ROM banks
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   A                   The number of the sound effect to make
\
\   X                   The number of the channel on which to make the sound
\                       effect
\
\ ------------------------------------------------------------------------------
\
\ Other entry points:
\
\   RTS8                Contains an RTS
\
\ ******************************************************************************

.StartEffect_b7

 JSR StartEffect_b6     \ Call StartEffect to start making sound effect A on
                        \ channel A

.RTS8

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 RTS                    \ Return from the subroutine

