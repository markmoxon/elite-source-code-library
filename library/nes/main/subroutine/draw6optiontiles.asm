\ ******************************************************************************
\
\       Name: Draw6OptionTiles
\       Type: Subroutine
\   Category: Icon bar
\    Summary: Draw six tiles over the top of an icon bar button in the Pause
\             icon bar to change an option icon to a non-default state
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   Y                   The tile column of the top-left tile in the block of six
\                       tiles that we want to draw (three across and two high)
\
\   SC(1 0)             The address of the nametable entries for the on-screen
\                       icon bar in nametable buffer 0
\
\   SC2(1 0)            The address of the nametable entries for the on-screen
\                       icon bar in nametable buffer 1
\
\ Returns:
\
\   Y                   Y is preserved
\
\ ******************************************************************************

.Draw6OptionTiles

 JSR Draw2OptionTiles   \ Call Draw2OptionTiles to draw two tiles over the top
                        \ of the option icon specified in Y

 INY                    \ Increment Y to move along to the next tile column

                        \ Fall through into Draw4OptionTiles to draw four more
                        \ tiles

