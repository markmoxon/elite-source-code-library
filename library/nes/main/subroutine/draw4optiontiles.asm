\ ******************************************************************************
\
\       Name: Draw4OptionTiles
\       Type: Subroutine
\   Category: Icon bar
\    Summary: Draw four tiles over the top of an icon bar button in the Pause
\             icon bar to change an option icon to a non-default state
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   Y                   The tile column of the top-left tile in the 2x2 block of
\                       four tiles that we want to draw
\
\   SC(1 0)             The address of the nametable entries for the on-screen
\                       icon bar in nametable buffer 0
\
\   SC2(1 0)            The address of the nametable entries for the on-screen
\                       icon bar in nametable buffer 1
\
\ ------------------------------------------------------------------------------
\
\ Returns:
\
\   Y                   Y is preserved
\
\ ******************************************************************************

.Draw4OptionTiles

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 JSR Draw2OptionTiles   \ Call Draw2OptionTiles to draw two tiles over the top
                        \ of the option icon specified in Y

 INY                    \ Increment Y to move along to the next tile column

                        \ Fall through into Draw4OptionTiles to draw two more
                        \ tiles

