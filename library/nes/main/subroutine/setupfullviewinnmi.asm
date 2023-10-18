\ ******************************************************************************
\
\       Name: SetupFullViewInNMI
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Configure the PPU to send tiles for the full screen during VBlank
\
\ ******************************************************************************

.SetupFullViewInNMI

 LDA #116               \ Tell the PPU to send nametable entries up to tile
 STA lastNameTile       \ 116 * 8 = 928 (i.e. to the end of tile row 28) in both
 STA lastNameTile+1     \ bitplanes

                        \ Fall through into SetupViewInNMI_b3 to setup the view
                        \ and configure the NMI to send both bitplanes to the
                        \ PPU during VBlank

