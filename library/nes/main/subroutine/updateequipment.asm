\ ******************************************************************************
\
\       Name: UpdateEquipment
\       Type: Subroutine
\   Category: Equipment
\    Summary: Highlight the newly chosen item of equipment, update the Cobra Mk
\             III, redraw the screen and rejoin the main EQSHP routine
\
\ ******************************************************************************

.UpdateEquipment

 JSR HighlightEquipment \ Highlight the item of equipment in XX13

 JSR DrawEquipment_b6   \ Draw the currently fitted equipment onto the Cobra Mk
                        \ III image

 JSR DrawScreenInNMI    \ Configure the NMI handler to draw the screen, so the
                        \ screen gets updated

 JSR WaitForPPUToFinish \ Wait until both bitplanes of the screen have been
                        \ sent to the PPU, so the screen is fully updated and
                        \ there is no more data waiting to be sent to the PPU

 JMP equi1              \ Rejoin the main EQSHP routine at equi1 to continue
                        \ checking for button presses

