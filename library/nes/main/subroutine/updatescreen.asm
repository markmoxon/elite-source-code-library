\ ******************************************************************************
\
\       Name: UpdateScreen
\       Type: Subroutine
\   Category: PPU
\    Summary: Update the screen by sending data to the PPU, either immediately
\             or during VBlank, depending on whether the screen is visible
\  Deep dive: Views and view types in NES Elite
\
\ ******************************************************************************

.UpdateScreen

 LDA screenFadedToBlack \ If bit 7 of screenFadedToBlack is clear then the
 BPL SetupFullViewInNMI \ screen is visible and has not been faded to black, so
                        \ we need to send the view to the PPU in the NMI handler
                        \ to avoid corrupting the screen, so jump to
                        \ SetupFullViewInNMI to configure the NMI handler
                        \ accordingly

                        \ Otherwise the screen has been faded to black, so we
                        \ can fall through into SendViewToPPU to send the view
                        \ straight to the PPU without having to restrict
                        \ ourselves to VBlank

