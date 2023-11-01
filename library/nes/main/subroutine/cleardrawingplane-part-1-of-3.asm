\ ******************************************************************************
\
\       Name: ClearDrawingPlane (Part 1 of 3)
\       Type: Subroutine
\   Category: Drawing the screen
\    Summary: Clear the nametable and pattern buffers for the newly flipped
\             drawing plane
\  Deep dive: Drawing vector graphics using NES tiles
\
\ ------------------------------------------------------------------------------
\
\ This routine is only called when we have just flipped the drawing plane
\ between 0 and 1 in the FlipDrawingPlane routine.
\
\ Arguments:
\
\   X                   The drawing bitplane to clear
\
\ ******************************************************************************

 LDX #0                 \ This code is never called, but it provides an entry
 JSR ClearDrawingPlane  \ point for clearing both bitplanes, which would have
 LDX #1                 \ been useful during development

.ClearDrawingPlane

 SETUP_PPU_FOR_ICON_BAR \ If the PPU has started drawing the icon bar, configure
                        \ the PPU to use nametable 0 and pattern table 0

 LDA bitplaneFlags,X    \ If the flags for the new drawing bitplane are zero
 BEQ cdra2              \ then the bitplane's buffers are already clear (as we
                        \ will have zeroed the flags in cdra1 following a
                        \ successful clearance), so jump to cdra2 to return
                        \ from the subroutine

 AND #%00100000         \ If bit 5 of the bitplane flags is set, then we have
 BNE cdra1              \ already sent all the data to the PPU for this
                        \ bitplane, so jump to cdra1 to clear the buffers in
                        \ their entirety

 JSR cdra3              \ If we get here then bit 5 of the bitplane flags is
                        \ clear, which means we have not already sent all the
                        \ data to the PPU for this bitplane, so call cdra3 below
                        \ to clear out as much buffer space as we can for now

 JMP ClearDrawingPlane  \ Jump back to the start of the routine so we keep
                        \ clearing as much buffer space as we can until all the
                        \ data has been sent to the PPU (at which point bit 5
                        \ will be set and we will take the cdra1 branch instead)

.cdra1

 JSR cdra3              \ If we get here then bit 5 of the bitplane flags is
                        \ set, which means we have already sent all the data to
                        \ the PPU for this bitplane, so call cdra3 below to
                        \ clear out all remaining buffer space for this bitplane

 LDA #0                 \ Set the new drawing bitplane flags as follows:
 STA bitplaneFlags,X    \
                        \   * Bit 2 clear = send tiles up to configured numbers
                        \   * Bit 3 clear = don't clear buffers after sending
                        \   * Bit 4 clear = we've not started sending data yet
                        \   * Bit 5 clear = we have not yet sent all the data
                        \   * Bit 6 clear = only send pattern data to the PPU
                        \   * Bit 7 clear = do not send data to the PPU
                        \
                        \ Bits 0 and 1 are ignored and are always clear

 LDA firstPattern       \ Set the next free pattern number in firstFreePattern
 STA firstFreePattern   \ to the value of firstPattern, which contains the
                        \ number of the first pattern for which we send pattern
                        \ data to the PPU in the NMI handler, so it's also the
                        \ pattern we can start drawing into when we next start
                        \ drawing into tiles

 JMP DrawBoxTop         \ Draw the top of the box into the new drawing bitplane,
                        \ returning from the subroutine using a tail call

.cdra2

 RTS                    \ Return from the subroutine

