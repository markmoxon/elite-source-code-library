\ ******************************************************************************
\
\       Name: flagsForClearing
\       Type: Variable
\   Category: Drawing the screen
\    Summary: A bitplane mask to control how bitplane buffer clearing works in
\             the ClearPlaneBuffers routine
\
\ ******************************************************************************

.flagsForClearing

 EQUB %00110000         \ The bitplane flags with ones in this byte must be
                        \ clear for the clearing process in ClearPlaneBuffers
                        \ to be activated
                        \
                        \ So this configuration means that clearing will only be
                        \ attempted on bitplanes where:
                        \
                        \   * We are in the process of sending this bitplane's
                        \     data to the PPU (bit 4 is set)
                        \
                        \   * We have already sent all the data to the PPU for
                        \     this bitplane (bit 5 is set)
                        \
                        \ If both bitplane flags are clear, then the buffers are
                        \ not cleared
                        \
                        \ Note that this is separate from bit 3, which controls
                        \ whether clearing is enabled and which overrides the
                        \ above (bit 2 must be set for any clearing to take
                        \ place)

