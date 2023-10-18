\ ******************************************************************************
\
\       Name: SetSpaceViewInNMI
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Change the current space view and configure the NMI to send both
\             bitplanes to the PPU during VBlank
\
\ ------------------------------------------------------------------------------
\
\ Arguments:
\
\   X                   The space view to set:
\
\                         * 0 = front
\
\                         * 1 = rear
\
\                         * 2 = left
\
\                         * 3 = right
\
\                         * 4 = generating a new space view
\
\ ******************************************************************************

.SetSpaceViewInNMI

 STX VIEW               \ Set the current space view to X

 LDA #&00               \ Clear the screen and set the view type in QQ11 to &00
 JSR TT66               \ (Space view with no fonts loaded)

 JSR CopyNameBuffer0To1 \ Copy the contents of nametable buffer 0 to nametable
                        \ buffer and tell the NMI handler to send pattern
                        \ entries up to the first free tile

 LDA #80                \ Tell the PPU to send nametable entries up to tile
 STA lastNameTile       \ 80 * 8 = 640 (i.e. to the end of tile row 19) in both
 STA lastNameTile+1     \ bitplanes

 JSR SetupViewInNMI_b3  \ Setup the view and configure the NMI to send both
                        \ bitplanes to the PPU during VBlank

                        \ Fall through into ResetStardust to hide the sprites
                        \ for the stardust

